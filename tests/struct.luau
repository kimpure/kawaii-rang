local lexer = require('../ast/lexer')
local parser = require('../ast/parser')
local fs = require('@lune/fs')

local struct_source = fs.readFile('kawi/struct.kawi')

local lex = lexer.new(struct_source)
    
local tokens = {}

while not lex:is_end() do
    tokens[#tokens + 1] = lex:next_token()
end

local par = parser.new(tokens)

print('result: \n', par:parse_ast_node())
