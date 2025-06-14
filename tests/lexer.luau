local lexer = require('../ast/lexer')

local lex = lexer.new('"짜안"\n')
    
local tokens = {}

while not lex:is_end() do
    tokens[#tokens + 1] = lex:next_token()
end

print('result: \n', tokens)
