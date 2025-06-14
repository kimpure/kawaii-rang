local lexer = require('../ast/lexer')
local parser = require('../ast/parser')

local lex = lexer.new('var a = "안뇽"\n')
    
local tokens = {}

while not lex:is_end() do
    tokens[#tokens + 1] = lex:next_token()
end

local par = parser.new(tokens)

print('result: \n', par:parse_ast_node())
