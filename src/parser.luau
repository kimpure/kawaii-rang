local ast = require('./ast')

export type LexerToken = ast.LexerToken

export type Expression = ast.Expression
export type LiteralExpression = ast.LiteralExpression
export type FunctionCallExpression = ast.FunctionCallExpression
export type IndexAccessExpression = ast.IndexAccessExpression
export type BinaryExpression = ast.BinaryExpression
export type GroupedExpression = ast.GroupedExpression
export type VariableExpression = ast.VariableExpression
export type ArrayExpression = ast.ArrayExpression
export type FunctionExpression = ast.FunctionExpression
export type StructExpression = ast.StructExpression

export type AstNode = ast.AstNode
export type ParameterNode = ast.ParameterNode
export type VariableNode = ast.VariableNode
export type FunctionNode = ast.FunctionNode
export type StructNode = ast.StructNode

export type NativeType = ast.NativeType

local parser = {}
parser.__index = parser

export type Parser = typeof(setmetatable({}, parser))

function parser.new(tokens: { LexerToken }): Parser
    return setmetatable({
        tokens = tokens,
        
        _index = 1,
    }, parser)
end

function parser.peekable(self: any, ind: number?): LexerToken
    return self.tokens[self._index + (ind or 0)]
end

function parser.next(self: any): LexerToken
    local c = self.tokens[self._index]
    self._index += 1
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

function parser.is_operator_token(self: Parser, token: LexerToken?)
    local operator = token and token or self:peekable()
    return operator.type == 'Add' or 
        operator.type == 'Sub' or 
        operator.type == 'Mul' or 
        operator.type == 'Div' or 
        operator.type == 'GreaterEqual' or 
        operator.type == 'LessEqual' or 
        operator.type == 'Greater' or 
        operator.type == 'Less' or 
        operator.type == 'NotEqual' or 
        operator.type == 'EqualTwo' or 
        operator.type == 'And' or 
        operator.type == 'Or' 
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

function parser.parse_parameter_nodes(self: Parser): { ParameterNode }
    local expressions: { ParameterNode } = {}
    
    while true do
        local expression = self:parse_expression()
        local native_expression_type: NativeType

        if expression.type ~= 'VariableExpression' then
            error('parameter node is not variable: ', expression.type)
        end

        if self:peekable() and self:peekable().type == 'Colon' then
            self:next()

            native_expression_type = self:parse_native_expression_type()
        end

        expressions[#expressions + 1] = {
            expression = expression,
            native_expression_type = native_expression_type,
            type = "ParameterNode",
        }
        
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

    local operator = self:next()

    if not (operator.type == 'Add' or operator.type == 'Sub' or operator.type == 'Mul' or operator.type == 'Div' or operator.type == 'GreaterEqual' or operator.type == 'LessEqual' or operator.type == 'Greater' or operator.type == 'Less' or operator.type == 'NotEqual' or operator.type == 'EqualTwo' or operator.type == 'And' or operator.type == 'Or' ) then
        error('do not match operator: ' .. operator.lexeme)
    end

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

function parser.parse_identifier_expression(self: Parser): VariableExpression
    local expression: VariableExpression = {
        expression_name = self:next().lexeme,
        type = "VariableExpression",
    }
    
    return expression
end

function parser.parse_literal_expressions(self: Parser): LiteralExpression
    if self:is_data_type() then
        local lexer_token = self:next()

        if not (lexer_token.type == "String" or lexer_token.type == "Number" or lexer_token.type == "Boolean" or lexer_token.type == "Nil") then
            error('do not match data type: ' .. lexer_token.lexeme)
        end

        return {
            data_type = lexer_token.type,
            lexeme = lexer_token.lexeme,
            type = 'LiteralExpression',
        }
    end

    error('is not data type: ' .. self:peekable().lexeme)
end

