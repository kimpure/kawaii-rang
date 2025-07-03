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

type TokenType = ast.TokenType
type Token<T> = ast.Token<T>

type AstType = ast.AstType
type GenericAstType = ast.GenericAstType
type ParameterAstType = ast.ParameterAstType

type Expression = ast.Expression

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
        return result.Ok(LiteralExpression(start_token.type, start_token.lexeme))
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

        return result.Ok(UnaryExpression(expression_result:unwrap()))
    end

    if start_token.type == "IdentifierTokenType" then
        expression = VariableExpression(start_token.lexeme)
    end

    -- if start_token.type == "FunctionTokenType" then
    --     local parse_parameters = self:parse_parameters()

    --     --// TODO: parser body 구현하면 마저 작성하기!!
    -- end


end

local p, s = parser.create [[
//(as: string) -> (() -> () -> string)
//<KT>(s: string) -> () -> string
//() -> string
//a<T>

//("this is string!!")

string[]

]], os.clock()
local generics = p:unwrap():parse_ast_type()

print(
    generics:isErr() and 
    generics:unwrapErr() or 
    generics:unwrap()
, os.clock() - s)

-- print("\n", p:unwrap():peek())

return parser
