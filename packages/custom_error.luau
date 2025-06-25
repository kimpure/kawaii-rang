local custom_error = {}
custom_error.__index = custom_error

export type CustomErrorInfo = {
    line: number,
    current: number,
    error_type: string,
    error_message: string,
}

export type CustomError = typeof(setmetatable({} :: {
    file: string?,
    errors: { [number]: CustomErrorInfo },
}, custom_error))

custom_error.error_type = {
    SyntaxError = "SyntaxError",
    LexicalError = "LexicalError",
}

function custom_error.new(file: string?): CustomError
    return setmetatable({
        file = file,
        errors = {},
    }, custom_error)
end

function custom_error.push(self: CustomError, info: CustomErrorInfo)
    self.errors[#self.errors + 1] = info
end

function custom_error.format_error(self: CustomError, info: CustomErrorInfo): string
    return `[{self.file and self.file .. ":" or ""}{info.line}:{info.current}] {info.error_type}: {info.error_message}`
end

function custom_error.stdout(self: CustomError): string
    local result = ""

    for i=1, #self.errors do
        result ..= self:format_error(self.errors[i]) .. '\n'
    end

    return result
end

function custom_error.error(self: CustomError)
    error(self:stdout())
end

return custom_error
