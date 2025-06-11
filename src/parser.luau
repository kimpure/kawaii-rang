local ast = require('./ast')
local lexer = require('./lexer')

export type Token = lexer.Token
export type TokenType = lexer.TokenType

export type Expression = ast.Expression
export type LiteralExpression = ast.LiteralExpression
export type FunctionCallExpression = ast.FunctionCallExpression
export type IndexAccessExpression = ast.IndexAccessExpression
export type BinaryExpression = ast.BinaryExpression
export type GroupedExpression = ast.GroupedExpression
export type VariableExpression = ast.VariableExpression
export type ArrayExpression = ast.ArrayExpression

export type AstNode = ast.AstNode
export type ParameterNode = ast.ParameterNode

export type Operator = ast.Operator
export type DataTypeTokens = ast.DataTypeTokens

local parser = {}
parser.__index = parser

export type Parser = typeof(setmetatable({} :: {
    tokens: { Token },
}, parser))

function parser.new(tokens: { Token }): Parser
    return setmetatable({
        tokens = tokens,
        
        _index = 1,
    }, parser)
end

function parser.peekable(self: Parser)
    return self.tokens[(self::any)._index]
end

function parser.next(self: Parser)
    local c = self.tokens[(self::any)._index]
    ;(self::any)._index += 1
    return c
end

function parser.is_data_type(self: Parser)
    local data_type = self:peekable().type
    return 
        data_type == 'String' or 
        data_type == 'Number' or 
        data_type == 'Boolean' or 
        data_type == 'Nil'
end

function parser.is_operator_token(self: Parser)
    local operator_type = self:peekable().type
    return operator_type == 'Add' or 
        operator_type == 'Sub' or 
        operator_type == 'Mul' or 
        operator_type == 'Div' or 
        operator_type == 'GreaterEqual' or 
        operator_type == 'LessEqual' or 
        operator_type == 'Greater' or 
        operator_type == 'Less' or 
        operator_type == 'Equal' or 
        operator_type == 'NotEqual' or 
        operator_type == 'And' or 
        operator_type == 'Or' 
end

function parser.parse_tuple_expression(self: Parser): { Expression }
    local expressions = {}
    
    while true do
        expressions[#expressions + 1] = self:parse_expression()

        if self:peekable() and self:peekable().type ~= 'Comma' then
            break
        end

        self:next()
    end
    
    return expressions
end

function parser.parse_expression_function_call(self: Parser, target_expression: Expression): FunctionCallExpression
    local function_expression: FunctionCallExpression = {
        expression = target_expression,
        args = {},
        type = "FunctionCallExpression",
    }

    if self:next().type ~= 'LeftParen' then
        error('is not function : ' .. self:peekable().lexeme)
    end
    
    if self:peekable().type ~= 'RightParen' then
        local tuple_expressions = self:parse_tuple_expression()
        local parameters: { ParameterNode } = {}
        
        for i=1, #tuple_expressions do
            parameters[i] = {
                expression = tuple_expressions[i],
                type = "ParameterNode"
            }
        end
    
        function_expression.args = parameters
    
        if self:peekable().type ~= 'RightParen' then
            error('not close paren of function : ' .. self:peekable().lexeme)
        end
    end

    self:next()

    return function_expression
end

function parser.parse_expression_index_access(self: Parser, target: Expression): IndexAccessExpression
    local index_access_expression = {
        target = target,
        type = "IndexAccessExpression",
    } :: IndexAccessExpression

    if self:next().type ~= 'LeftBrack' then
        error('is not function : ' .. self:peekable().lexeme)
    end
    
    if self:peekable().type == 'RightBrack' then
        error('is not index : ' .. self:peekable().lexeme)
    end

    index_access_expression.index = self:parse_expression()

    if self:next().type ~= 'RightBrack' then
        error('not close paren of index access : ' .. (index_access_expression.index::any).lexeme)
    end

    return index_access_expression
end

function parser.parse_expression_binary(self: Parser, left_expression: Expression): BinaryExpression
    if not self:is_operator_token() then
        error('is not operator : ' .. self:peekable().lexeme)
    end

    local operator = self:next()

    return {
        left = left_expression,
        right = self:parse_expression(),
        operator = operator.type :: Operator,
        type = "BinaryExpression"
    }
end

function parser.parse_identifier_expression(self: Parser): Expression
    local expression: Expression = {
        name = self:next().lexeme,
        type = "VariableExpression",
    }

    while true do
        if self:peekable().type == 'LeftBrack' then
            expression = self:parse_expression_index_access(expression)
            continue
        end

        if self:peekable().type == 'LeftParen' then
            expression = self:parse_expression_function_call(expression)
            continue
        end

        if self:is_operator_token() then
            expression = self:parse_expression_binary(expression)
            continue
        end

        break
    end

    return expression
end

function parser.parse_literal_expressions(self: Parser): LiteralExpression
    if self:is_data_type() then
        local data_type = self:next()
        return {
            data_type = data_type.type :: DataTypeTokens,
            lexeme = data_type.lexeme,
            line = data_type.line,
            type = 'LiteralExpression',
        }
    end

    error('is not data type: ' .. self:peekable().lexeme)
end

function parser.parse_grouped_expression(self: Parser): GroupedExpression
    if self:next().type ~= 'LeftParen' then
        error('is not grouped: ' .. self:peekable().lexeme)
    end

    local expression = self:parse_expression()

    local grouped_expression: GroupedExpression = {
        expression = expression,
        type = "GroupedExpression",
    }

    if self:next().type ~= 'RightParen' then
        error('is not closed grouped: ' .. self:peekable().lexeme)
    end

    return grouped_expression
end

function parser.parse_array_expression(self: Parser): ArrayExpression
    if self:next().type ~= 'LeftBrace' then
        error('is not array: ' .. self:peekable().lexeme)
    end
    
    local expressions = self:parse_tuple_expression()

    local array_expression: ArrayExpression = {
        args = expressions,
        type = "ArrayExpression",
    }
    
    if self:next().type ~= 'RightBrace' then
        error('is not closed grouped: ' .. self:peekable().lexeme)
    end


    return array_expression
end

function parser.parse_expression(self: Parser): Expression
    local token = self:peekable()
    local expression: Expression

    if self:is_data_type() then
        expression = self:parse_literal_expressions()
    end

    if token.type == 'LeftParen' then
        expression = self:parse_grouped_expression()
    end

    if token.type == 'LeftBrace' then
        expression = self:parse_array_expression()
    end

    if token.type == 'Identifier' then
        expression = self:parse_identifier_expression()
    end

    return expression
end

return parser
