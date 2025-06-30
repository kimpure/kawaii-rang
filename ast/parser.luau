local ast = require("@ast/ast")
local lexer = require("@ast/lexer")
local custom_error = require("@packages/custom_error")
local result = require("@packages/result")

local parser = {}
parser.__index = parser

type Lexer = lexer.Lexer
type Token = ast.Token<ast.TokenType>

type CustomError = custom_error.CustomError
type Result<T, U> = result.Result<T, U>

export type Parser = typeof(setmetatable({} :: {
    cureent: number,
    tokens: { Token },
}, parser))

function parser.create(source: string, file: string?): Result<Parser, CustomError>
    local lexer = lexer.new(source)
    local tokens = lexer:tokenize()

    if tokens:isErr() then
        return result.Err(lexer.custom_error)
    end

    return result.Ok(setmetatable({
        cureent = 1,
        tokens = tokens:unwrap(),
    }, parser))
end

function parser.peek(self: Parser)
    return self.tokens[self.cureent]
end

function parser.next(self: Parser)
    local current = self.cureent
    self.cureent += 1
    return self.tokens[current]
end

function parser.parse_expression(self: Parser)
    
end

local start = os.clock()
local lex = lexer.new [[

var a = 100
var b = ""

function a() {}
//$

]]

print(lex:tokenize():unwrap())
print("endof", os.clock() - start)

return parser
