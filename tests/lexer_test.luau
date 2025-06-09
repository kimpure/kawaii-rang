local lexer = require('../src/lexer')

local source = [[
let a = "String"

if not a {
    let b = 10
}
]]

local l = lexer.new(source)

local st = ''

while not l:is_end() do
    local tk = l:next_token()
    st ..= tk.type .. '|'
end

print(st)
