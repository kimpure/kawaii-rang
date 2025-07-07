local ast = require("@ast/ast")
local parser = require("@ast/parser")

local result = require("@packages/result")
local custom_error = require("@packages/custom_error")

local error_type = custom_error.error_type
local TypeError = error_type.TypeError

type Block = ast.Block

type Result<T, U> = result.Result<T, U>
type CustomErrorInfo = custom_error.CustomErrorInfo

local ir = {}

export type IrNode = {
    operator: string,
    value: string,
}

export type Ir = typeof(setmetatable({} :: { IrNode }, ir))

function ir.create(source: string): Result<Ir, CustomErrorInfo>
    local parser_result = parser.create(source)

    if parser_result:isErr() then
        return result.Err(parser_result:unwrapErr())
    end

    local program_result = parser_result:unwrap():parse_ast_nodes()

    if program_result:isErr() then
        return result.Err(program_result:unwrapErr())
    end

    local lower = ir.lower(program_result:unwrap())

    if lower:isErr() then
        return result.Err(lower:unwrapErr())
    end

    return result.Ok(setmetatable(lower:unwrap(), ir))
end

function ir.lower(program: Block): Result<{ IrNode }, CustomErrorInfo>
    local ir_nodes: { IrNode } = {}

    for i=1, #program do
        local ast_node = program[i]

        if ast_node.type == "LiteralExpression" then
            if ast_node.annotated_type then
                if ast_node.data_type ~= ast_node.annotated_type then
                    local data_type_format = ast_node.data_type and ast_node.data_type.format or "nil"
                    return result.Err {
                        line = "Unknown global",
                        error_type = TypeError,
                        error_message = `Cannot cast '{data_type_format}' into '{(ast_node.annotated_type :: any).format or ast_node.annotated_type.type}' because the types are unrelated`,
                    }
                end
            end

            ir_nodes[#ir_nodes + 1] = {
                operator = "const",
                value = ast_node.value,
            }
            continue
        end

        if ast_node.type == "BinaryExpression" then

        end
    end

    return result.Ok(ir_nodes)
end

function ir.generate(self: Ir)
    --// TODO: 공부하기
end

local i, s = ir.create[[
var a = 1 :: string
]], os.clock()

print(
    i:isErr() and 
    custom_error.format_error(i:unwrapErr()) or 
    i:unwrap()
, os.clock() - s)

return ir
