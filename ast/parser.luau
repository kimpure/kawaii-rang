local ast = require("@ast/ast")
local lexer = require("@ast/lexer")

local result = require("@packages/result")

local custom_error = require("@packages/custom_error")
local error_type = custom_error.error_type

local SyntaxError = error_type.SyntaxError

local parser = {}
parser.__index = parser

local ast_type = ast.ast_type
local expression = ast.expression
local statement = ast.statement
local operator_precedence = ast.operator_precedence

local StringAstType = ast_type.StringAstType
local NumberAstType = ast_type.NumberAstType
local BooleanAstType = ast_type.BooleanAstType
local AnyAstType = ast_type.AnyAstType
local FunctionAstType = ast_type.FunctionAstType
local GenericAstType = ast_type.GenericAstType
local TypeofAstType = ast_type.TypeofAstType
local CustomAstType = ast_type.CustomAstType

local LiteralExpression = expression.LiteralExpression
local GroupedExpression = expression.GroupedExpression
local UnaryExpression = expression.UnaryExpression
local VariableExpression = expression.VariableExpression
local FunctionCallExpression = expression.FunctionCallExpression
local BinaryExpression = expression.BinaryExpression

local IfStatement = statement.IfStatement

type TokenType = ast.TokenType
type Token<T> = ast.Token<T>
type OperatorTokenTypes = ast.OperatorTokenTypes

type AstType = ast.AstType
type GenericAstType = ast.GenericAstType
type ParameterAstType = ast.ParameterAstType

type Expression = ast.Expression
type Statement = ast.Statement

type Block = ast.Block

type CustomError = custom_error.CustomError
type CustomErrorInfo = custom_error.CustomErrorInfo

type Result<T, U> = result.Result<T, U>

export type Parser = typeof(setmetatable({} :: {
    cureent: number,
    tokens: { Token<TokenType> },
}, parser))

function parser.create(source: string, file: string?): Result<Parser, CustomError>
    local lexer = lexer.new(source)
    local tokens = lexer:tokenize()

    if tokens:isErr() then
        return result.Err(lexer.custom_error)
    end

    return result.Ok(setmetatable({
        cureent = 1,
        tokens = tokens:unwrap(),
    }, parser))
end

function parser.peek(self: Parser): Token<TokenType>
    return self.tokens[self.cureent]
end

function parser.back(self: Parser): Token<TokenType>
    self.cureent -= 1
    return self.tokens[self.cureent]
end

function parser.advance(self: Parser): Token<TokenType>
    local current = self.cureent
    self.cureent += 1
    return self.tokens[current]
end

function parser.match_next_type(self: Parser, type: TokenType, index: number?): Token<TokenType>?
    if not self.tokens[self.cureent + (index or 1)] then
        return nil
    end

    return if self.tokens[self.cureent + (index or 1)].type == type then
        self.tokens[self.cureent + (index or 1)] 
    else
        nil
end

