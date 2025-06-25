local ast = require("@ast/ast")
local custom_error = require("@packages/custom_error")

local error_type = custom_error.error_type

local LexicalError = error_type.LexicalError

local IdentifierToken = ast.IdentifierToken
local NumberToken = ast.NumberToken
local StringToken = ast.StringToken
local FunctionToken = ast.FunctionToken
local BooleanToken = ast.BooleanToken
local NilToken = ast.NilToken
local ClassToken = ast.ClassToken
local VarToken = ast.VarToken
local IfToken = ast.IfToken
local ElseToken = ast.ElseToken
local WhileToken = ast.WhileToken
local ForToken = ast.ForToken
local ReturnToken = ast.ReturnToken
local AddToken = ast.AddToken
local SubToken = ast.SubToken
local MulToken = ast.MulToken
local DivToken = ast.DivToken
local RemainderToken = ast.RemainderToken
local AndToken = ast.AndToken
local OrToken = ast.OrToken
local NotToken = ast.NotToken
local DotToken = ast.DotToken
local DotTwoToken = ast.DotTwoToken
local CommaToken = ast.CommaToken
local SemiColonToken = ast.SemiColonToken
local ColonToken = ast.ColonToken
local ColonTwoToken = ast.ColonTwoToken
local EqualToken = ast.EqualToken
local EqualTwoToken = ast.EqualTwoToken
local NotEqualToken = ast.NotEqualToken
local LessToken = ast.LessToken
local LessEqualToken = ast.LessEqualToken
local GreaterToken = ast.GreaterToken
local GreaterEqualToken = ast.GreaterEqualToken
local EqualAddToken = ast.EqualAddToken
local EqualSubToken = ast.EqualSubToken
local EqualMulToken = ast.EqualMulToken
local EqualDivToken = ast.EqualDivToken
local LeftParenToken = ast.LeftParenToken
local RightParenToken = ast.RightParenToken
local LeftBraceToken = ast.LeftBraceToken
local RightBraceToken = ast.RightBraceToken
local LeftBrackToken = ast.LeftBrackToken
local RightBrackToken = ast.RightBrackToken
local ArrowToken = ast.ArrowToken
local ExtendsToken = ast.ExtendsToken
local TypeToken = ast.TypeToken
local PubToken = ast.PubToken
local EofToken = ast.EofToken

type TokenType = ast.TokenType
type Token = ast.Token<TokenType>

type CustomError = custom_error.CustomError

local lexer = {}
lexer.__index = lexer

export type Lexer = typeof(setmetatable({} :: {
    source: string,
    current: number,
    line: number,
    line_current: number,

    custom_error: CustomError,
}, lexer))

function lexer.new(source: string): Lexer
    return setmetatable({
        source = source,
        current = 0,
        line = 1,
        line_current = 0,

        custom_error = custom_error.new(),
    }, lexer)
end

function lexer.is_end(self: Lexer)
    local len = #self.source
    return self.current >= len
end

function lexer.advance(self: Lexer)
    if self:is_end() then
        return ""
    end

    local ch = utf8.char(utf8.codepoint(string.sub(self.source, self.current + 1), 1))
    self.current += #ch
    self.line_current += #ch
    
    return ch
end

function lexer.peek(self: Lexer)
    if self:is_end() then
        return ""
    end

    return utf8.char(utf8.codepoint(string.sub(self.source, self.current + 1), 1))
end

function lexer.match_next(self: Lexer, exec: string)
    if self:is_end() then
        return false
    end

    if self:peek() ~= exec then
        return false
    end

    self:advance()
    return true
end

function lexer.skip_space(self: Lexer)
    while not self:is_end() do
        local char = self:peek()

        if char == " " or char == "\r" or char == "\t" then
            self:advance()
        elseif char == "\n" then
            self.line += 1
            self.line_current = 0
            self:advance()
        else
            break
        end
    end
end

function lexer.read_string(self: Lexer)
    if self:peek() == "\"" then
        self:advance()
        return ""
    end

    local str = ""

    while self:peek() ~= "\"" do
        str ..= self:advance()

        if self:is_end() then
            self.custom_error:push {
                line = self.line,
                cureent = self.line_current,
                error_type = LexicalError,
                error_message = "unterminated string constant"
            }

            return ""
        end
    end

    self:advance()

    return str
end

function lexer.read_number(self: Lexer)
    local start = self.current

    while not self:is_end() and tonumber(self:peek()) do
        self:advance()
    end

    return self.source:sub(start, self.current)
end

function lexer.skip_comment(self: Lexer)
    while not self:is_end() and self:peek() ~= "\n" do
        self:advance()
    end
end

function lexer.read_identifier(self: Lexer)
    local start = self.current

    while not self:is_end() do
        local char = self:peek()

        if tonumber(char) or char == "_" or not string.find(char, "%A") then
            self:advance()
        else
            break
        end
    end

    return self.source:sub(start, self.current)
end

