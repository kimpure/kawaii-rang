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

export type IdentifierLexerToken = { lexeme: string, line: number, type: "Identifier" }
export type NumberLexerToken = { lexeme: string, line: number, type: "Number" }
export type StringLexerToken = { lexeme: string, line: number, type: "String" }
export type FunctionLexerToken = { lexeme: string, line: number, type: "Function" }
export type BooleanLexerToken = { lexeme: string, line: number, type: "Boolean" }
export type NilLexerToken = { lexeme: string, line: number, type: "Nil" }
export type ArrayLexerToken = { lexeme: string, line: number, type: "Array" }
export type ClassLexerToken = { lexeme: string, line: number, type: "Class" }
export type VarLexerToken = { lexeme: string, line: number, type: "Var" }
export type IfLexerToken = { lexeme: string, line: number, type: "If" }
export type ElseLexerToken = { lexeme: string, line: number, type: "Else" }
export type WhileLexerToken = { lexeme: string, line: number, type: "While" }
export type ForLexerToken = { lexeme: string, line: number, type: "For" }
export type ReturnLexerToken = { lexeme: string, line: number, type: "Return" }
export type AddLexerToken = { lexeme: string, line: number, type: "Add" }
export type SubLexerToken = { lexeme: string, line: number, type: "Sub" }
export type MulLexerToken = { lexeme: string, line: number, type: "Mul" }
export type DivLexerToken = { lexeme: string, line: number, type: "Div" }
export type AndLexerToken = { lexeme: string, line: number, type: "And" }
export type OrLexerToken = { lexeme: string, line: number, type: "Or" }
export type NotLexerToken = { lexeme: string, line: number, type: "Not" }
export type DotLexerToken = { lexeme: string, line: number, type: "Dot" }
export type DotTwoLexerToken = { lexeme: string, line: number, type: "DotTwo" }
export type DotThreeLexerToken = { lexeme: string, line: number, type: "DotThree" }
export type CommaLexerToken = { lexeme: string, line: number, type: "Comma" }
export type SemiColonLexerToken = { lexeme: string, line: number, type: "SemiColon" }
export type ColonLexerToken = { lexeme: string, line: number, type: "Colon" }
export type EqualLexerToken = { lexeme: string, line: number, type: "Equal" }
export type EqualTwoLexerToken = { lexeme: string, line: number, type: "EqualTwo" }
export type NotEqualLexerToken = { lexeme: string, line: number, type: "NotEqual" }
export type LessLexerToken = { lexeme: string, line: number, type: "Less" }
export type LessEqualLexerToken = { lexeme: string, line: number, type: "LessEqual" }
export type GreaterLexerToken = { lexeme: string, line: number, type: "Greater" }
export type GreaterEqualLexerToken = { lexeme: string, line: number, type: "GreaterEqual" }
export type EqualAddLexerToken = { lexeme: string, line: number, type: "EqualAdd" }
export type EqualSubLexerToken = { lexeme: string, line: number, type: "EqualSub" }
export type EqualMulLexerToken = { lexeme: string, line: number, type: "EqualMul" }
export type EqualDivLexerToken = { lexeme: string, line: number, type: "EqualDiv" }
export type LeftParenLexerToken = { lexeme: string, line: number, type: "LeftParen" }
export type RightParenLexerToken = { lexeme: string, line: number, type: "RightParen" }
export type LeftBraceLexerToken = { lexeme: string, line: number, type: "LeftBrace" }
export type RightBraceLexerToken = { lexeme: string, line: number, type: "RightBrace" }
export type LeftBrackLexerToken = { lexeme: string, line: number, type: "LeftBrack" }
export type RightBrackLexerToken = { lexeme: string, line: number, type: "RightBrack" }
export type ArrowLexerToken = { lexeme: string, line: number, type: "Arrow" }
export type ExtendsLexerToken = { lexeme: string, line: number, type: "Extends" }
export type TypeLexerToken = { lexeme: string, line: number, type: "Type" }
export type PubLexerToken = { lexeme: string, line: number, type: "Pub" }
export type EofLexerToken = { lexeme: string, line: number, type: "Eof" }

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
