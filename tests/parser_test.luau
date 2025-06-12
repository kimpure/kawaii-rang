local lexer = require('../src/lexer')
local parser = require('../src/parser')

local test_source = {
    'a((as))\n',
    '{ ("as"), { asd }, ww + 1 }\n',
    "(a() < a) + (1) + 2\n",
    "a[asd[1]][2][3](a)\n",
    'as(qwe, "qwe")(0)()()()()()()\n',
    "as(a(), b)\n",
    '"String" 0 asd(a, b, c) q[qwe()]\n',
}

-- for i=1, #test_source do
--     print('test: ', i)

    -- local lex = lexer.new(test_source[i])
    
    -- local tokens = {}
    
    -- while not lex:is_end() do
    --     tokens[#tokens + 1] = lex:next_token()
    -- end
    
    -- local par = parser.new(tokens)
    
    -- print('result: \n', par:parse_expression())
-- end
local lex = lexer.new('var a = (1 + 3) * 3\n')
    
local tokens = {}

while not lex:is_end() do
    tokens[#tokens + 1] = lex:next_token()
end

local par = parser.new(tokens)

print('result: \n', par:parse_variable_node())