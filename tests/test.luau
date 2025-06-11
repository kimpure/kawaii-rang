local lexer = require('../src/lexer')
local parser = require('../src/parser')

local source = "(a() < a) + (1) + 2\n"
-- "\na[asd[1]][2][3](a)"
-- [[
-- as(qwe, "qwe")(0)()()()()()()
-- ]]
-- [[
-- as(a(), b)
-- ]] 
-- [[
-- "String" 0 asd(a, b, c) q[qwe()]
-- ]]

local l = lexer.new(source)

local tokens = {}

while not l:is_end() do
    tokens[#tokens + 1] = l:next_token()
end

local p = parser.new(tokens)

print(p:parse_expression())
