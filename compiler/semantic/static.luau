local ast = require("@ast/ast")
local symbol_table = require("@packages/symbol_table")

type Expression = ast.Expression
type Statement = ast.Statement
type VariableAstNode = ast.VariableAstNode
type AstNode = ast.AstNode
type Block = ast.Block

type SymbolTable<T> = symbol_table.SymbolTable<T>

local static_semantic = {}

export type StaticSemantic = typeof(setmetatable({} :: {
    variable_symbols: SymbolTable<{}>,
    function_symbols: SymbolTable<{}>,
    type_symbols: SymbolTable<{}>,

    nodes: Block,
}, static_semantic))

function static_semantic.create(nodes: Block, parent: StaticSemantic?): StaticSemantic
    return setmetatable({
        variable_symbols = symbol_table.new(parent and parent.variable_symbols or nil),
        function_symbols = symbol_table.new(parent and parent.function_symbols or nil),
        type_symbols = symbol_table.new(parent and parent.type_symbols or nil),
    
        nodes = nodes,
    }, static_semantic)
end

function static_semantic.variable_ast_node(self: StaticSemantic, variable_ast_node: VariableAstNode)
    self.variable_symbols:define(variable_ast_node.name, {})
end

function static_semantic.expression(self: StaticSemantic, expression: Expression)
    
end

return static_semantic
