local lexer = require('../src/lexer')
local parser = require('../src/parser')
local fs = require('@lune/fs')

local variable_source = fs.readFile('kawi/variable.kawi')

local lex = lexer.new(variable_source)
    
local tokens = {}

while not lex:is_end() do
    tokens[#tokens + 1] = lex:next_token()
end

local par = parser.new(tokens)

print('result: \n', par:parse_ast_node())
