local lexer = require('../src/lexer')
local parser = require('../src/parser')

local source = [[
let a, c = "String"

if not a {
    let b = 10
}
]]

local l = lexer.new(source)

local tokens = {}

while not l:is_end() do
    tokens[#tokens + 1] = l:next_token()
end

parser.extract_body(tokens)
