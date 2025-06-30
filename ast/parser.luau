local ast = require("@ast/ast")
local lexer = require("@ast/lexer")
local custom_error = require("@packages/custom_error")
local result = require("@packages/result")

local parser = {}
parser.__index = parser

local ast_utils = ast.ast_utils
local expression = ast.expression

type Token = ast.Token<ast.TokenType>
type CustomError = custom_error.CustomError
type Result<T, U> = result.Result<T, U>

export type Parser = typeof(setmetatable({} :: {
    cureent: number,
    tokens: { Token },
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

function parser.peek(self: Parser): Token
    return self.tokens[self.cureent]
end

function parser.advance(self: Parser): Token
    local current = self.cureent
    self.cureent += 1
    return self.tokens[current]
end

function parser.parse_expression(self: Parser)
    local token = self:advance()

    do
        local literal_token = ast_utils.literal_token(token)
        
        if literal_token then
            return expression.LiteralExpression(literal_token)
        end
    end

end

return parser
