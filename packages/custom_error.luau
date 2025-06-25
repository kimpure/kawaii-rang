local custom_error = {}
custom_error.__index = custom_error

export type CustomErrorInfo = {
    file: string?,
    line: number,
    current: number,
    error_type: string,
    error_message: string,
}

export type CustomError = typeof(setmetatable({} :: {
    errors: { [number]: CustomErrorInfo },
}, custom_error))

custom_error.error_type = {
    SyntaxError = "SyntaxError",
    LexicalError = "LexicalError",
}

function custom_error.new(): CustomError
    return setmetatable({
        errors = {},
    }, custom_error)
end

function custom_error.push(self: CustomError, info: CustomErrorInfo)
    self.errors[#self.errors + 1] = info
end

return custom_error
