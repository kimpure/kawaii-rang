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
export type StructLexerToken = { lexeme: string, line: number, type: "Struct" }
export type VarLexerToken = { lexeme: string, line: number, type: "Var" }
export type ConstLexerToken = { lexeme: string, line: number, type: "Const" }
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
export type EofLexerToken = { lexeme: string, line: number, type: "Eof" }

export type LexerToken =
    | IdentifierLexerToken
    | NumberLexerToken
    | StringLexerToken
    | FunctionLexerToken
    | BooleanLexerToken
    | NilLexerToken
    | ArrayLexerToken
    | StructLexerToken
    | VarLexerToken
    | ConstLexerToken
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

export type LiteralExpression = {
    data_type: DataTypeTokens,
    lexeme: string,
    type: "LiteralExpression",
}

export type ParameterNode = {
    expression: Expression,
    type: "ParameterNode",
}

export type GroupedExpression = {
    expression: Expression,
    type: "GroupedExpression",
}

export type FunctionCallExpression = {
    expression: Expression,
    args: { ParameterNode },
    type: "FunctionCallExpression",
}

export type VariableExpression = {
    expression_name: string,
    type: "VariableExpression",
}

export type BinaryExpression = {
    left: Expression,
    operator: Operator,
    right: Expression,
    type: "BinaryExpression"
}

export type IndexAccessExpression = {
    target: Expression,
    index: Expression,
    type: "IndexAccessExpression",
}

export type ArrayExpression = { 
    args: { Expression },
    type: "ArrayExpression", 
}

export type FunctionExpression = {
    parameters: { ParameterNode },
    return_expression: { Expression },
    body: { AstNode },
    type: "FunctionExpression",
}

export type Expression = 
    | LiteralExpression
    | ArrayExpression
    | FunctionCallExpression
    | VariableExpression
    | BinaryExpression
    | IndexAccessExpression
    | GroupedExpression
    | FunctionExpression

export type Statement = {
    Print: {
        name: "print",
        args: { Expression },
    },
    If: {
        condition: Expression,
        body: { AstNode },
        else_if_blocks: { AstNode },
        else_block: { AstNode },
    },
    For: {
        initialization: Expression,
        condition: Expression,
        increment: Expression,
        body: { AstNode },
    },
    While: {
        condition: Expression,
        body: { AstNode },
    },

    Break: string,
    Continue: string,
    Return: Expression,
    
    Variable: VariableNode,
    Expression: Expression,
}

export type VariableNode = {
    identifier_expression: VariableExpression,
    initial_value: Expression,
    is_const: boolean?,
    type: "VariableNode",
}

export type FunctionNode = {
    identifier_expression: Expression,
    parameters: { ParameterNode },
    return_expression: { Expression },
    body: { AstNode },
    type: "FunctionNode",
}

export type AstNode = 
    | Statement
    | Expression
    | FunctionNode
    | VariableNode

local ast = {}

local operator_token: { [Operator]: number } = {
    Add = 1,
    Sub = 1,
    
    Mul = 2,
    Div = 2,

    GreaterEqual = 3,
    LessEqual = 3,
    Greater = 3,
    Less = 3,
    EqualTwo = 3,
    NotEqual = 3,

    And = 4,
    Or = 4,
}

ast.operator_token = operator_token

function ast.nil_expression(): LiteralExpression
    return {
        data_type = 'Nil',
        lexeme = "nil",
        type = "LiteralExpression",
    }
end

return ast
