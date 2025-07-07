local custom_error = {}
custom_error.__index = custom_error

export type CustomErrorInfo = {
    file: string?,
    line: number | string,
    current: number?,
    error_type: string,
    error_message: string,
}

export type CustomError = typeof(setmetatable({} :: {
    file: string?,
    errors: { [number]: CustomErrorInfo },
}, custom_error))

custom_error.error_type = {
    SyntaxError = "Syntax Error",
    LexicalError = "Lexical Error",
    UnexpectedError = "Unexpected Error",
    TypeError = "Type Error"
}

function custom_error.new(file: string?): CustomError
    return setmetatable({
        file = file,
        errors = {},
    }, custom_error)
end

function custom_error.push(self: CustomError, info: CustomErrorInfo)
    info.file = info.file or self.file
    self.errors[#self.errors + 1] = info
end

function custom_error.extends(self: CustomError, line: number, cureent: number?, file: string?)
    if #self.errors <= 0 then
        return self:push {
            file = file,
            line = line,
            current = cureent,
            error_type = custom_error.error_type.UnexpectedError,
            error_message = "any error (not thing)",
        }
    end

    self:push {
        file = file,
        line = line,
        current = cureent,
        error_type = self.errors[#self.errors].error_type,
        error_message = `{self.errors[#self.errors].error_message} (with extends {self.errors[#self.errors].file or "any file"})`,
    }
end

function custom_error.extends_errors(self: CustomError, extends_class: CustomError)
    for i=1, #extends_class.errors do
        self.errors[#self.errors + 1] = extends_class.errors[i] 
    end
end

function custom_error.format_error(info: CustomErrorInfo): string
    return `[{info.file and info.file .. ":" or ""}{info.line}{info.current and ":" .. info.current or ""}] {info.error_type}: {info.error_message}`
end

function custom_error.stdout(self: CustomError): string
    local result = ""

    for i=1, #self.errors do
        result ..= custom_error.format_error(self.errors[i]) .. "\n"
    end

    return result
end

function custom_error.error(self: CustomError)
    error(self:stdout())
end

return custom_error
