export type TokenType = "IdentifierLexerToken"
    | "NumberLexerToken"
    | "StringLexerToken"
    | "FunctionLexerToken"
    | "BooleanLexerToken"
    | "NilLexerToken"
    | "ClassLexerToken"
    | "VarLexerToken"
    | "IfLexerToken"
    | "ElseLexerToken"
    | "WhileLexerToken"
    | "ForLexerToken"
    | "ReturnLexerToken"
    | "AddLexerToken"
    | "SubLexerToken"
    | "MulLexerToken"
    | "DivLexerToken"
    | "RemainderLexerToken"
    | "AndLexerToken"
    | "OrLexerToken"
    | "NotLexerToken"
    | "DotLexerToken"
    | "DotTwoLexerToken"
    | "CommaLexerToken"
    | "SemiColonLexerToken"
    | "ColonLexerToken"
    | "ColonTwoLexerToken"
    | "EqualLexerToken"
    | "EqualTwoLexerToken"
    | "NotEqualLexerToken"
    | "LessLexerToken"
    | "LessEqualLexerToken"
    | "GreaterLexerToken"
    | "GreaterEqualLexerToken"
    | "EqualAddLexerToken"
    | "EqualSubLexerToken"
    | "EqualMulLexerToken"
    | "EqualDivLexerToken"
    | "LeftParenLexerToken"
    | "RightParenLexerToken"
    | "LeftBraceLexerToken"
    | "RightBraceLexerToken"
    | "LeftBrackLexerToken"
    | "RightBrackLexerToken"
    | "ArrowLexerToken"
    | "ExtendsLexerToken"
    | "TypeLexerToken"
    | "PubLexerToken"
    | "EofLexerToken"

export type Token<T> = { lexeme: string, line: number, type: T }

local function createToken(token_type: TokenType): (lexme: string, line: number) -> Token<TokenType>
    return function(lexeme, line) 
        return {
            lexeme = lexeme,
            type = token_type,
            line = line,
        }
    end
end

local IdentifierToken = createToken "IdentifierLexerToken"
local NumberToken = createToken "NumberLexerToken"
local StringToken = createToken "StringLexerToken"
local FunctionToken = createToken "FunctionLexerToken"
local BooleanToken = createToken "BooleanLexerToken"
local NilToken = createToken "NilLexerToken"
local ClassToken = createToken "ClassLexerToken"
local VarToken = createToken "VarLexerToken"
local IfToken = createToken "IfLexerToken"
local ElseToken = createToken "ElseLexerToken"
local WhileToken = createToken "WhileLexerToken"
local ForToken = createToken "ForLexerToken"
local ReturnToken = createToken "ReturnLexerToken"
local AddToken = createToken "AddLexerToken"
local SubToken = createToken "SubLexerToken"
local MulToken = createToken "MulLexerToken"
local DivToken = createToken "DivLexerToken"
local RemainderToken = createToken "RemainderLexerToken"
local AndToken = createToken "AndLexerToken"
local OrToken = createToken "OrLexerToken"
local NotToken = createToken "NotLexerToken"
local DotToken = createToken "DotLexerToken"
local DotTwoToken = createToken "DotTwoLexerToken"
local CommaToken = createToken "CommaLexerToken"
local SemiColonToken = createToken "SemiColonLexerToken"
local ColonToken = createToken "ColonLexerToken"
local ColonTwoToken = createToken "ColonTwoLexerToken"
local EqualToken = createToken "EqualLexerToken"
local EqualTwoToken = createToken "EqualTwoLexerToken"
local NotEqualToken = createToken "NotEqualLexerToken"
local LessToken = createToken "LessLexerToken"
local LessEqualToken = createToken "LessEqualLexerToken"
local GreaterToken = createToken "GreaterLexerToken"
local GreaterEqualToken = createToken "GreaterEqualLexerToken"
local EqualAddToken = createToken "EqualAddLexerToken"
local EqualSubToken = createToken "EqualSubLexerToken"
local EqualMulToken = createToken "EqualMulLexerToken"
local EqualDivToken = createToken "EqualDivLexerToken"
local LeftParenToken = createToken "LeftParenLexerToken"
local RightParenToken = createToken "RightParenLexerToken"
local LeftBraceToken = createToken "LeftBraceLexerToken"
local RightBraceToken = createToken "RightBraceLexerToken"
local LeftBrackToken = createToken "LeftBrackLexerToken"
local RightBrackToken = createToken "RightBrackLexerToken"
local ArrowToken = createToken "ArrowLexerToken"
local ExtendsToken = createToken "ExtendsLexerToken"
local TypeToken = createToken "TypeLexerToken"
local PubToken = createToken "PubLexerToken"
local EofToken = createToken "EofLexerToken"

return {
    IdentifierToken = IdentifierToken,
    NumberToken = NumberToken,
    StringToken = StringToken,
    FunctionToken = FunctionToken,
    BooleanToken = BooleanToken,
    NilToken = NilToken,
    ClassToken = ClassToken,
    VarToken = VarToken,
    IfToken = IfToken,
    ElseToken = ElseToken,
    WhileToken = WhileToken,
    ForToken = ForToken,
    ReturnToken = ReturnToken,
    AddToken = AddToken,
    SubToken = SubToken,
    MulToken = MulToken,
    DivToken = DivToken,
    RemainderToken = RemainderToken,
    AndToken = AndToken,
    OrToken = OrToken,
    NotToken = NotToken,
    DotToken = DotToken,
    DotTwoToken = DotTwoToken,
    CommaToken = CommaToken,
    SemiColonToken = SemiColonToken,
    ColonToken = ColonToken,
    ColonTwoToken = ColonTwoToken,
    EqualToken = EqualToken,
    EqualTwoToken = EqualTwoToken,
    NotEqualToken = NotEqualToken,
    LessToken = LessToken,
    LessEqualToken = LessEqualToken,
    GreaterToken = GreaterToken,
    GreaterEqualToken = GreaterEqualToken,
    EqualAddToken = EqualAddToken,
    EqualSubToken = EqualSubToken,
    EqualMulToken = EqualMulToken,
    EqualDivToken = EqualDivToken,
    LeftParenToken = LeftParenToken,
    RightParenToken = RightParenToken,
    LeftBraceToken = LeftBraceToken,
    RightBraceToken = RightBraceToken,
    LeftBrackToken = LeftBrackToken,
    RightBrackToken = RightBrackToken,
    ArrowToken = ArrowToken,
    ExtendsToken = ExtendsToken,
    TypeToken = TypeToken,
    PubToken = PubToken,
    EofToken = EofToken,
}