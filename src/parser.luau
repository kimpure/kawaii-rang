local ast = require('./ast')
local lexer = require('./lexer')

export type Token = lexer.Token
export type TokenType = lexer.TokenType

export type Expression = ast.Expression
export type LiteralExpression = ast.LiteralExpression
export type FunctionCallExpression = ast.FunctionCallExpression
export type IndexAccessExpression = ast.IndexAccessExpression
export type BinaryExpression = ast.BinaryExpression
export type GroupedExpression = ast.GroupedExpression

export type AstNode = ast.AstNode
export type ParameterNode = ast.ParameterNode

export type Operator = ast.Operator
export type ParserIdentifier = ast.ParserIdentifier

local parser = {}
parser.__index = parser

export type Parser = typeof(setmetatable({} :: {
    tokens: { Token },
}, parser))

function parser.new(tokens: { Token }): Parser
    return setmetatable({
        tokens = tokens,
        
        _index = 1,
    }, parser)
end

function parser.peekable(self: Parser)
    return self.tokens[(self::any)._index]
end

function parser.next(self: Parser)
    local c = self.tokens[(self::any)._index]
    ;(self::any)._index += 1
    return c
end

function parser.is_data_type(self: Parser)
    local data_type = self:peekable().type
    return 
        data_type == 'String' or 
        data_type == 'Number' or 
        data_type == 'Boolean' or 
        data_type == 'Nil'
end

function parser.is_operator_token(self: Parser)
    local operator_type = self:peekable().type
    return operator_type == 'Add' or 
        operator_type == 'Sub' or 
        operator_type == 'Mul' or 
        operator_type == 'Div' or 
        operator_type == 'GreaterEqual' or 
        operator_type == 'LessEqual' or 
        operator_type == 'Greater' or 
        operator_type == 'Less' or 
        operator_type == 'Equal' or 
        operator_type == 'NotEqual' or 
        operator_type == 'And' or 
        operator_type == 'Or' 
end

function parser.parse_tuple_expression(self: Parser): { Expression }
    local expressions = {}
    
    while true do
        expressions[#expressions + 1] = self:parse_expression()

        if self:peekable() and self:peekable().type ~= 'Comma' then
            break
        end

        self:next()
    end
    
    return expressions
end

function parser.parse_expression_function_call(self: Parser, target_expression: Expression): FunctionCallExpression
    local function_expression = {
        expression = target_expression,
        args = {},
        type = "FunctionCallExpression",
    } :: FunctionCallExpression

    if self:next().type ~= 'LeftParen' then
        error('is not function : ' .. self:peekable().lexeme)
    end
    
    if self:peekable().type ~= 'RightParen' then
        local parameters = self:parse_tuple_expression()
        
        for i=1, #parameters do
            parameters[i] = {
                expression = parameters[i],
                type = "ParameterNode"
            }
        end
    
        function_expression.args = parameters :: any
    
        if self:peekable().type ~= 'RightParen' then
            error('not close paren of function : ' .. self:peekable().lexeme)
        end
    end

    self:next()

    return function_expression
end

function parser.parse_expression_index_access(self: Parser, target: Expression): IndexAccessExpression
    local index_access_expression = {
        target = target,
        type = "IndexAccessExpression",
    } :: IndexAccessExpression

    if self:next().type ~= 'LeftBrack' then
        error('is not function : ' .. self:peekable().lexeme)
    end
    
    if self:peekable().type == 'RightBrack' then
        error('is not index : ' .. self:peekable().lexeme)
    end

    index_access_expression.index = self:parse_expression()

    if self:next().type ~= 'RightBrack' then
        error('not close paren of index access : ' .. (index_access_expression.index::any).lexeme)
    end

    return index_access_expression
end

function parser.parse_expression_binary(self: Parser, left_expression: Expression): BinaryExpression
    if not self:is_operator_token() then
        error('is not operator : ' .. self:peekable().lexeme)
    end

    local operator = self:next()

    return {
        left = left_expression,
        right = self:parse_expression(),
        operator = operator.type :: Operator,
        type = "BinaryExpression"
    }
end

function parser.parse_expression_grouped(self: Parser, expression: Expression): GroupedExpression
    return {
        expression = expression,
        type = "GroupedExpression",
    }
end

function parser.parse_identifier_expression(self: Parser): Expression
    local expression: Expression = self:next()

    while true do
        if self:peekable().type == 'LeftBrack' then
            expression = self:parse_expression_index_access(expression)
            continue
        end

        if self:peekable().type == 'LeftParen' then
            expression = self:parse_expression_function_call(expression)
            continue
        end

        if self:is_operator_token() then
            expression = self:parse_expression_binary(expression)
            continue
        end

        break
    end

    return expression
end

function parser.parse_identifier_expression_with_expression(self: Parser, expression: Expression): Expression
    while true do
        if self:peekable().type == 'LeftBrack' then
            expression = self:parse_expression_index_access(expression)
            continue
        end

        if self:peekable().type == 'LeftParen' then
            expression = self:parse_expression_function_call(expression)
            continue
        end

        if self:is_operator_token() then
            expression = self:parse_expression_binary(expression)
            continue
        end

        break
    end

    return expression
end

function parser.parse_expression(self: Parser): Expression
    local is_grouped = self:peekable().type == 'LeftParen'

    if is_grouped then
        self:next()
    end

    local expression: Expression

    if self:is_data_type() then
        local data_type = self:next()
        expression = {
            data_type = data_type.type,
            lexeme = data_type.lexeme,
            line = data_type.line,
            type = 'LiteralExpressions',
        }
    else
        expression = self:parse_identifier_expression()
    end
    
    if is_grouped then
        expression = self:parse_expression_grouped(expression)

        if self:peekable().type ~= 'RightParen' then
            error('missing right paren: ' .. self:peekable().lexeme)
        end

        self:next()

        expression = self:parse_identifier_expression_with_expression(expression)
    end

    return expression
end

return parser
