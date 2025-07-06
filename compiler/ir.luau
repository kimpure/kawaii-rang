local ast = require("@ast/ast")
local parser = require("@ast/parser")

local result = require("@packages/result")
local custom_error = require("@packages/custom_error")

type Block = ast.Block

type Result<T, U> = result.Result<T, U>
type CustomErrorInfo = custom_error.CustomErrorInfo

local ir = {}

export type Ir = typeof(setmetatable({} :: {
    program: Block,
}, ir))

function ir.create(source: string): Result<Ir, CustomErrorInfo>
    local parser_result = parser.create(source)

    if parser_result:isErr() then
        return result.Err(parser_result:unwrapErr())
    end

    local program_result = parser_result:unwrap():parse_ast_nodes()

    if program_result:isErr() then
        return result.Err(program_result:unwrapErr())
    end

    return result.Ok(setmetatable({
        program = program_result:unwrap(),
    }, ir))
end

function ir.generate(self: Ir)
    
end

return ir
