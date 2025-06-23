export type Operator = 
    | "Add"
    | "Sub"
    | "Mul"
    | "Div"
    | "GreaterEqual"
    | "LessEqual"
    | "Greater"
    | "Less"
    | "EqualTwo"
    | "NotEqual"
    | "And"
    | "Or"

export type DataTypeTokens = 
    | "String"
    | "Number"
    | "Boolean"
    | "Nil"

export type Token<T> = { lexeme: string, line: number, type: T }

export type IdentifierLexerToken = Token<"Identifier">
export type NumberLexerToken = Token<"Number">
export type StringLexerToken = Token<"String">
export type FunctionLexerToken = Token<"Function">
export type BooleanLexerToken = Token<"Boolean">
export type NilLexerToken = Token<"Nil">
export type ArrayLexerToken = Token<"Array">
export type ClassLexerToken = Token<"Class">
export type VarLexerToken = Token<"Var">
export type IfLexerToken = Token<"If">
export type ElseLexerToken = Token<"Else">
export type WhileLexerToken = Token<"While">
export type ForLexerToken = Token<"For">
export type ReturnLexerToken = Token<"Return">
export type AddLexerToken = Token<"Add">
export type SubLexerToken = Token<"Sub">
export type MulLexerToken = Token<"Mul">
export type DivLexerToken = Token<"Div">
export type AndLexerToken = Token<"And">
export type OrLexerToken = Token<"Or">
export type NotLexerToken = Token<"Not">
export type DotLexerToken = Token<"Dot">
export type DotTwoLexerToken = Token<"DotTwo">
export type DotThreeLexerToken = Token<"DotThree">
export type CommaLexerToken = Token<"Comma">
export type SemiColonLexerToken = Token<"SemiColon">
export type ColonLexerToken = Token<"Colon">
export type EqualLexerToken = Token<"Equal">
export type EqualTwoLexerToken = Token<"EqualTwo">
export type NotEqualLexerToken = Token<"NotEqual">
export type LessLexerToken = Token<"Less">
export type LessEqualLexerToken = Token<"LessEqual">
export type GreaterLexerToken = Token<"Greater">
export type GreaterEqualLexerToken = Token<"GreaterEqual">
export type EqualAddLexerToken = Token<"EqualAdd">
export type EqualSubLexerToken = Token<"EqualSub">
export type EqualMulLexerToken = Token<"EqualMul">
export type EqualDivLexerToken = Token<"EqualDiv">
export type LeftParenLexerToken = Token<"LeftParen">
export type RightParenLexerToken = Token<"RightParen">
export type LeftBraceLexerToken = Token<"LeftBrace">
export type RightBraceLexerToken = Token<"RightBrace">
export type LeftBrackLexerToken = Token<"LeftBrack">
export type RightBrackLexerToken = Token<"RightBrack">
export type ArrowLexerToken = Token<"Arrow">
export type ExtendsLexerToken = Token<"Extends">
export type TypeLexerToken = Token<"Type">
export type PubLexerToken = Token<"Pub">
export type EofLexerToken = Token<"Eof">

export type LexerToken =
    | IdentifierLexerToken
    | NumberLexerToken
    | StringLexerToken
    | FunctionLexerToken
    | BooleanLexerToken
    | NilLexerToken
    | ArrayLexerToken
    | ClassLexerToken
    | VarLexerToken
    | IfLexerToken
    | ElseLexerToken
    | WhileLexerToken
    | ForLexerToken
    | ReturnLexerToken
    | AddLexerToken
    | SubLexerToken
    | MulLexerToken
    | DivLexerToken
    | AndLexerToken
    | OrLexerToken
    | NotLexerToken
    | DotLexerToken
    | DotTwoLexerToken
    | DotThreeLexerToken
    | CommaLexerToken
    | SemiColonLexerToken
    | ColonLexerToken
    | EqualLexerToken
    | EqualTwoLexerToken
    | NotEqualLexerToken
    | LessLexerToken
    | LessEqualLexerToken
    | GreaterLexerToken
    | GreaterEqualLexerToken
    | EqualAddLexerToken
    | EqualSubLexerToken
    | EqualMulLexerToken
    | EqualDivLexerToken
    | LeftParenLexerToken
    | RightParenLexerToken
    | LeftBraceLexerToken
    | RightBraceLexerToken
    | LeftBrackLexerToken
    | RightBrackLexerToken
    | ArrowLexerToken
    | ExtendsLexerToken
    | TypeLexerToken
    | PubLexerToken
    | EofLexerToken

export type DataTypeLexerToken = 
    | StringLexerToken
    | NumberLexerToken
    | BooleanLexerToken
    | NilLexerToken

export type OperatorLexerToken = 
    | AddLexerToken
    | SubLexerToken
    | MulLexerToken
    | DivLexerToken
    | GreaterEqualLexerToken
    | LessEqualLexerToken
    | GreaterLexerToken
    | LessLexerToken
    | EqualTwoLexerToken
    | NotEqualLexerToken
    | AndLexerToken
    | OrLexerToken

return {}