function parser.parse_grouped_expression(self: Parser): GroupedExpression
    if self:next().type ~= 'LeftParen' then
        error('is not grouped: ' .. self:peekable().lexeme)
    end

    if self:peekable().type == 'RightParen' then
        local nil_expression = ast.nil_expression()
        nil_expression.lexeme = '()'
        return {
            expression = nil_expression,
            type = "GroupedExpression",        
        }
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
    local return_native_type: NativeType?

    if self:peekable().type ~= 'RightParen' then
        parameters = self:parse_parameter_nodes()
    end

    if self:peekable() and self:next().type ~= 'RightParen' then
        error('not closed function paren: ' .. self:peekable().lexeme)
    end
    
    if self:peekable() and self:peekable().type == 'Colon' then
        self:next()
        return_native_type = self:parse_native_expression_type()
    end

    if self:peekable() and self:next().type ~= 'LeftBrace' then
        error('not used function brace: ' .. self:peekable().lexeme)
    end

    local ast_nodes = self:parse_ast_node()
    local function_expression: FunctionExpression = {
        parameters = parameters,
        body = ast_nodes.body,
        return_expression = ast_nodes.return_expression,
        return_native_type = return_native_type,
        type = 'FunctionExpression',
    }
    
    if self:peekable() and self:next().type ~= 'RightBrace' then
        error('is not closed function: ' .. self:peekable().lexeme)
    end

    return function_expression
end

function parser.parse_struct_expression(self: Parser): StructExpression
    if self:next().type ~= 'Struct' then
        error('is not struct: ' .. self:peekable().lexeme)
    end
    
    local parameters: { ParameterNode } = {}
    
    if self:peekable().type == 'LeftParen' then
        self:next()

        if self:peekable().type ~= 'RightParen' then
            local tuple = self:parse_tuple_expression()
            for i=1, #tuple do
                parameters[i] = {
                    expression = tuple[i],
                    type = 'ParameterNode',
                }
            end

            if self:next().type ~= 'RightParen' then
                error('not closed struct paren')
            end
        else
            self:next()
        end
    end

    if self:next().type ~= 'LeftBrace' then
        error('function not use left paren')
    end

    local struct_node: StructExpression = {
        parameters = parameters,
        body = {},
        type = 'StructExpression',
    }
    
    while self:peekable().type ~= 'RightBrace' do
        local identifier = self:next()
        
        if identifier.type ~= 'Identifier' then
            error('struct key is only identifier: ' .. identifier.lexeme)
        end

        if self:next().type ~= 'Colon' then
            error('sruct type is use colon: ' .. self:peekable(-1).type)
        end

        struct_node.body[identifier.lexeme] = self:parse_expression()
    end

    self:next()

    return struct_node
end

function parser.parse_expression(self: Parser): Expression
    local token = self:peekable()
    local expression: Expression
    
    if self:is_data_type() then
        expression = self:parse_literal_expressions()
    elseif self:is_operator_token() then
        expression = self:parse_expression_binary(expression)
    elseif token.type == 'LeftParen' then
        expression = self:parse_grouped_expression()

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
    elseif token.type == 'LeftBrace' then
        expression = self:parse_array_expression()
    elseif token.type == 'Identifier' then
        expression = self:parse_identifier_expression()

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
    elseif token.type == 'Function' then
        expression = self:parse_function_expression()

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
    elseif token.type == 'Struct' then
        expression = self:parse_struct_expression()
    else
        error('any parser error (parse expression)')
    end
    
    return expression
end

function parser.parse_native_expression_type(self: Parser, expression: Expression?): NativeType
    local expression = expression or self:parse_expression()
    local native_type: NativeType

    if expression.type == 'IndexAccessExpression' or expression.type == 'BinaryExpression' then
        error('this is not type expression: ' .. expression.type)
    end

    if expression.type == 'GroupedExpression' then
        if self:peekable().type == 'TypeArrow' then
    -- if expression.type == 'FunctionCallExpression' then
    --     if expression.expression.type ~= 'VariableExpression' then
    --         error('this is not type expression: ' .. expression.expression.type)
    --     end

    --     if expression.expression.expression_name ~= 'fn' then
    --         error('this is not type expression: ' .. expression.expression.expression_name)
    --     end

    --     local parameters = {}

    --     for i=1, #expression.args do

    --     end

    --     native_type = {
    --         type = "NumberNativeType",
    --     }

    -- end
        else
            native_type = self:parse_native_expression_type(expression.expression) 
        end
    end

    if expression.type == 'GroupedExpression' then
        error('this is not type expression: ' .. expression.type)
    end

    if expression.type == 'ArrayExpression' then
        native_type = {
            type = "ArrayNativeType",
        }
        for i=1, #expression.args do
            native_type[i] = self:parse_native_expression_type(expression.args[i])
        end
    end

    if expression.type == 'VariableExpression' then
        if expression.expression_name == 'number' then
            native_type = {
                type = "NumberNativeType",
            }
        elseif expression.expression_name == 'string' then
            native_type = {
                type = "StringNativeType",
            }
        elseif expression.expression_name == 'boolean' then
            native_type = {
                type = "BooleanNativeType",
            }
        elseif expression.expression_name == 'nil' then
            native_type = {
                type = "NilNativeType",
            }
        end
    end

    return native_type
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

        if self:peekable().type == 'Colon' then
            self:next()
            variable_node.native_expression_type = self:parse_native_expression_type()
        end

        if self:peekable() and self:peekable().type == 'Equal' then
            self:next()
        
            variable_node.initial_value = self:parse_expression()
        end

        variable_nodes[i] = variable_node
    end

    return variable_nodes