function parser.parse_generics(self: Parser): Result<{ GenericAstType }, CustomErrorInfo>
    do
        local less = self:advance()
        if less.type ~= "LessTokenType" then
            return result.Err {
                line = less.line,
                current = less.column,
                error_type = SyntaxError,
                error_message = `Expected '<', got '{less.lexeme}'`,
            }
        end
    end

    local generics = {}

    while true do
        local generic = self:advance()

        if generic.type ~= "IdentifierTokenType" then
            return result.Err {
                line = generic.line,
                current = generic.column,
                error_type = SyntaxError,
                error_message = `Expected Identifiers, got '{generic.lexeme}'`,
            }
        end

        generics[#generics + 1] = GenericAstType(generic.lexeme)

        local next_token = self:advance()

        if next_token.type == "CommaTokenType" then
            continue
        end

        if next_token.type == "GreaterTokenType" then
            break
        end

        return result.Err {
            line = next_token.line,
            current = next_token.column,
            error_type = SyntaxError,
            error_message = `Expected ',' or '>', got '{next_token.lexeme}'`,
        }
    end

    return result.Ok(generics)
end

function parser.parse_ast_type(self: Parser): Result<AstType, CustomErrorInfo>
    local start_token = self:advance()

    if start_token.type == "IdentifierTokenType" then
        if start_token.lexeme == "string" then
            return result.Ok(StringAstType)
        end

        if start_token.lexeme == "number" then
            return result.Ok(NumberAstType)
        end

        if start_token.lexeme == "boolean" then
            return result.Ok(BooleanAstType)
        end

        if start_token.lexeme == "any" then
            return result.Ok(AnyAstType)
        end

        local generics: { GenericAstType } = {}
        if self:peek().type == "LessTokenType" then
            local generics_result = self:parse_generics()

            if generics_result:isErr() then
                return result.Err(generics_result:unwrapErr())
            end
           
            generics = generics_result:unwrap()
        end

        return result.Ok(CustomAstType(start_token.lexeme, generics))
    end

    if start_token.type == "TypeofTokenType" then
        local expression_result = self:parse_expression()

        if expression_result:isErr() then
            return result.Err(expression_result:unwrapErr())
        end

        return result.Ok(TypeofAstType(expression_result:unwrap()))
    end

    local generics = {}
    
    if start_token.type == "LessTokenType" then
        self:back()
        
        local generics_result = self:parse_generics()

        if generics_result:isErr() then
            return result.Err(generics_result:unwrapErr())
        end
    
        generics = generics_result:unwrap()

        start_token = self:advance()

        do
            local start_token = start_token
            if start_token.type ~= "LeftParenTokenType" then
                return result.Err {
                    line = start_token.line,
                    current = start_token.column,
                    error_type = SyntaxError,
                    error_message = `Expected '(', got '{start_token.lexeme}'`,
                }
            end
        end
    end

    if start_token.type == "LeftParenTokenType" then
        if not self:match_next_type "ColonTokenType" and 
            not (self:peek().type == "RightParenTokenType" and self:match_next_type("ArrowTokenType"))
        then
            if #generics > 0 then
                self:advance()
                local token = self:peek()
                return result.Err {
                    line = token.line,
                    current = token.column,
                    error_type = SyntaxError,
                    error_message = `Expected ':', got '{token.lexeme}'`,
                }
            end

            local ast_type_result = self:parse_ast_type()

            if ast_type_result:isErr() then
                return ast_type_result
            end

            if self:peek().type ~= "RightParenTokenType" then
                self:advance()

                local token = self:peek()

                return result.Err {
                    line = token.line,
                    current = token.column,
                    error_type = SyntaxError,
                    error_message = `Expected ')', got '{token.lexeme}'`,
                }
            end

            return ast_type_result
        end

        local parameters = {}

        while true do
            local name_token = self:advance()

            if name_token.type == "RightParenTokenType" then
                break
            end

            if name_token.type ~= "IdentifierTokenType" then
                return result.Err {
                    line = name_token.line,
                    current = name_token.column,
                    error_type = SyntaxError,
                    error_message = `Expected Identifiers, got '{name_token.lexeme}'`,
                }
            end
        
            do
                local token = self:advance()
                if token.type ~= "ColonTokenType" then
                    return result.Err {
                        line = token.line,
                        current = token.column,
                        error_type = SyntaxError,
                        error_message = `Expected ':', got '{token.lexeme}'`,
                    }
                end
            end

            local ast_type_result = self:parse_ast_type()

            if ast_type_result:isErr() then
                return ast_type_result
            end
            
            local ast_type = ast_type_result:unwrap()

            parameters[#parameters + 1] = {
                name = name_token.lexeme,
                ast_type = ast_type,
            }

            do 
                local token = self:advance()
            
                if token.type == "CommaTokenType" then
                    continue
                end

                if token.type == "RightParenTokenType" then
                    break
                end

                return result.Err {
                    line = token.line,
                    current = token.column,
                    error_type = SyntaxError,
                    error_message = `Expected ')', got '{token.lexeme}'`,
                }
            end
        end

        do
            local token = self:advance()

            if token.type ~= "ArrowTokenType" then
                return result.Err {
                    line = token.line,
                    current = token.column,
                    error_type = SyntaxError,
                    error_message = `Expected '->', got '{token.lexeme}'`,
                }
            end
        end

        local return_ast_type_result = self:parse_ast_type()

        if return_ast_type_result:isErr() then
            return return_ast_type_result
        end

        local return_ast_type = return_ast_type_result:unwrap()

        return result.Ok(FunctionAstType(parameters, return_ast_type, generics))
    end

    return result.Err {
        line = start_token.line,
        current = start_token.column,
        error_type = SyntaxError,
        error_message = `Expected AstType, got '{start_token.lexeme}'`,
    }
end

function parser.parse_parameters(self: Parser): Result<{ ParameterAstType }, CustomErrorInfo>
    do
        local left_paren = self:advance()
        if left_paren.type ~= "LeftParenTokenType" then
            return result.Err {
                line = left_paren.line,
                current = left_paren.column,
                error_type = SyntaxError,
                error_message = `Expected '(', got '{left_paren.lexeme}'`,
            }
        end
    end

    local parameters = {}

    while true do
        local parameter = self:advance()

        if parameter.type ~= "IdentifierTokenType" then
            return result.Err {
                line = parameter.line,
                current = parameter.column,
                error_type = SyntaxError,
                error_message = `Expected Identifiers, got '{parameter.lexeme}'`,
            }
        end

        do
            local token = self:advance()

            if token.type ~= "ColonTokenType" then
                return result.Err {
                    line = token.line,
                    current = token.column,
                    error_type = SyntaxError,
                    error_message = `Expected ':', got '{token.lexeme}'`,
                }
            end
        end

        local ast_type_result = self:parse_ast_type()

        if ast_type_result:isErr() then
            return result.Err(ast_type_result:unwrapErr())
        end

        parameters[#parameters + 1] = {
            name = parameter.lexeme,
            ast_type = ast_type_result:unwrap(),
        }

        local next_token = self:advance()

        if next_token.type == "CommaTokenType" then
            continue
        end

        if next_token.type == "RightParenTokenType" then
            break
        end

        return result.Err {
            line = next_token.line,
            current = next_token.column,
            error_type = SyntaxError,
            error_message = `Expected ',' or ')', got '{next_token.lexeme}'`,
        }
    end

    return result.Ok(parameters)
end

function parser.parse_expression(self: Parser): Result<Expression, CustomErrorInfo>
    local start_token = self:advance()
    local expression: Expression

    if
        start_token.type == "StringTokenType" or
        start_token.type == "NumberTokenType" or
        start_token.type == "BooleanTokenType" or
        start_token.type == "NilTokenType"
    then
        expression = LiteralExpression(start_token.type, start_token.lexeme)
    end

    if start_token.type == "LeftParenTokenType" then
        local expression_result = self:parse_expression()

        if expression_result:isErr() then
            return expression_result
        end

        do
            local token = self:advance()

            if token.type ~= "RightParenTokenType" then
                return result.Err {
                    line = token.line,
                    current = token.column,
                    error_type = SyntaxError,
                    error_message = `Expected ')', got '{token.lexeme}'`,
                }
            end
        end

        expression = GroupedExpression(expression_result:unwrap())
    end

    if start_token.type == "SubTokenType" then
        local expression_result = self:parse_expression()

        if expression_result:isErr() then
            return expression_result
        end

        expression = UnaryExpression(expression_result:unwrap())
    end

    if start_token.type == "IdentifierTokenType" then
        expression = VariableExpression(start_token.lexeme)
    end

    -- if start_token.type == "FunctionTokenType" then
    --     local parse_parameters = self:parse_parameters()

    --     --// TODO: parser body 구현하면 마저 작성하기!!
    -- end

    if not expression then
        return result.Err {
            line = start_token.line,
            current = start_token.column,
            error_type = SyntaxError,
            error_message = `Expected Expression, got '{start_token.lexeme}'`,
        }
    end

    while true do
        local token = self:peek()

        if token.type == "LeftParenTokenType" then
            self:advance()

            if self:peek().type == "RightParenTokenType" then
                self:advance()
                expression = FunctionCallExpression(expression, {})
                continue
            end

            local parameters = {}

            while true do
                local expression_result = self:parse_expression()

                if expression_result:isErr() then
                    return expression_result
                end

                parameters[#parameters + 1] = expression_result:unwrap()

                local next_token = self:advance()

                if next_token.type == "CommaTokenType" then
                    continue
                end

                if next_token.type == "RightParenTokenType" then
                    break
                end

                return result.Err {
                    line = next_token.line,
                    current = next_token.column,
                    error_type = SyntaxError,
                    error_message = `Expected ',' or ')', got '{next_token.lexeme}'`,
                }
            end

            expression = FunctionCallExpression(expression, parameters)

            continue
        end

        if token.type == "AddTokenType" or
            token.type == "SubTokenType" or
            token.type == "MulTokenType" or
            token.type == "DivTokenType" or
            token.type == "RemainderTokenType" or
            token.type == "GreaterTokenType" or
            token.type == "GreaterEqualTokenType" or
            token.type == "LessTokenType" or
            token.type == "LessEqualTokenType" or
            token.type == "EqualTwoTokenType" or
            token.type == "NotEqualTokenType" or
            token.type == "AndTokenType" or
            token.type == "OrTokenType" 
        then
            self:advance()

            local right_expression_result = self:parse_expression()

            if right_expression_result:isErr() then
                return right_expression_result
            end

            local left_expression = expression
            local right_expression = right_expression_result:unwrap()
            local operator_type: OperatorTokenTypes = token.type
            local operator_level = operator_precedence[operator_type]
            
            if right_expression.type == "BinaryExpression" then
                local right_level = operator_precedence[right_expression.operator]
                if right_level == 0 then
                    expression = BinaryExpression(
                        BinaryExpression(
                            left_expression, 
                            operator_type, 
                            right_expression.left
                        ), 
                        right_expression.operator, 
                        right_expression.right
                    )
                    continue
                elseif operator_level == 0 then
                    expression = BinaryExpression(left_expression, operator_type, right_expression)
                    continue
                else
                    if operator_level < right_level then
                        left_expression = right_expression
                        right_expression = expression
                    end
                end
            end

            expression = BinaryExpression(left_expression, token.type, right_expression)
            continue
        end

        if token.type == "ColonTwoTokenType" then
            if expression.type == "FunctionExpression" then
                return result.Err {
                    line = start_token.line,
                    current = start_token.column,
                    error_type = SyntaxError,
                    error_message = `Function expressions cannot be used as types`,
                }
            end

            self:advance()

            local ast_type_result = self:parse_ast_type()

            if ast_type_result:isErr() then
                return result.Err(ast_type_result:unwrapErr())
            end

            ((expression :: any) :: { annotated_type: AstType }).annotated_type = ast_type_result:unwrap()
            continue
        end

        break
    end

    return result.Ok(expression)
end

function parser.parse_statement(self: Parser): Result<Statement, CustomErrorInfo>
    local start_token = self:advance()

    if start_token.type == "IfTokenType" then
        local body = nil
        local condition = nil

        local else_block:{
            body: Block?,
            type: "ElseBlock"
        } = { type = "ElseBlock" }
        local else_if_blocks: {
            [number]: {
                body: Block,
                condition: Expression,
                type: "ElseIfBlocks"
            }
        } = {}
        
        local first_token = start_token

        while true do
            if first_token.type == "ElseTokenType" then
                if self:peek().type == "IfTokenType" then
                    if else_block.body then
                        return result.Err {
                            line = first_token.line,
                            current = first_token.column,
                            error_type = SyntaxError,
                            error_message = `Expected '}' (to close 'else')`,
                        }
                    end

                    self:advance()

                    local condition_result = self:parse_expression()
        
                    if condition_result:isErr() then
                        return result.Err(condition_result:unwrapErr())
                    end
            
                    do
                        local token = self:advance()
            
                        if token.type ~= "LeftBraceTokenType" then
                            return result.Err {
                                line = token.line,
                                current = token.column,
                                error_type = SyntaxError,
                                error_message = `Expected '\{', got '{token.lexeme}'`,
                            }
                        end
                    end
            
                    local body_result = self:parse_block()
            
                    if body_result:isErr() then
                        return result.Err(body_result:unwrapErr())
                    end
            
                    do
                        local token = self:advance()
            
                        if token.type ~= "RightBraceTokenType" then
                            return result.Err {
                                line = token.line,
                                current = token.column,
                                error_type = SyntaxError,
                                error_message = `Expected '}', got '{token.lexeme}'`,
                            }
                        end
                    end

                    else_if_blocks[#else_if_blocks + 1] = {
                        body = body_result:unwrap(),
                        condition = condition_result:unwrap(),
                        type = "ElseIfBlocks",
                    }

                    continue
                end

                if else_block.body then
                    return result.Err {
                        line = first_token.line,
                        current = first_token.column,
                        error_type = SyntaxError,
                        error_message = "Multiple else clauses are not allowed in a single if statement.",
                    }
                end
                
                do
                    local token = self:advance()
        
                    if token.type ~= "LeftBraceTokenType" then
                        return result.Err {
                            line = token.line,
                            current = token.column,
                            error_type = SyntaxError,
                            error_message = `Expected '\{', got '{token.lexeme}'`,
                        }
                    end
                end
        
                local body_result = self:parse_block()
        
                if body_result:isErr() then
                    return result.Err(body_result:unwrapErr())
                end
        
                do
                    local token = self:advance()
        
                    if token.type ~= "RightBraceTokenType" then
                        return result.Err {
                            line = token.line,
                            current = token.column,
                            error_type = SyntaxError,
                            error_message = `Expected '}', got '{token.lexeme}'`,
                        }
                    end
                end

                else_block.body = body_result:unwrap()

                continue
            end

            local condition_result = self:parse_expression()
        
            if condition_result:isErr() then
                return result.Err(condition_result:unwrapErr())
            end
    
            do
                local token = self:advance()
    
                if token.type ~= "LeftBraceTokenType" then
                    return result.Err {
                        line = token.line,
                        current = token.column,
                        error_type = SyntaxError,
                        error_message = `Expected '\{', got '{token.lexeme}'`,
                    }
                end
            end
            
            local body_result = self:parse_block()
    
            if body_result:isErr() then
                return result.Err(body_result:unwrapErr())
            end
    
            do
                local token = self:advance()
    
                if token.type ~= "RightBraceTokenType" then
                    return result.Err {
                        line = token.line,
                        current = token.column,
                        error_type = SyntaxError,
                        error_message = `Expected '}', got '{token.lexeme}'`,
                    }
                end
            end

            if first_token.type == "IfTokenType" then
                if body then
                    return result.Err {
                        line = first_token.line,
                        current = first_token.column,
                        error_type = SyntaxError,
                        error_message = "Multiple if clauses are not allowed in a single if statement.",
                    }
                end

                body = body_result:unwrap()
                condition = condition_result:unwrap()
            end

            break
        end

        if not body then
            return result.Err {
                line = start_token.line,
                current = start_token.column,
                error_type = SyntaxError,
                error_message = `Expected IfStatement, got '{start_token.lexeme}'`,
            }
        end

        return result.Ok(IfStatement(condition, body, else_if_blocks, { 
            body = else_block.body or {}, 
            type = "ElseBlock" 
        }))
    end
end

function parser.parse_block(self: Parser): Result<Block, CustomErrorInfo>
    return 0 :: any
end

local p, s = parser.create [[
//(as: string) -> (() -> () -> string)
//<KT>(s: string) -> () -> string
//() -> string
//a<T>

//("this is string!!")

//("string")[1]

//(1 + 3 * 3) < 0 + 1

("string")()()()() < (0 :: string)

//vars :: string
//-0 :: number
]], os.clock()
local generics = p:unwrap():parse_expression()

print(
    generics:isErr() and 
    generics:unwrapErr() or 
    generics:unwrap()
, os.clock() - s)

-- print("\n", p:unwrap():peek())

return parser
