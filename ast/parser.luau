local ast = require('./ast')
local lexer = require('./lexer')

local parser = {}
parser.__index = parser

type Lexer = lexer.Lexer
type Token = ast.Token<ast.TokenType>

export type Parser = typeof(setmetatable({} :: {
    tokens: { Token }
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
        tokens = tokens,
    }, parser)
end

function parser.parse()
    
end

return parser
