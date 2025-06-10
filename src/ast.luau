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

export type DataType = 
    | "Number"
    | "String"
    | "Boolean"
    | "Nil"

export type LiteralExpression = DataType

export type ArrayLiteralExpression = { LiteralExpression }

export type ParameterNode = {
    name: string,
    initial_value: Expression,
}

export type FunctionCallExpression = {
    name: string,
    args: { ParameterNode },
}

export type VariableExpression = {
    name: string,
    initial_value: Expression,
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

export type Expression = 
    | LiteralExpression
    | ArrayLiteralExpression
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
    
    Variable: VariableExpression,
    Expression: Expression,
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

return {}