local ast = require('./ast')
local lexer = require('./lexer')

export type Token = lexer.Token
export type TokenType = lexer.TokenType

export type Expression = ast.Expression
export type LiteralExpression = ast.LiteralExpression
export type FunctionCallExpression = ast.FunctionCallExpression

export type AstNode = ast.AstNode
export type ParameterNode = ast.ParameterNode

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

function parser.parse_identifier(self: Parser): ParserIdentifier
    local identifier = self:next()

    local next_token = self:peekable()

    if identifier.type ~= 'Identifier' then
        error('identifier not match: ' .. identifier.lexeme)
    end

    if next_token.type == 'LeftParen' then
        return {
            identifier = identifier,
            type = 'Function',
        } :: any
    end

    if next_token.type == 'LeftBrack' then
        return {
            identifier = identifier,
            type = 'IndexAccess',
        } :: any
    end

    return {
        identifier = identifier,
        type = 'Variable',
    } :: any
end

function parser.parse_function_deep_call(self: Parser, expression: Expression): FunctionCallExpression
    local function_expression = {
        expression = expression,
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

    if self:peekable().type == 'LeftParen' then
        return self:parse_function_deep_call(function_expression)
    end

    return function_expression
end

function parser.parse_expression(self: Parser): Expression
    local token = self:peekable()
    
    if token.type == 'String' or token.type == 'Number' or token.type == 'Boolean' or token.type == 'Nil' then
        self:next()
        return {
            data_type = token.type,
            lexeme = token.lexeme,
            line = token.line,
            type = 'LiteralExpressions',
        }
    end

    local identifier_info = self:parse_identifier()

    if identifier_info.type == 'Variable' then
        return {
            name = identifier_info.identifier.lexeme,
            type = 'VariableExpression',
        }
    end

    if identifier_info.type == 'Function' then
        return self:parse_function_deep_call(identifier_info.identifier)
    end

    error('parser error (any)')
end

return parser
