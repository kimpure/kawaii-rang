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
export type FunctionExpression = ast.FunctionExpression

export type AstNode = ast.AstNode
export type ParameterNode = ast.ParameterNode
export type VariableNode = ast.VariableNode
export type FunctionNode = ast.FunctionNode

export type Operator = ast.Operator
export type OperatorTokens = ast.OperatorTokens
export type DataTypeTokens = ast.DataTypeTokens
export type DataTypeLexerTokens = ast.DataTypeLexerTokens

local parser = {}
parser.__index = parser

export type Parser = typeof(setmetatable({}, parser))

function parser.new(tokens: { Token }): Parser
    return setmetatable({
        tokens = tokens,
        
        _index = 1,
    }, parser)
end

function parser.peekable(self: any, ind: number?): Token
    return self.tokens[self._index + (ind or 0)]
end

function parser.next(self: any): Token
    local c = self.tokens[self._index]
    self._index += 1
    return c
end

function parser.unsafe_peekable(self: Parser, ind: number?): any
    return parser.peekable(self, ind)
end

function parser.unsafe_next(self: Parser): any
    return parser.next(self)
end

function parser.is_data_type(self: Parser)
    local data_type = self:peekable().type
    return 
        data_type == 'String' or 
        data_type == 'Number' or 
        data_type == 'Boolean' or 
        data_type == 'Nil'
end

function parser.is_operator_token(self: Parser, token: Token?)
    local operator_type = token and token.type or self:peekable().type
    return operator_type == 'Add' or 
        operator_type == 'Sub' or 
        operator_type == 'Mul' or 
        operator_type == 'Div' or 
        operator_type == 'GreaterEqual' or 
        operator_type == 'LessEqual' or 
        operator_type == 'Greater' or 
        operator_type == 'Less' or 
        operator_type == 'NotEqual' or 
        operator_type == 'EqualTwo' or 
        operator_type == 'And' or 
        operator_type == 'Or' 
end

function parser.is_witch(self: Parser): boolean
    return self:peekable().type == 'SemiColon' 
        or self:peekable().line > self:peekable(-1).line
end

function parser.parse_tuple_expression(self: Parser): { Expression }
    local expressions: { Expression } = {}
    
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
    if self:next().type ~= 'LeftBrack' then
        error('is not index access : ' .. self:peekable().lexeme)
    end
    
    if self:peekable().type == 'RightBrack' then
        error('do close : ' .. self:peekable().lexeme)
    end

    local index_access_expression: IndexAccessExpression = {
        target = target,
        index = self:parse_expression(),
        type = "IndexAccessExpression",
    }

    if self:next().type ~= 'RightBrack' then
        error('not close paren of index access : ' .. index_access_expression.index.type)
    end

    return index_access_expression
end

function parser.parse_expression_binary(self: Parser, left_expression: Expression): BinaryExpression
    if not self:is_operator_token() then
        error('is not operator : ' .. self:peekable().lexeme)
    end

    
    local operator: OperatorTokens = self:unsafe_next()

    local right_expressions = self:parse_expression()
    local binary_expression: BinaryExpression = {
        left = left_expression,
        right = right_expressions,
        operator = operator.type,
        type = "BinaryExpression"
    }

    if left_expression.type == 'BinaryExpression' then
        if ast.operator_token[left_expression.operator] < ast.operator_token[operator.type] then
            binary_expression = {
                left = left_expression.left,
                right = {
                    left = left_expression.right,
                    right = right_expressions,
                    operator = operator.type,
                    type = "BinaryExpression"
                },
                operator = left_expression.operator,
                type = "BinaryExpression",
            }
        end
    end

    return binary_expression
end

