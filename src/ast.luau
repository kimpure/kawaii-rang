local lexer = require('./lexer')

export type LexerToken = lexer.Token

export type Operator = 
    | "Add"
    | "Sub"
    | "Mul"
    | "Div"
    
    | "GreaterEqual"
    | "LessEqual"
    
    | "Greater"
    | "Less"
    
    | "Equal"
    | "NotEqual"
    
    | "And"
    | "Or"

export type DataTypeTokens = 
    | "String"
    | "Number"
    | "Boolean"
    | "Nil"

export type LiteralExpression = {
    data_type: DataTypeTokens,
    lexeme: string,
    line: number,
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
    name: string,
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

export type Expression = 
    | LiteralExpression
    | ArrayExpression
    | FunctionCallExpression
    | VariableExpression
    | BinaryExpression
    | IndexAccessExpression

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
    name: string,
    initial_value: Expression,
}

export type FunctionNode = {
    name: string,
    parameters: { ParameterNode },
    return_expression: Expression,
    body: { AstNode }
}

export type AstNode = 
    | Statement
    | Expression
    | FunctionNode
    | VariableNode

export type ParserIdentifier = {
    identifier: {
        type: string,
        lexeme: string,
        line: number,
    },
    type: ParserIdentifierToken,
}

export type ParserIdentifierToken = 
    | "Function"
    | "IndexAccess"
    | "Variable"

return {}