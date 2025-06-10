local lexer = require('../src/lexer')
local parser = require('../src/parser')

local source = [[
"String" 0 asd(a, b, c) q[qwe()]
]]

local l = lexer.new(source)

local tokens = {}

while not l:is_end() do
    tokens[#tokens + 1] = l:next_token()
end

local p = parser.new(tokens)

parser.parse_expression(p)
parser.parse_expression(p)
parser.parse_expression(p)
parser.parse_expression(p)

-- parser.extract_body(tokens)
