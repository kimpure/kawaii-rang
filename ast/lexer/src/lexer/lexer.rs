use crate::lexer::{Token, TokenType};

use std::{iter::Peekable, str::Chars};

pub struct Lexer<'a> {
    chars: Peekable<Chars<'a>>,
    line: usize,
}

impl<'a> Lexer<'a> {
    pub fn new(src: &'a str) -> Self {
        Lexer {
            chars: src.chars().peekable(),
            line: 0,
        }
    }

    fn is_alpha(c: char) -> bool {
        c.is_ascii_alphabetic()
    }

    fn advance(&mut self) -> Option<char> {
        self.chars.next()
    }

    fn peek(&mut self) -> Option<char> {
        self.chars.peek().copied()
    }

    fn match_char(&mut self, expected: char) -> bool {
        if let Some(&c) = self.chars.peek() {
            if c == expected {
                self.chars.next();
                return true;
            }
        }
        false
    }

    fn skip_whitespace(&mut self) {
        while let Some(c) = self.peek() {
            match c {
                ' ' | '\r' | '\t' => {
                    self.advance();
                }
                '\n' => {
                    self.line += 1;
                    self.advance();
                }
                _ => break,
            }
        }
    }

    fn read_string(&mut self) -> String {
        let mut result = String::new();

        while let Some(c) = self.peek() {
            if c == '"' {
                self.advance();
                break;
            }

            result.push(c);
            self.advance();
        }

        result
    }

    fn read_number(&mut self) -> String {
        let mut number = String::new();

        while let Some(c) = self.peek() {
            if c.is_ascii_digit() {
                number.push(c);
                self.advance();
            } else {
                break;
            }
        }

        number
    }

    fn read_identifier(&mut self) -> String {
        let mut id = String::new();

        while let Some(c) = self.peek() {
            if c.is_ascii_alphanumeric() || c == '_' {
                id.push(c);
                self.advance();
            } else {
                break;
            }
        }

        id
    }

    fn keyword_or_identifier(ident: &str) -> TokenType {
        match ident {
            "var" => TokenType::Var,
            "if" => TokenType::If,
            "else" => TokenType::Else,
            "while" => TokenType::While,
            "for" => TokenType::For,
            "return" => TokenType::Return,
            "function" => TokenType::Function,
            "class" => TokenType::Class,
            "and" => TokenType::And,
            "or" => TokenType::Or,
            "not" => TokenType::Not,
            "extends" => TokenType::Extends,
            "type" => TokenType::Type,
            "pub" => TokenType::Pub,
            "true" => TokenType::Boolean,
            "false" => TokenType::Boolean,
            "nil" => TokenType::Nil,
            _ => TokenType::Identifier,
        }
    }

