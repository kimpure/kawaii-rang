local ast = require("@ast/ast")
local custom_error = require("@packages/custom_error")
local result = require("@packages/result")
local symbol_table = require("@packages/symbol_table")

type Expression = ast.Expression
type Statement = ast.Statement
type VariableAstNode = ast.VariableAstNode
type AstNode = ast.AstNode
type Block = ast.Block

type Result<T, U> = result.Result<T, U>
type CustomErrorInfo = custom_error.CustomErrorInfo
type SymbolTable<T> = symbol_table.SymbolTable<T>

type BlockType = 
    | "Program"
    | "If"
    | "For"
    | "While"
    | "Function"

local error_type = custom_error.error_type
local UnknownSymbol = error_type.UnknownSymbol

local ok = result.Ok(nil)

local static_semantic = {}
static_semantic.__index = static_semantic

export type StaticSemantic = typeof(setmetatable({} :: {
    variable_symbols: SymbolTable<{}>,
    function_symbols: SymbolTable<{}>,
    type_symbols: SymbolTable<{}>,

    nodes: Block,
    block_type: BlockType,
}, static_semantic))

function static_semantic.create(nodes: Block, parent: StaticSemantic?, block_type: BlockType?): StaticSemantic
    return setmetatable({
        variable_symbols = symbol_table.new(parent and parent.variable_symbols or nil),
        function_symbols = symbol_table.new(parent and parent.function_symbols or nil),
        type_symbols = symbol_table.new(parent and parent.type_symbols or nil),
    
        nodes = nodes,
        block_type = block_type or "Program" :: "Program",
    }, static_semantic)
end

function static_semantic.variable_ast_node(self: StaticSemantic, variable_ast_node: VariableAstNode): Result<nil, CustomErrorInfo>
    local result = self.variable_symbols:define(variable_ast_node.name, {})

    if result:isErr() then
        return result.Err(result:unwrapErr())
    end

    return ok
end

function static_semantic.expression(self: StaticSemantic, expression: Expression): Result<nil, CustomErrorInfo>
    if expression.type == "VariableExpression" then
        if not self.variable_symbols:lookup(expression.name) then
            return result.Err {
                line = "Unknown Global",
                error_type = UnknownSymbol,
                error_message = `Cannot find variable '{expression.name}'. Make sure it is declared.`,
            }
        end

        return ok
    end

    return ok
end

local parser, start = require"@ast/parser".create [[
var a
a
]], os.clock();

(function() 
    local result = parser:unwrap():parse_ast_nodes()
    
    if result:isErr() then
        return print(custom_error.format_error(result:unwrapErr()))
    end
    
    local ast_nodes = result:unwrap()
    local static = static_semantic.create(ast_nodes)
    
    for i=1, #ast_nodes do
        local node = ast_nodes[i]
    
        if node.type == "VariableAstNode" then
            local result = static:variable_ast_node(node)
    
            if result:isErr() then
                return print(custom_error.format_error(result:unwrapErr()))
            end
    
            continue
        end
    
        if node.type == "VariableExpression" then
            local result = static:expression(node)
    
            if result:isErr() then
                return print(custom_error.format_error(result:unwrapErr()))
            end
    
            continue
        end
    end
end)()


print('\n\ntime: ', os.clock() - start)

return static_semantic
