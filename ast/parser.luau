local ast = require("@ast/ast")
local lexer = require("@ast/lexer")
local result = require("@packages/result")

local custom_error = require("@packages/custom_error")
local error_type = custom_error.error_type
local SyntaxError = error_type.SyntaxError

local parser = {}
parser.__index = parser

local ast_type = ast.ast_type
local ast_utils = ast.ast_utils
local expression = ast.expression

local GenericAstType = ast_type.GenericAstType

type Token = ast.Token<ast.TokenType>
type AstType = ast.AstType
type GenericAstType = ast.GenericAstType

type CustomError = custom_error.CustomError
type CustomErrorInfo = custom_error.CustomErrorInfo

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

function parser.peek(self: Parser): Token
    return self.tokens[self.cureent]
end

function parser.advance(self: Parser): Token
    local current = self.cureent
    self.cureent += 1
    return self.tokens[current]
end

function parser.parse_generics(self: Parser): Result<{ GenericAstType }, CustomErrorInfo>
    self:advance() --// <

    local generics = {}

    while true do
        local generic = self:advance()

        if generic.type ~= "IdentifierTokenType" then
            return result.Err {
                line = generic.line,
                current = generic.column,
                error_type = SyntaxError,
                error_message = `Expected Identifiers, got '{generic.lexeme}'`,
            }
        end

        generics[#generics + 1] = GenericAstType(generic.lexeme)

        local next_token = self:advance()

        if next_token.type == "CommaTokenType" then
            continue
        end

        if next_token.type == "GreaterTokenType" then
            break
        end

        return result.Err {
            line = generic.line,
            current = generic.column,
            error_type = SyntaxError,
            error_message = `Expected Comma or Greater, got '{next_token.lexeme}'`,
        }
    end

    return result.Ok(generics)
end

function parser.parse_ast_type(self: Parser)
    
end

function parser.parse_expression(self: Parser)
    
end

local p = parser.create [[
<Res,>
]]
local generics = p:unwrap():parse_generics()
print(generics:isErr() and generics:unwrapErr() 
    or generics:unwrap())

return parser