function lexer.next_token(self: Lexer): Token?
    self:skip_space()

    if self:is_end() then
        return EofToken("Eof", self.line, self.line_current)
    end

    local char = self:advance()

    if char == "+" then
        if self:match_next"=" then
            return EqualAddToken("+=", self.line, self.line_current)
        end

        return AddToken("+", self.line, self.line_current)
    end

    if char == "-" then
        if self:match_next"=" then
            return EqualSubToken("-=", self.line, self.line_current)
        end

        return SubToken("-", self.line, self.line_current)
    end

    if char == "*" then
        if self:match_next"=" then
            return EqualMulToken("*=", self.line, self.line_current)
        end

        return MulToken("*", self.line, self.line_current)
    end

    if char == "/" then
        if self:match_next"/" then
            self:skip_comment()

            return self:next_token()
        end

        if self:match_next"=" then
            return EqualDivToken("/=", self.line, self.line_current)
        end

        return DivToken("/", self.line, self.line_current)
    end

    if char == "%" then
        return RemainderToken("%", self.line, self.line_current)
    end

    if char == ";" then
        return SemiColonToken(";", self.line, self.line_current)
    end

    if char == ":" then
        if self:match_next":" then
            ColonTwoToken("::", self.line, self.line_current)
        end

        return ColonToken(":", self.line, self.line_current)
    end

    if char == "." then
        if self:match_next "." then
            return DotTwoToken("..", self.line, self.line_current)
        end

        return DotToken(".", self.line, self.line_current)
    end

    if char == "<" then
        if self:match_next"=" then
            return LessEqualToken("<=", self.line, self.line_current)
        end

        return LessToken("<", self.line, self.line_current)
    end

    if char == ">" then
        if self:match_next"=" then
            return GreaterEqualToken(">=", self.line, self.line_current)
        end

        return GreaterToken(">", self.line, self.line_current)
    end

    if char == "(" then
        return LeftParenToken("(", self.line, self.line_current)
    end
    
    if char == ")" then
        return RightParenToken(")", self.line, self.line_current)
    end

    if char == "{" then
        return LeftBraceToken("{", self.line, self.line_current)
    end
    
    if char == "}" then
        return RightBraceToken("}", self.line, self.line_current)
    end

    if char == "[" then
        return LeftBrackToken("[", self.line, self.line_current)
    end
    
    if char == "]" then
        return RightBrackToken("]", self.line, self.line_current)
    end

    if char == "=" then
        if self:match_next"=" then
            return EqualTwoToken("==", self.line, self.line_current)
        end

        return EqualToken("=", self.line, self.line_current)
    end

    if char == "!" then
        if self:match_next"=" then
            return NotEqualToken("!=", self.line, self.line_current)
        end
    end

    if char == "-" then
        if self:match_next">" then
            return ArrowToken("->", self.line, self.line_current)
        end
    end

    if char == "," then
        return CommaToken(",", self.line, self.line_current)
    end

    if char == "\"" then
        local a = self:read_string()
        return StringToken(a, self.line, self.line_current)
    end

    if tonumber(char) then
        return NumberToken(self:read_number(), self.line, self.line_current)
    end

    if not string.find(char, "%A") then
        local identifier = self:read_identifier()

        if identifier == "true" then
            return BooleanToken("true", self.line, self.line_current)
        end
        
        if identifier == "false" then
            return BooleanToken("false", self.line, self.line_current)
        end

        if identifier == "nil" then
            return NilToken("nil", self.line, self.line_current)
        end

        if identifier == "var" then
            return VarToken("var", self.line, self.line_current)
        end

        if identifier == "if" then
            return IfToken("if", self.line, self.line_current)
        end

        if identifier == "else" then
            return ElseToken("else", self.line, self.line_current)
        end

        if identifier == "while" then
            return WhileToken("while", self.line, self.line_current)
        end

        if identifier == "for" then
            return ForToken("for", self.line, self.line_current)
        end

        if identifier == "return" then
            return ReturnToken("return", self.line, self.line_current)
        end

        if identifier == "function" then
            return FunctionToken("function", self.line, self.line_current)
        end

        if identifier == "class" then
            return ClassToken("class", self.line, self.line_current)
        end

        if identifier == "and" then
            return AndToken("and", self.line, self.line_current)
        end

        if identifier == "or" then
            return OrToken("or", self.line, self.line_current)
        end

        if identifier == "not" then
            return NotToken("not", self.line, self.line_current)
        end

        if identifier == "extends" then
            return ExtendsToken("extends", self.line, self.line_current)
        end

        if identifier == "type" then
            return TypeToken("type", self.line, self.line_current)
        end

        if identifier == "pub" then
            return PubToken("pub", self.line, self.line_current)
        end

        if identifier == "" then
            return self.custom_error:push {
                line = self.line,
                cureent = self.current,
                error_type = LexicalError,
                error_message = `Invalid character '{self:peek()}' in identifier`,
            }
        end

        return IdentifierToken(identifier, self.line, self.line_current)
    end

    return self.custom_error:push {
        line = self.line,
        cureent = self.line_current,
        error_type = LexicalError,
        error_message = `Unexpected character '{char}'`,
    }
end

return lexer