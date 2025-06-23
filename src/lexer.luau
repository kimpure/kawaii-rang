local ast = require('./ast')

type LexerToken = ast.LexerToken

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
    local len = #self.source
    return self.current >= len
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
        elseif char == '\n' then
            self.line += 1
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

function lexer.next_token(self: Lexer): LexerToken
    self:skip_space()

    if self:is_end() then
        return {
            type = "Eof",
            lexeme = 'eof',
            line = self.line,
        }
    end

    local char = self:advance()

    if char == '+' then
        if self:match_next"=" then
            return {
                type = "EqualAdd",
                lexeme = "+=",
                line = self.line,
            }
        end

        return {
            type = "Add",
            lexeme = "+",
            line = self.line,
        }
    end

    if char == '-' then
        if self:match_next"=" then
            return {
                type = "EqualSub",
                lexeme = "-=",
                line = self.line,
            }
        end

        return {
            type = "Sub",
            lexeme = "-",
            line = self.line,
        }
    end

    if char == '*' then
        if self:match_next"=" then
            return {
                type = "EqualMul",
                lexeme = "*=",
                line = self.line,
            }
        end

        return {
            type = "Mul",
            lexeme = "*",
            line = self.line,
        }
    end

    if char == '/' then
        if self:match_next"=" then
            return {
                type = "EqualDiv",
                lexeme = "/=",
                line = self.line,
            }
        end

        return {
            type = "Div",
            lexeme = "/",
            line = self.line,
        }
    end

    if char == ';' then
        return {
            type = "SemiColon",
            lexeme = ";",
            line = self.line,
        }
    end

    if char == ':' then
        return {
            type = "Colon",
            lexeme = ":",
            line = self.line,
        }
    end

    if char == '.' then
        if self:match_next '.' then
            if self:match_next '.' then        
                return {
                    type = "DotThree",
                    lexeme = ".",
                    line = self.line,
                }
            end

            return {
                type = "DotTwo",
                lexeme = ".",
                line = self.line,
            }
        end

        return {
            type = "Dot",
            lexeme = ".",
            line = self.line,
        }
    end

    if char == '<' then
        if self:match_next"=" then
            return {
                type = "LessEqual",
                lexeme = "<=",
                line = self.line,
            }
        end

        return {
            type = "Less",
            lexeme = "<",
            line = self.line,
        }
    end

    if char == '>' then
        if self:match_next"=" then
            return {
                type = "GreaterEqual",
                lexeme = ">=",
                line = self.line,
            }
        end

        return {
            type = "Greater",
            lexeme = ">",
            line = self.line,
        }
    end

    if char == '(' then
        return {
            type = "LeftParen",
            lexeme = "(",
            line = self.line,
        }
    end
    
    if char == ')' then
        return {
            type = "RightParen",
            lexeme = ")",
            line = self.line,
        }
    end

    if char == '{' then
        return {
            type = "LeftBrace",
            lexeme = "{",
            line = self.line,
        }
    end
    
    if char == '}' then
        return {
            type = "RightBrace",
            lexeme = "}",
            line = self.line,
        }
    end

    if char == '[' then
        return {
            type = "LeftBrack",
            lexeme = "[",
            line = self.line,
        }
    end
    
    if char == ']' then
        return {
            type = "RightBrack",
            lexeme = "]",
            line = self.line,
        }
    end

    if char == '=' then
        if self:match_next"=" then
            return {
                type = "EqualTwo",
                lexeme = "==",
                line = self.line,
            }
        end

        return {
            type = "Equal",
            lexeme = "=",
            line = self.line,
        }
    end

    if char == '!' then
        if self:match_next"=" then
            return {
                type = "NotEqual",
                lexeme = "!=",
                line = self.line,
            }
        end
    end

    if char == '-' then
        if self:match_next">" then
            return {
                type = "Arrow",
                lexeme = "->",
                line = self.line,
            }
        end
    end

    if char == ',' then
        return {
            type = "Comma",
            lexeme = ",",
            line = self.line,
        }
    end

    if char == '"' then
        return {
            type = "String",
            lexeme = self:read_string(),
            line = self.line,
        }
    end

    if is_alphabetic(char) then
        local identifier = self:read_identifier()

        if identifier == "var" then
            return {
                type = "Var",
                lexeme = 'var',
                line = self.line,
            }
        end

        if identifier == "if" then
            return {
                type = "If",
                lexeme = 'if',
                line = self.line,
            }
        end

        if identifier == "else" then
            return {
                type = "Else",
                lexeme = 'else',
                line = self.line,
            }
        end

        if identifier == "while" then
            return {
                type = "While",
                lexeme = 'while',
                line = self.line,
            }
        end

        if identifier == "for" then
            return {
                type = "For",
                lexeme = 'for',
                line = self.line,
            }
        end

        if identifier == "return" then
            return {
                type = "Return",
                lexeme = 'return',
                line = self.line,
            }
        end

        if identifier == "function" then
            return {
                type = "Function",
                lexeme = 'function',
                line = self.line,
            }
        end

        if identifier == "class" then
            return {
                type = "Class",
                lexeme = 'class',
                line = self.line,
            }
        end

        if identifier == "and" then
            return {
                type = "And",
                lexeme = 'and',
                line = self.line,
            }
        end

        if identifier == "or" then
            return {
                type = "Or",
                lexeme = 'or',
                line = self.line,
            }
        end

        if identifier == "not" then
            return {
                type = "Not",
                lexeme = 'not',
                line = self.line,
            }
        end

        if identifier == "extends" then
            return {
                type = "Extends",
                lexeme = 'extends',
                line = self.line,
            }
        end

        if identifier == "type" then
            return {
                type = "Type",
                lexeme = 'type',
                line = self.line,
            }
        end

        if identifier == "pub" then
            return {
                type = "Pub",
                lexeme = 'pub',
                line = self.line,
            }
        end

        return {
            type = "Identifier",
            lexeme = identifier,
            line = self.line,
        }
    end

    if tonumber(char) then
        return {
            type = "Number",
            lexeme = self:read_number(),
            line = self.line,
        }
    end

    error('lexer error : not ast for keyword')
end

return lexer