end

function parser.parse_const_node(self: Parser): { VariableNode }
    if self:next().type ~= 'Const' then
        error('is not const: ' .. self:peekable().lexeme)
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
            is_const = true,
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

function parser.parse_function_node(self: Parser): FunctionNode
    if self:next().type ~= 'Function' then
        error('is not function: ' .. self:peekable().lexeme)
    end

    local identifier_expression: VariableExpression = self:parse_identifier_expression()

    if self:next().type ~= 'LeftParen' then
        error('function not use left paren')
    end
    
    local parameters: { ParameterNode } = {}
    local return_native_type: NativeType?

    if self:peekable().type ~= 'RightParen' then
        parameters = self:parse_parameter_nodes()
    end

    if self:peekable() and self:next().type ~= 'RightParen' then
        error('not closed function paren: ' .. self:peekable().lexeme)
    end
    
    if self:peekable() and self:peekable().type == 'Colon' then
        self:next()
        return_native_type = self:parse_native_expression_type()
    end

    if self:peekable() and self:next().type ~= 'LeftBrace' then
        error('not used function brace: ' .. self:peekable().lexeme)
    end

    local ast_nodes = self:parse_ast_node()
    local function_node: FunctionNode = {
        identifier_expression = identifier_expression,
        parameters = parameters,
        body = ast_nodes.body,
        return_expression = ast_nodes.return_expression,
        return_native_type = return_native_type,
        type = 'FunctionNode',
    }
    
    if self:peekable() and self:next().type ~= 'RightBrace' then
        error('is not closed function: ' .. self:peekable().lexeme)
    end

    return function_node
end

function parser.parse_struct_node(self: Parser): StructNode
    if self:next().type ~= 'Struct' then
        error('is not struct: ' .. self:peekable().lexeme)
    end
    
    local expression = self:parse_expression()
    local parameters: { ParameterNode } = {}
    local identifier_expression: VariableExpression
    
    if expression.type ~= 'VariableExpression' and expression.type ~= 'FunctionCallExpression' then
        error('this not struct expression')
    end

    if expression.type == 'FunctionCallExpression' then
        if expression.expression.type ~= 'VariableExpression' then
            error('this not struct expression')
        end

        parameters = expression.args
        identifier_expression = expression.expression
    else
        identifier_expression = expression
    end

    if self:next().type ~= 'LeftBrace' then
        error('function not use left paren')
    end

    local struct_node: StructNode = {
        identifier_expression = identifier_expression,
        parameters = parameters,
        body = {},
        type = 'StructNode',
    }
    
    while self:peekable().type ~= 'RightBrace' do
        local identifier = self:next()
        
        if identifier.type ~= 'Identifier' then
            error('struct key is only identifier: ' .. identifier.lexeme)
        end

        if self:next().type ~= 'Colon' then
            error('sruct type is use colon: ' .. self:peekable(-1).type)
        end

        struct_node.body[identifier.lexeme] = self:parse_expression()
    end

    self:next()

    return struct_node
end

function parser.parse_ast_node(self: Parser): { body: { AstNode }, return_expression: { Expression } }
    local body: { AstNode } = {}
    local return_expression: { Expression }

    while true do
        local token = self:peekable()
        
        if not token then
            break
        end
        
        if token.type == 'Eof' or token.type == 'RightBrace' then
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

        if token.type == 'Struct' then
            local struct_node = self:parse_struct_node()
            body[#body + 1] = struct_node
            continue
        end

        if token.type == 'Return' then
            self:next()

            if not (self:peekable().type == 'Eof' or self:peekable().type == 'RightBrace') then
                return_expression = self:parse_tuple_expression()
            end
            
            break
        end

        error('parser ast any error: ' .. self:peekable().lexeme)
    end

    return {
        body = body,
        return_expression = return_expression or { ast.nil_expression() }
    }
end

return parser
