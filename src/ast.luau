export type DataType = 
    | "Number"
    | "String"
    | "Function"
    | "Boolean"
    | "Nil"

    | "Array"
    | "Object"

export type FunctionNode = {
    name: string,
    parameters: { ParameterNode },
    return_type: DataType,
    body: { AstNode },
}

export type ParameterNode = {
    name: string,
    type: DataType,
    initial_value: string,
}

export type Expression = 
    | FunctionCall
    | Literal
    | Variable
    | BinaryExpression
    | IndexAccess
    | Grouped

export type Grouped = {
    type: "Grouped",
    expression: Expression,
}

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

export type Variable = {
    name: string,
    value: DataType,
}

export type FunctionCall = {
    name: string,
    args: { Expression }
}

export type Literal = 
    | "String"
    | "Number"
    | "Boolean"
    | "Nil"

export type BinaryExpression = {
    left: Expression,
    operator: Operator,
    right: Expression,
}

export type IndexAccess = {
    target: Expression,
    index: Expression
}

export type ArrayLiteral = { Expression }

export type VariableNode = {
    name: string,
    type: DataType,
    initial_value: Expression?,
}

export type Statement = {
    Print: string,
    Variable: string,
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
    Expression: Expression,
}

export type AstNode = 
    | FunctionNode
    | VariableNode
    | Expression
    | Statement

return {}
