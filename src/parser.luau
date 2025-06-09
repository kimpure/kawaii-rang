local ast = require('./ast')
local lexer = require('./lexer')

export type Token = lexer.Token
export type TokenType = lexer.TokenType

export type AstType = ast.AstType

local tokens_peekable = {}
tokens_peekable.__index = tokens_peekable

export type TokensPeekable = typeof(setmetatable({} :: {
    tokens: { Token },
    index: number,
}, tokens_peekable))

function tokens_peekable.new(tokens: { Token }): TokensPeekable
    return setmetatable({
        tokens = tokens,
        index = 1,
    }, tokens_peekable)
end

function tokens_peekable.peekable(self: TokensPeekable)
    return self.tokens[self.index]
end

function tokens_peekable.next(self: TokensPeekable)
    self.index += 1
    return self.tokens[self.index - 1]
end

local function ast_token_type(token_type: TokenType): AstType
    if token_type == 'Number' then
        return "Number"
    end

    if token_type == "Boolean" then
        return "Boolean"
    end

    if token_type == "String" then
        return "String"
    end

    if token_type == "Array" then
        return "Array"
    end

    if token_type == "Object" then
        return "Object"
    end

    error('token type not match')
end

local function parse_let(tokens: TokensPeekable)
    local name = tokens:next()

    -- local ast_type = ast_token_type(tokens.)
end

local function extract_body(tokens: { Token })
    local body = {}
    local tokens = tokens_peekable.new(tokens)
    
    for i=1, #tokens.tokens do
        local token = tokens:peekable()

        if token.type == 'Let' then
            tokens:next()
            body[#body + 1] = parse_let(tokens)
        end
    end

end
