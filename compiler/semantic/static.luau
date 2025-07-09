local ast = require("@ast/ast")
local symbol_table = require("@packages/symbol_table")

type Statement = ast.Statement
type Expression = ast.Expression
type AstNode = ast.AstNode
type Block = ast.Block

type SymbolTable = symbol_table.SymbolTable

local static_semantic = {}

export type StaticSemantic = typeof(setmetatable({} :: {
    variable_symbols: SymbolTable,
    function_symbols: SymbolTable,
    type_symbols: SymbolTable,

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

function static_semantic.check(self: StaticSemantic, expression: Expression)
    
end

return static_semantic
