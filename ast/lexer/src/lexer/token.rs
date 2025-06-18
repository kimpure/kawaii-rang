#[derive(Debug, Clone, Copy, PartialEq)]
pub enum TokenType {
    Identifier,
    Number,
    String,
    Function,
    Boolean,
    Nil,
    Class,
    Var,
    If,
    Else,
    While,
    For,
    Return,
    Add,
    Sub,
    Mul,
    Div,
    And,
    Or,
    Not,
    Dot,
    DotTwo,
    DotThree,
    Comma,
    SemiColon,
    Colon,
    Equal,
    EqualTwo,
    NotEqual,
    Less,
    LessEqual,
    Greater,
    GreaterEqual,
    EqualAdd,
    EqualSub,
    EqualMul,
    EqualDiv,
    LeftParen,
    RightParen,
    LeftBrace,
    RightBrace,
    LeftBrack,
    RightBrack,
    Arrow,
    Extends,
    Type,
    Pub,
    Eof,
}

pub struct Token {
    pub token_type: TokenType,
    pub lexeme: String,
    pub line: usize
}

impl Token {
    pub fn new(token_type: TokenType, lexeme: String, line: usize) -> Self {
        Token {
            token_type,
            lexeme,
            line,
        }
    }
}

impl Default for Token {
     fn default() -> Self {
        Token {
            token_type: TokenType::Eof,
            lexeme: String::new(),
            line: 0,
        }
    }
}
