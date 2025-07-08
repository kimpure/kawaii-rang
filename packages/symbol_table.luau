local result = require("@packages/result")
local custom_error = require("@packages/custom_error")

local error_type = custom_error.error_type
local UnexpectedError = error_type.UnexpectedError

local symbol_table = {}
symbol_table.__index = symbol_table

type Result<T, U> = result.Result<T, U>
type CustomErrorInfo = custom_error.CustomErrorInfo

export type SymbolTableInfo = {
    type: string,
}

export type SymbolTable = typeof(setmetatable({} :: {
    parent: SymbolTable?,
    entries: { [string]: SymbolTableInfo },
}, symbol_table))

function symbol_table.new(parent: SymbolTable?): SymbolTable
    return setmetatable({
        parent = parent,
        entries = {},
    }, symbol_table)
end

function symbol_table.define(self: SymbolTable, name: string, info: SymbolTableInfo): Result<nil, CustomErrorInfo>
    if self.entries[name] then
        return result.Err {
            line = "Unknown global",
            error_type = UnexpectedError,
            error_message = `'{name}' is already included in the SymbolTable.`,
        }
    end

    self.entries[name] = info

    return result.Ok(nil)
end

function symbol_table.lookup(self: SymbolTable, name: string): SymbolTableInfo?
    if self.entries[name] then 
        return self.entries[name]
    end
    
    if self.parent then 
        return self.parent:lookup(name)
    end

    return nil
end

return symbol_table
