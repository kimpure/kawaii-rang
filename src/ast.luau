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
    
    | "LogicalAnd"
    | "LogicalOr"

export type DataTypeTokens = {
    line: number,
    lexme: string,
    type: "String"
} | {
    line: number,
    lexme: string,
    type: "Number"
} | {
    line: number,
    lexme: string,
    type: "Boolean"
} | {
    line: number,
    lexme: string,
    type: "Nil"
} 

export type LiteralExpression = DataTypeTokens

export type ParameterNode = {
    name: string,
}

export type FunctionCallExpression = {
    name: Expression,
    args: { ParameterNode },
}

export type VariableExpression = {
    name: string,
}

export type BinaryExpression = {
    left: Expression,
    operator: Operator,
    right: Expression,
}

export type IndexAccessExpression = {
    target: Expression,
    index: Expression
}

export type ArrayExpression = { Expression }

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

return {}