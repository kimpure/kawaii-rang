local ast = require('./ast')
local lexer = require('./lexer')

local parser = {}
parser.__index = parser

type Lexer = lexer.Lexer
type Token = ast.Token<ast.TokenType>

export type Parser = typeof(setmetatable({} :: {
    cureent: number,
    tokens: { Token },
}, parser))

function parser.create(source: string): Parser
    local tokens = {}
    local lexer_class = lexer.new(source)

    while true do
        local token = lexer_class:next_token()

        if token.type == 'EofLexerToken' then
            break
        end

        tokens[#tokens + 1] = token
    end

    return setmetatable({
        cureent = 1,
        tokens = tokens,
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

return parser
