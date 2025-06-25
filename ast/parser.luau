local ast = require("@ast/ast")
local lexer = require("@ast/lexer")
local custom_error = require("@packages/custom_error")

local parser = {}
parser.__index = parser

type Lexer = lexer.Lexer
type Token = ast.Token<ast.TokenType>

type CustomError = custom_error.CustomError

export type Parser = typeof(setmetatable({} :: {
    cureent: number,
    tokens: { Token },
    custom_error: CustomError,
}, parser))

function parser.create(source: string): Parser
    local lexer_class = lexer.new(source)
    local error_class = custom_error.new "main.kawi"
    
    local tokens = {}
    while true do
        local token = lexer_class:next_token()

        if not token then
            for i=1, #lexer_class.custom_error.errors do
                error_class:push(lexer_class.custom_error.errors[i])
            end

            break
        end

        if token.type == 'EofLexerToken' then
            break
        end

        tokens[#tokens + 1] = token
    end

    return setmetatable({
        cureent = 1,
        tokens = tokens,
        custom_error = error_class,
    }, parser)
end

function parser.peek(self: Parser)
    return self.tokens[self.cureent]
end

function parser.next(self: Parser)
    local current = self.cureent
    self.cureent += 1
    return self.tokens[current]
end

local parse = parser.create [[

var a = 100
var b = ""::

]]

print(parse.custom_error:stdout(), parse.tokens)

return parser
