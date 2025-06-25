local custom_error = {}
custom_error.__index = custom_error

export type CustomError = typeof(setmetatable({} :: {

}, custom_error))

return custom_error
