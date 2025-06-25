local custom_error = {}
custom_error.__index = custom_error

export type CustomError = typeof(setmetatable({} :: {
    errors: {
        [number]: {
            file: string?,
            line: number,
            current: number,
            error_type: string,
            error_message: string,
        }
    }
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

function custom_error.push(self: CustomError, info: {
    file: string?, 
    line: number,
    cureent: number, 
    error_type: string,
    error_message: string,
})
    self.errors[#self.errors + 1] = {
        file = info.file,
        line = info.line,
        current = info.cureent,
        error_type = info.error_type,
        error_message = info.error_message,
    }
end

return custom_error
