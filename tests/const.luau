local lexer = require('../src/lexer')
local parser = require('../src/parser')
local fs = require('@lune/fs')

local const_source = fs.readFile('kawi/const.kawi')

local lex = lexer.new(const_source)
    
local tokens = {}

while not lex:is_end() do
    tokens[#tokens + 1] = lex:next_token()
end

local par = parser.new(tokens)

print('result: \n', par:parse_ast_node())
