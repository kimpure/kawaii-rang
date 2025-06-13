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

export type DataTypeLexerTokens = {
    type: DataTypeTokens,
    lexeme: string,
    line: number,
}

export type OperatorTokens = {
    type: Operator,
    lexeme: string,
    line: number,
}

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
--// TODO: struct, impl
return ast