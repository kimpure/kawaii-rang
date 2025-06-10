local ast = require('./ast')
local lexer = require('./lexer')

export type Token = lexer.Token
export type TokenType = lexer.TokenType

export type Expression = ast.Expression
export type AstNode = ast.AstNode

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

function parser.parse_tuple(self: Parser)
    local parameter_tokens = {}

    while true do
        local token = self:next()

        parameter_tokens[#parameter_tokens + 1] = token.lexeme

        if self:peekable().type ~= 'Comma' then
            break
        else
            self:next()
        end
    end

    return parameter_tokens
end

function parser.parse_parameter(self: Parser)
    if self:next().type == 'LeftParen' then
        local tuple = self:parse_tuple()

        if tuple[1] == ')' then
            return {}
        end

        if self:next().type == 'RightParen' then
            return tuple
        end
    end

    error('is not function')
end

function parser.parse_expression(self: Parser): Expression
    local token = self:next()
    local expression: Expression

    if token.type == 'Number' or token.type == 'String' or token.type == 'Boolean' or token.type == 'Nil' then
        return token.type
    end

    if token.type == 'Identifier' then
        expression = {
            name = token.lexeme
        }
    end

    while self:peekable().type == 'LeftParen' or self:peekable().type == 'LeftBrack' do
        if self:peekable().type == 'LeftParen' then
            expression = {
                name = expression,
                args = self:parse_parameter(),
            }
        end

        if self:peekable().type == 'LeftBrack' then
            self:next()
            expression = {
                target = {
                    name = expression,
                },
                index = self:parse_expression(),
            }
            self:next()
        end
    end

    return expression
end

function parser.parse(self: Parser)
    while self:peekable() do

    end
end

return parser
