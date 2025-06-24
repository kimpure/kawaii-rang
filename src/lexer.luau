local ast = require("./ast")

type TokenType = ast.TokenType
type Token = ast.Token<TokenType>

local lexer = {}
lexer.__index = lexer

export type Lexer = typeof(setmetatable({} :: {
    source: string,
    current: number,
    line: number,
}, lexer))

function lexer.new(source: string)
    return setmetatable({
        source = source,
        current = 0,
        line = 1,
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
            self:advance()
        else
            break
        end
    end
end

function lexer.read_string(self: Lexer)
    if self:peek() == "\"" then
        self:advance()
    end

    local str = ""

    while not self:is_end() and self:peek() ~= "\"" do
        str ..= self:advance()
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

function lexer.read_identifier(self: Lexer)
    local start = self.current

    while not self:is_end() do
        local char = self:peek()

        if tonumber(char) or char == "_" or string.find(char, "%A") then
            self:advance()
        else
            break
        end
    end

    return self.source:sub(start, self.current)
end

function lexer.next_token(self: Lexer): Token
    self:skip_space()

    if self:is_end() then
        return ast.EofToken("Eof", self.line)
    end

    local char = self:advance()

    if char == "+" then
        if self:match_next"=" then
            return ast.EqualAddToken("+=", self.line)
        end

        return ast.AddToken("+", self.line)
    end

    if char == "-" then
        if self:match_next"=" then
            return ast.EqualSubToken("-=", self.line)
        end

        return ast.SubToken("-", self.line)
    end

    if char == "*" then
        if self:match_next"=" then
            return ast.EqualMulToken("*=", self.line)
        end

        return ast.MulToken("*", self.line)
    end

    if char == "/" then
        if self:match_next"=" then
            return ast.EqualDivToken("/=", self.line)
        end

        return ast.DivToken("/", self.line)
    end

    if char == "%" then
        return ast.RemainderToken("%", self.line)
    end

    if char == ";" then
        return ast.SemiColonToken(";", self.line)
    end

    if char == ":" then
        if self:match_next":" then
            ast.ColonTwoToken("::", self.line)
        end

        return ast.ColonToken(":", self.line)
    end

    if char == "." then
        if self:match_next "." then
            return ast.DotTwoToken("..", self.line)
        end

        return ast.DotToken(".", self.line)
    end

    if char == "<" then
        if self:match_next"=" then
            return ast.LessEqualToken("<=", self.line)
        end

        return ast.LessToken("<", self.line)
    end

    if char == ">" then
        if self:match_next"=" then
            return ast.GreaterEqualToken(">=", self.line)
        end

        return ast.GreaterToken(">", self.line)
    end

    if char == "(" then
        return ast.LeftParenToken("(", self.line)
    end
    
    if char == ")" then
        return ast.RightParenToken(")", self.line)
    end

    if char == "{" then
        return ast.LeftBraceToken("{", self.line)
    end
    
    if char == "}" then
        return ast.RightBraceToken("}", self.line)
    end

    if char == "[" then
        return ast.LeftBrackToken("[", self.line)
    end
    
    if char == "]" then
        return ast.RightBrackToken("]", self.line)
    end

    if char == "=" then
        if self:match_next"=" then
            return ast.EqualTwoToken("==", self.line)
        end

        return ast.EqualToken("=", self.line)
    end

    if char == "!" then
        if self:match_next"=" then
            return ast.NotEqualToken("!=", self.line)
        end
    end

    if char == "-" then
        if self:match_next">" then
            return ast.ArrowToken("->", self.line)
        end
    end

    if char == "," then
        return ast.CommaToken(",", self.line)
    end

    if char == "\"" then
        return ast.StringToken(self:read_string(), self.line)
    end

    if string.find(char, "%A") then
        local identifier = self:read_identifier()

        if identifier == "var" then
            return ast.VarToken("var", self.line)
        end

        if identifier == "if" then
            return ast.IfToken("if", self.line)
        end

        if identifier == "else" then
            return ast.ElseToken("else", self.line)
        end

        if identifier == "while" then
            return ast.WhileToken("while", self.line)
        end

        if identifier == "for" then
            return ast.ForToken("for", self.line)
        end

        if identifier == "return" then
            return ast.ReturnToken("return", self.line)
        end

        if identifier == "function" then
            return ast.FunctionToken("function", self.line)
        end

        if identifier == "class" then
            return ast.ClassToken("class", self.line)
        end

        if identifier == "and" then
            return ast.AndToken("and", self.line)
        end

        if identifier == "or" then
            return ast.OrToken("or", self.line)
        end

        if identifier == "not" then
            return ast.NotToken("not", self.line)
        end

        if identifier == "extends" then
            return ast.ExtendsToken("extends", self.line)
        end

        if identifier == "type" then
            return ast.TypeToken("type", self.line)
        end

        if identifier == "pub" then
            return ast.PubToken("pub", self.line)
        end

        return ast.IdentifierToken(identifier, self.line)
    end

    if tonumber(char) then
        return ast.NumberToken(self:read_number(), self.line)
    end

    error("Unexpected character: " .. char)
end

return lexer