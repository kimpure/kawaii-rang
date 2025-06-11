local ast = require('./ast')
local lexer = require('./lexer')

export type Token = lexer.Token
export type TokenType = lexer.TokenType

export type Expression = ast.Expression
export type LiteralExpression = ast.LiteralExpression
export type FunctionCallExpression = ast.FunctionCallExpression
export type IndexAccessExpression = ast.IndexAccessExpression

export type AstNode = ast.AstNode
export type ParameterNode = ast.ParameterNode

export type ParserIdentifier = ast.ParserIdentifier

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

function parser.parse_identifier(self: Parser): ParserIdentifier
    local identifier = self:next()

    local next_token = self:peekable()

    if identifier.type ~= 'Identifier' then
        error('identifier not match: ' .. identifier.lexeme)
    end

    if next_token.type == 'LeftParen' then
        return {
            identifier = identifier,
            type = 'Function',
        } :: any
    end

    if next_token.type == 'LeftBrack' then
        return {
            identifier = identifier,
            type = 'IndexAccess',
        } :: any
    end

    return {
        identifier = identifier,
        type = 'Variable',
    } :: any
end

function parser.parse_deep_function_call(self: Parser, expression: Expression): Expression
    local function_expression = {
        expression = expression,
        args = {},
        type = "FunctionCallExpression",
    } :: FunctionCallExpression

    if self:next().type ~= 'LeftParen' then
        error('is not function : ' .. self:peekable().lexeme)
    end
    
    if self:peekable().type ~= 'RightParen' then
        local parameters = self:parse_tuple_expression()
        
        for i=1, #parameters do
            parameters[i] = {
                expression = parameters[i],
                type = "ParameterNode"
            }
        end
    
        function_expression.args = parameters :: any
    
        if self:peekable().type ~= 'RightParen' then
            error('not close paren of function : ' .. self:peekable().lexeme)
        end
    end

    self:next()

    if self:peekable().type == 'LeftParen' then
        return self:parse_deep_function_call(function_expression) :: FunctionCallExpression
    end

    if self:peekable().type == 'LeftBrack' then
        return self:parse_deep_index_access(function_expression) :: IndexAccessExpression
    end

    return function_expression
end

function parser.parse_deep_index_access(self: Parser, target: Expression): Expression
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

    if self:peekable().type == 'LeftBrack' then
        return self:parse_deep_index_access(index_access_expression) :: IndexAccessExpression
    end

    if self:peekable().type == 'LeftParen' then
        return self:parse_deep_function_call(index_access_expression) :: FunctionCallExpression
    end

    return index_access_expression
end

function parser.parse_expression(self: Parser): Expression
    local data_type = self:peekable()
    
    if data_type.type == 'String' or data_type.type == 'Number' or data_type.type == 'Boolean' or data_type.type == 'Nil' then
        self:next()
        return {
            data_type = data_type.type,
            lexeme = data_type.lexeme,
            line = data_type.line,
            type = 'LiteralExpressions',
        }
    end

    local identifier_info = self:parse_identifier()
    local expression: Expression

    if identifier_info.type == 'Variable' then
        expression = {
            name = identifier_info.identifier.lexeme,
            type = 'VariableExpression',
        }
    end

    if identifier_info.type == 'Function' then
        expression = self:parse_deep_function_call(identifier_info.identifier)
    end

    if identifier_info.type == 'IndexAccess' then
        expression = self:parse_deep_index_access(identifier_info.identifier)
    end

    local operator = self:peekable()

    if 
        operator.type == 'Add' or 
        operator.type == 'Sub' or 
        operator.type == 'Mul' or 
        operator.type == 'Div' or 
        operator.type == 'GreaterEqual' or 
        operator.type == 'LessEqual' or 
        operator.type == 'Greater' or 
        operator.type == 'Less' or 
        operator.type == 'Equal' or 
        operator.type == 'NotEqual' or 
        operator.type == 'And' or 
        operator.type == 'Or' 
    then
        self:next()
        expression = {
            left = expression,
            operator = operator.type,
            right = self:parse_expression(),
            type = "IndexAccessExpression",
        }
    end

    return expression
end

return parser
