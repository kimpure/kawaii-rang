export type TokenType = 
    | "Identifier"

    | "Number"
    | "String"
    | "Function"
    | "Boolean"
    | "Nil"

    | "Array"
    | "Object"

    | "Let"
    | "Const"
    | "If"
    | "Else"
    | "While"
    | "For"
    | "Return"
    
    | "Add"
    | "Sub"
    | "Mul"
    | "Div"

    | "And"
    | "Or"
    | "Not"

    | "Dot"
    | "Comma"
    | "SemiColon"
    | "Colon"
    | "NewLine"

    | "Equal"
    | "EqualTwo"
    | "NotEqual"

    | "EqualAdd"
    | "EqualSub"
    | "EqualMul"
    | "EqualDiv"

    | "LeftChevr"
    | "LeftChevrEqual"
    | "RightChevr"
    | "RightChevrEqual"
    | "LeftParen"
    | "RightParen"
    | "LeftBrace"
    | "RightBrace"
    | "LeftBrack"
    | "RightBrack"
    
    | "Eof"

export type Token = {
    type: TokenType,
    lexeme: string,
}

local lexer = {}
lexer.__index = lexer

export type Lexer = typeof(setmetatable({} :: {
    source: string,
    current: number,
    line: number,
}, lexer))

local function is_alphabetic(str: string)
    local str = string.lower(str)
    return 
        str == 'a' or 
        str == 'b' or 
        str == 'c' or 
        str == 'd' or
        str == 'e' or 
        str == 'f' or 
        str == 'g' or 
        str == 'h' or
        str == 'i' or 
        str == 'j' or 
        str == 'k' or 
        str == 'l' or
        str == 'm' or 
        str == 'n' or 
        str == 'o' or 
        str == 'p' or
        str == 'q' or 
        str == 'r' or 
        str == 's' or 
        str == 't' or
        str == 'u' or 
        str == 'v' or 
        str == 'w' or 
        str == 'x' or
        str == 'y' or 
        str == 'z' 
end

function lexer.new(source: string)
    return setmetatable({
        source = source,
        current = 0,
        line = 1,
    }, lexer)
end

function lexer.is_end(self: Lexer)
    return self.current >= utf8.len(self.source) :: number
end

function lexer.advance(self: Lexer)
    if self:is_end() then
        return ''
    end

    local ch = utf8.char(utf8.codepoint(string.sub(self.source, self.current + 1), 1))
    self.current += #ch
    
    return ch
end

function lexer.peek(self: Lexer)
    if self:is_end() then
        return ''
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

        if char == ' ' or char == '\r' or char == '\t' then
            self:advance()
        else
            break
        end
    end
end

function lexer.read_string(self: Lexer)
    if self:peek() == '"' then
        self:advance()
    end

    local str = ""

    while not self:is_end() and self:peek() ~= '"' do
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

        if tonumber(char) or char == '_' or is_alphabetic(char) then
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
        return {
            type = "Eof",
            lexeme = '',
        }
    end

    local char = self:advance()
    
    if char == '\n' then
        self.line += 1
        return {
            type = "NewLine",
            lexeme = "\n",
        }
    end

    if char == '+' then
        if self:match_next"=" then
            return {
                type = "EqualAdd",
                lexeme = "+=",
            }
        end

        return {
            type = "Add",
            lexeme = "+",
        }
    end

    if char == '-' then
        if self:match_next"=" then
            return {
                type = "EqualSub",
                lexeme = "-=",
            }
        end

        return {
            type = "Sub",
            lexeme = "-",
        }
    end

    if char == '*' then
        if self:match_next"=" then
            return {
                type = "EqualMul",
                lexeme = "*=",
            }
        end

        return {
            type = "Mul",
            lexeme = "*",
        }
    end

    if char == '/' then
        if self:match_next"=" then
            return {
                type = "EqualDiv",
                lexeme = "/=",
            }
        end

        return {
            type = "Div",
            lexeme = "/",
        }
    end

    if char == ';' then
        return {
            type = "SemiColon",
            lexeme = ";",
        }
    end

    if char == ':' then
        return {
            type = "Colon",
            lexeme = ":",
        }
    end

    if char == '<' then
        if self:match_next"=" then
            return {
                type = "LeftChevrEqual",
                lexeme = "<=",
            }
        end

        return {
            type = "LeftChevr",
            lexeme = "<",
        }
    end

    if char == '>' then
        if self:match_next"=" then
            return {
                type = "RightChevrEqual",
                lexeme = ">=",
            }
        end

        return {
            type = "RightChevr",
            lexeme = ">",
        }
    end

    if char == '(' then
        return {
            type = "LeftParen",
            lexeme = "(",
        }
    end
    
    if char == ')' then
        return {
            type = "RightParen",
            lexeme = ")",
        }
    end

    if char == '{' then
        return {
            type = "LeftBrace",
            lexeme = "{",
        }
    end
    
    if char == '}' then
        return {
            type = "RightBrace",
            lexeme = "}",
        }
    end

    if char == '[' then
        return {
            type = "LeftBrack",
            lexeme = "[",
        }
    end
    
    if char == ']' then
        return {
            type = "RightBrack",
            lexeme = "]",
        }
    end

    if char == '=' then
        if self:match_next"=" then
            return {
                type = "EqualTwo",
                lexeme = "=="
            }
        end

        return {
            type = "Equal",
            lexeme = "=",
        }
    end

    if char == '!' then
        if self:match_next"=" then
            return {
                type = "NotEqual",
                lexeme = "!="
            }
        end
    end

    if char == ',' then
        return {
            type = "Comma",
            lexeme = ",",
        }
    end

    if char == '"' then
        return {
            type = "String",
            lexeme = self:read_string(),
        }
    end

    if is_alphabetic(char) then
        local identifier = self:read_identifier()

        if identifier == "let" then
            return {
                type = "Let",
                lexeme = 'let'
            }
        end

        if identifier == "const" then
            return {
                type = "Const",
                lexeme = 'const'
            }
        end

        if identifier == "if" then
            return {
                type = "If",
                lexeme = 'if'
            }
        end

        if identifier == "else" then
            return {
                type = "Else",
                lexeme = 'else'
            }
        end

        if identifier == "while" then
            return {
                type = "While",
                lexeme = 'while'
            }
        end

        if identifier == "for" then
            return {
                type = "For",
                lexeme = 'for'
            }
        end

        if identifier == "return" then
            return {
                type = "Return",
                lexeme = 'return'
            }
        end

        if identifier == "and" then
            return {
                type = "And",
                lexeme = 'and'
            }
        end

        if identifier == "or" then
            return {
                type = "Or",
                lexeme = 'or'
            }
        end

        if identifier == "not" then
            return {
                type = "Not",
                lexeme = 'not'
            }
        end

        return {
            type = "Identifier",
            lexeme = identifier
        }
    end

    if tonumber(char) then
        return {
            type = "Number",
            lexeme = self:read_number(),
        }
    end

    error('lexer error : not ast for keyword')
end

return lexer