    pub fn next_token(&mut self) -> Token {
        self.skip_whitespace();

        let line = self.line;

        let ch = match self.advance() {
            Some(c) => c,
            None => return Token {
                token_type: TokenType::Eof,
                lexeme: "eof".to_string(),
                line,
            },
        };

        match ch {
            '+' => {
                if self.match_char('=') {
                    Token { token_type: TokenType::EqualAdd, lexeme: "+=".to_string(), line }
                } else {
                    Token { token_type: TokenType::Add, lexeme: "+".to_string(), line }
                }
            }
            '-' => {
                if self.match_char('=') {
                    Token { token_type: TokenType::EqualSub, lexeme: "-=".to_string(), line }
                } else if self.match_char('>') {
                    Token { token_type: TokenType::Arrow, lexeme: "->".to_string(), line }
                } else {
                    Token { token_type: TokenType::Sub, lexeme: "-".to_string(), line }
                }
            }
            '*' => {
                if self.match_char('=') {
                    Token { token_type: TokenType::EqualMul, lexeme: "*=".to_string(), line }
                } else {
                    Token { token_type: TokenType::Mul, lexeme: "*".to_string(), line }
                }
            }
            '/' => {
                if self.match_char('=') {
                    Token { token_type: TokenType::EqualDiv, lexeme: "/=".to_string(), line }
                } else {
                    Token { token_type: TokenType::Div, lexeme: "/".to_string(), line }
                }
            }
            ';' => Token { token_type: TokenType::SemiColon, lexeme: ";".to_string(), line },
            ':' => Token { token_type: TokenType::Colon, lexeme: ":".to_string(), line },
            '.' => {
                if self.match_char('.') {
                    Token { token_type: TokenType::DotTwo, lexeme: "..".to_string(), line }
                } else {
                    Token { token_type: TokenType::Dot, lexeme: ".".to_string(), line }
                }
            }
            ',' => Token { token_type: TokenType::Comma, lexeme: ",".to_string(), line: line },
            '<' => {
                if self.match_char('=') {
                    Token { token_type: TokenType::LessEqual, lexeme: "<=".to_string(), line }
                } else {
                    Token { token_type: TokenType::Less, lexeme: "<".to_string(), line }
                }
            }
            '>' => {
                if self.match_char('=') {
                    Token { token_type: TokenType::GreaterEqual, lexeme: ">=".to_string(), line }
                } else {
                    Token { token_type: TokenType::Greater, lexeme: ">".to_string(), line }
                }
            }
            '(' => Token { token_type: TokenType::LeftParen, lexeme: "(".to_string(), line },
            ')' => Token { token_type: TokenType::RightParen, lexeme: ")".to_string(), line },
            '{' => Token { token_type: TokenType::LeftBrace, lexeme: "{".to_string(), line },
            '}' => Token { token_type: TokenType::RightBrace, lexeme: "}".to_string(), line },
            '[' => Token { token_type: TokenType::LeftBrack, lexeme: "[".to_string(), line },
            ']' => Token { token_type: TokenType::RightBrack, lexeme: "]".to_string(), line },
            '=' => {
                if self.match_char('=') {
                    Token { token_type: TokenType::EqualTwo, lexeme: "==".to_string(), line }
                } else {
                    Token { token_type: TokenType::Equal, lexeme: "=".to_string(), line }
                }
            }
            '!' => {
                if self.match_char('=') {
                    Token { token_type: TokenType::NotEqual, lexeme: "!=".to_string(), line }
                } else {
                    panic!("Unexpected token !");
                }
            }
            '"' => {
                let s = self.read_string();
                Token { token_type: TokenType::String, lexeme: s, line }
            }
            c if c.is_ascii_digit() => {
                let mut number = c.to_string();
                number.push_str(&self.read_number());
                Token { token_type: TokenType::Number, lexeme: number, line }
            }
            c if Self::is_alpha(c) => {
                let mut ident = c.to_string();
                ident.push_str(&self.read_identifier());
                let token_type = Self::keyword_or_identifier(&ident);
                Token { token_type, lexeme: ident, line }
            }
            _ => {
                panic!("Unexpected character: {}", ch);
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use crate::lexer::{Lexer, TokenType};

    fn collect_tokens(mut lex: Lexer) -> Vec<TokenType> {
        let mut tokens = Vec::new();
        loop {
            let token = lex.next_token();
            tokens.push(token.token_type);
            if let TokenType::Eof = token.token_type {
                break;
            }
        }
        tokens
    }

     #[test]
    fn test_all_tokens() {
        let source = r#"
            identifier 123 "string" function true nil class var if else while for return
            + - * / and or not . .. ... , ; : = == != < <= > >= += -= *= /=
            ( ) { } [ ] -> extends type pub
        "#;

        let lex = Lexer::new(source);
        let tokens = collect_tokens(lex);

        let expected_tokens = vec![
            TokenType::Identifier,
            TokenType::Number,
            TokenType::String,
            TokenType::Function,
            TokenType::Boolean,
            TokenType::Nil,
            TokenType::Class,
            TokenType::Var,
            TokenType::If,
            TokenType::Else,
            TokenType::While,
            TokenType::For,
            TokenType::Return,
            TokenType::Add,
            TokenType::Sub,
            TokenType::Mul,
            TokenType::Div,
            TokenType::And,
            TokenType::Or,
            TokenType::Not,
            TokenType::Dot,
            TokenType::DotTwo,
            TokenType::Comma,
            TokenType::SemiColon,
            TokenType::Colon,
            TokenType::Equal,
            TokenType::EqualTwo,
            TokenType::NotEqual,
            TokenType::Less,
            TokenType::LessEqual,
            TokenType::Greater,
            TokenType::GreaterEqual,
            TokenType::EqualAdd,
            TokenType::EqualSub,
            TokenType::EqualMul,
            TokenType::EqualDiv,
            TokenType::LeftParen,
            TokenType::RightParen,
            TokenType::LeftBrace,
            TokenType::RightBrace,
            TokenType::LeftBrack,
            TokenType::RightBrack,
            TokenType::Arrow,
            TokenType::Extends,
            TokenType::Type,
            TokenType::Pub,
            TokenType::Eof,
        ];

        for expected in expected_tokens {
            assert!(tokens.contains(&expected), "Missing token {:?}", expected);
        }
    }

    fn debug_lexer(mut lex: Lexer, token_type: TokenType) {
        let token = lex.next_token();

        if token_type != token.token_type {
            panic!("not match of token: {}", token.lexeme)
        }

        println!("\ntoken type: {:?} | lexeme: {:?}\n", token.token_type, token.lexeme);
    }

    #[test]
    fn number() {
        debug_lexer(Lexer::new("0123456789"), TokenType::Number);
    }

    #[test]
    fn string() {
        debug_lexer(Lexer::new("\"hello world\""), TokenType::String);
    }

    #[test]
    fn identifier() {
        debug_lexer(Lexer::new("variable"), TokenType::Identifier);
    }

    #[test]
    fn function() {
        debug_lexer(Lexer::new("function"), TokenType::Function);
    }

    #[test]
    fn boolean() {
        debug_lexer(Lexer::new("true"), TokenType::Boolean);
    }

    #[test]
    fn nil() {
        debug_lexer(Lexer::new("nil"), TokenType::Nil);
    }

    #[test]
    fn class() {
        debug_lexer(Lexer::new("class"), TokenType::Class);
    }

    #[test]
    fn var() {
        debug_lexer(Lexer::new("var"), TokenType::Var);
    }

    #[test]
    fn if_statement() {
        debug_lexer(Lexer::new("if"), TokenType::If);
    }

    #[test]
    fn else_statement() {
        debug_lexer(Lexer::new("else"), TokenType::Else);
    }

    #[test]
    fn while_loop() {
        debug_lexer(Lexer::new("while"), TokenType::While);
    }

    #[test]
    fn for_loop() {
        debug_lexer(Lexer::new("for"), TokenType::For);
    }

    #[test]
    fn return_statement() {
        debug_lexer(Lexer::new("return"), TokenType::Return);
    }

    #[test]
    fn operators() {
        debug_lexer(Lexer::new("+"), TokenType::Add);
        debug_lexer(Lexer::new("-"), TokenType::Sub);
        debug_lexer(Lexer::new("*"), TokenType::Mul);
        debug_lexer(Lexer::new("/"), TokenType::Div);
    }

    #[test]
    fn logical_operators() {
        debug_lexer(Lexer::new("and"), TokenType::And);
        debug_lexer(Lexer::new("or"), TokenType::Or);
        debug_lexer(Lexer::new("not"), TokenType::Not);
    }

    #[test]
    fn punctuation() {
        debug_lexer(Lexer::new("."), TokenType::Dot);
        debug_lexer(Lexer::new(".."), TokenType::DotTwo);
        debug_lexer(Lexer::new(","), TokenType::Comma);
        debug_lexer(Lexer::new(";"), TokenType::SemiColon);
        debug_lexer(Lexer::new(":"), TokenType::Colon);
    }

    #[test]
    fn comparison_operators() {
        debug_lexer(Lexer::new("="), TokenType::Equal);
        debug_lexer(Lexer::new("=="), TokenType::EqualTwo);
        debug_lexer(Lexer::new("!="), TokenType::NotEqual);
        debug_lexer(Lexer::new("<"), TokenType::Less);
        debug_lexer(Lexer::new("<="), TokenType::LessEqual);
        debug_lexer(Lexer::new(">"), TokenType::Greater);
        debug_lexer(Lexer::new(">="), TokenType::GreaterEqual);
    }

    #[test]
    fn assignment_operators() {
        debug_lexer(Lexer::new("+="), TokenType::EqualAdd);
        debug_lexer(Lexer::new("-="), TokenType::EqualSub);
        debug_lexer(Lexer::new("*="), TokenType::EqualMul);
        debug_lexer(Lexer::new("/="), TokenType::EqualDiv);
    }

    #[test]
    fn brackets() {
        debug_lexer(Lexer::new("("), TokenType::LeftParen);
        debug_lexer(Lexer::new(")"), TokenType::RightParen);
        debug_lexer(Lexer::new("{"), TokenType::LeftBrace);
        debug_lexer(Lexer::new("}"), TokenType::RightBrace);
        debug_lexer(Lexer::new("["), TokenType::LeftBrack);
        debug_lexer(Lexer::new("]"), TokenType::RightBrack);
    }

    #[test]
    fn arrow() {
        debug_lexer(Lexer::new("->"), TokenType::Arrow);
    }

    #[test]
    fn extends() {
        debug_lexer(Lexer::new("extends"), TokenType::Extends);
    }

    #[test]
    fn type_keyword() {
        debug_lexer(Lexer::new("type"), TokenType::Type);
    }

    #[test]
    fn pub_keyword() {
        debug_lexer(Lexer::new("pub"), TokenType::Pub);
    }

    #[test]
    fn eof() {
        debug_lexer(Lexer::new(""), TokenType::Eof);
    }
}