function parser.parse_identifier_expression(self: Parser): Expression
    local expression: Expression = {
        expression_name = self:next().lexeme,
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

        break
    end

    return expression
end

function parser.parse_literal_expressions(self: Parser): LiteralExpression
    if self:is_data_type() then
        local data_type: DataTypeLexerTokens = self:unsafe_next()
        return {
            data_type = data_type.type,
            lexeme = data_type.lexeme,
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
        error('is not closed array: ' .. self:peekable().lexeme)
    end

    return array_expression
end

function parser.parse_function_expression(self: Parser): FunctionExpression
    if self:next().type ~= 'Function' then
        error('is not function: ' .. self:peekable().lexeme)
    end
    
    if self:next().type ~= 'LeftParen' then
        error('function not use left paren')
    end
    
    local parameters: { ParameterNode } = {}

    if self:peekable().type ~= 'RightParen' then
        local tuple = self:parse_tuple_expression()
        for i=1, #tuple do
            parameters[i] = {
                expression = tuple[i],
                type = 'ParameterNode',
            }
        end
    end

    if self:peekable() and self:next().type ~= 'RightParen' then
        error('not closed function paren: ' .. self:peekable().lexeme)
    end
    
    if self:peekable() and self:next().type ~= 'LeftBrace' then
        error('not used function brace: ' .. self:peekable().lexeme)
    end

    local ast_nodes = self:parse_ast_node()
    local function_node: FunctionExpression = {
        parameters = parameters,
        body = ast_nodes.body,
        return_expression = ast_nodes.return_expression,
        type = 'FunctionExpression',
    }
    
    if self:peekable() and self:next().type ~= 'RightBrace' then
        error('is not closed function: ' .. self:peekable().lexeme)
    end

    return function_node
end

function parser.parse_expression(self: Parser): Expression
    local token = self:peekable()
    local expression: Expression

    if self:is_data_type() then
        expression = self:parse_literal_expressions()
    elseif token.type == 'LeftParen' then
        expression = self:parse_grouped_expression()
    elseif token.type == 'LeftBrace' then
            expression = self:parse_array_expression()
    elseif token.type == 'Identifier' then
        expression = self:parse_identifier_expression()
    elseif token.type == 'Function' then
        expression = self:parse_function_expression()
    elseif self:is_operator_token() then
        expression = self:parse_expression_binary(expression)
    else
        error('any parser error (parse expression)')
    end
    
    return expression
end

function parser.parse_variable_node(self: Parser): { VariableNode }
    if self:next().type ~= 'Var' then
        error('is not var: ' .. self:peekable().lexeme)
    end

    local identifiers = self:parse_tuple_expression()
    local variable_nodes: { VariableNode } = {}

    for i=1, #identifiers do
        local identifier: Expression = identifiers[i]

        if identifier.type ~= 'VariableExpression' then
            error('parser error: set variable of ' .. identifier.type)
        end

        local variable_node: VariableNode = {
            identifier_expression = identifier,
            initial_value = ast.nil_expression(),
            type = 'VariableNode',
        }

        if self:peekable().type == 'Equal' then
            self:next()
        
            variable_node.initial_value = self:parse_expression()
        end

        variable_nodes[i] = variable_node
    end

    return variable_nodes
end

function parser.parse_const_node(self: Parser): { VariableNode }
    if self:next().type ~= 'Const' then
        error('is not var: ' .. self:peekable().lexeme)
    end

    local identifiers = self:parse_tuple_expression()
    local const_nodes: { VariableNode } = {}

    for i=1, #identifiers do
        local identifier: Expression = identifiers[i]

        if identifier.type ~= 'VariableExpression' then
            error('parser error: set variable of ' .. identifier.type)
        end

        local const_node: VariableNode = {
            identifier_expression = identifier,
            initial_value = ast.nil_expression(),
            type = 'VariableNode',
            is_const = true,
        }

        if self:peekable().type == 'Equal' then
            self:next()
        
            const_node.initial_value = self:parse_expression()
        end

        const_nodes[i] = const_node
    end

    return const_nodes
end

function parser.parse_function_node(self: Parser): FunctionNode
    if self:next().type ~= 'Function' then
        error('is not function: ' .. self:peekable().lexeme)
    end
    
    local identifier_expression = self:parse_expression()

    if identifier_expression.type ~='FunctionCallExpression' then
        error('this not function call expression')
    end

    if self:next().type ~= 'LeftBrace' then
        error('function not use left paren')
    end

    local ast_nodes = self:parse_ast_node()
    local function_node: FunctionNode = {
        identifier_expression = identifier_expression.expression,
        parameters = identifier_expression.args,
        body = ast_nodes.body,
        return_expression = ast_nodes.return_expression,
        type = 'FunctionNode',
    }
    
    if self:next().type ~= 'RightBrace' then
        error('is not closed function: ' .. self:peekable().lexeme)
    end

    return function_node
end

function parser.parse_ast_node(self: Parser): { body: { AstNode }, return_expression: Expression }
    local body: { AstNode } = {}
    local return_expression: Expression

    while true do
        local token = self:peekable()
        
        if not token then
            break
        end

        if token.type == 'Var' then
            local variable_nodes = self:parse_variable_node()
            for i=1, #variable_nodes do
                body[#body + 1] = variable_nodes[i]
            end
            continue
        end
        
        if token.type == 'Const' then
            local const_nodes = self:parse_const_node()
            for i=1, #const_nodes do
                body[#body + 1] = const_nodes[i]
            end
            continue
        end

        if token.type == 'Function' then
            local function_node = self:parse_function_node()
            body[#body + 1] = function_node
            continue
        end

        if token.type == 'Return' then
            self:next()
            return_expression = self:parse_expression()
            break
        end

        if token.type == 'Eof' or token.type == 'RightBrace' then
            break
        end
    end

    return {
        body = body,
        return_expression = return_expression or ast.nil_expression()
    }
end

return parser
