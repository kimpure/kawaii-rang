local ast = require('./ast')
local lexer = require('./lexer')

export type Token = lexer.Token
export type TokenType = lexer.TokenType

export type AstNode = ast.AstNode
export type DataType = ast.DataType

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

local function is_data_type(token: Token)
    return
        token.type == 'Number' or 
        token.type == 'String' or
        token.type == 'Boolean' or
        token.type == 'Nil'
end

local function parse_initial_tuple(tokens: TokensPeekable)
    local initial_tokens = { tokens:next() }
    
    if initial_tokens[1].type ~= "Identifier" then
        error('is not initial')
    end

    while tokens:peekable().type == 'Comma' do
        tokens:next()

        if tokens:peekable().type ~= "Identifier" then
            error('is not initial')
        end
        initial_tokens[#initial_tokens + 1] = tokens:next()
    end

    return initial_tokens
end

local function parse_value_tuple(tokens: TokensPeekable)
    local initial_tokens = { tokens:peekable() }
    
    if not is_data_type(initial_tokens[1]) then
        return {}
    end

    tokens:next()
    while tokens:peekable().type == 'Comma' do
        tokens:next()

        if not is_data_type(tokens:peekable()) then
            error('is not initial')
        end
        initial_tokens[#initial_tokens + 1] = tokens:next()
    end

    return initial_tokens
end

local function parse_let(tokens: TokensPeekable)
    local initial_tokens = parse_initial_tuple(tokens)

    if tokens:peekable().type ~= 'Equal' then
        if tokens:peekable().type ~= 'SemiColon' then
            if initial_tokens[#initial_tokens].line >= tokens:peekable().line then
                error('let equal error')
            end
        end
    end

    tokens:next()
    
    local initial_values = parse_value_tuple(tokens)
    
    for i=1, #initial_tokens do
        if not initial_values[i] then
            initial_values[i] = {
                type = 'Nil',
                lexeme = 'nil',
                line = #initial_values == 0 and initial_tokens[#initial_tokens].line or initial_values[#initial_values].line
            }
        end
    end

    if tokens:peekable().line <= initial_values[#initial_values].line and tokens:peekable().type ~= 'SemiColon' then
        error('line error')
    end
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

return {
    extract_body = extract_body,
}
