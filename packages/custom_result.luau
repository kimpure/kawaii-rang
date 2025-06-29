export type Ok<T> = { 
    kind: "CustomResultOk", 
    value: T 
}

export type Err<U> = { 
    kind: "CustomResultErr", 
    error: U 
}

export type Result<T, U> = Ok<T> | Err<U>

export type CustomResultImpl<T, U> = {
    __index: CustomResultImpl<T, U>,
    isOk: (self: CustomResult<T, U>) -> (Ok<T>?),
	isErr: (self: CustomResult<T, U>) -> (Err<U>?),
	Ok: (self: CustomResult<T, U>, value: T) -> (),
	Err: (self: CustomResult<T, U>, error: U) -> (),
}

local custom_result = {}
custom_result.__index = custom_result

export type CustomResult<T, U> = typeof(setmetatable({} :: {
    value: Result<T, U>?
}, custom_result))

function custom_result.new<T, U>(): CustomResult<T, U>
	return setmetatable({}, custom_result)
end

function custom_result.Ok<T, U>(self: CustomResult<T, U>, value: T)
	self.value = { 
        kind = "CustomResultOk", 
        value = value 
    }
end

function custom_result.Err<T, U>(self: CustomResult<T, U>, error: U)
	self.value = { 
        kind = "CustomResultErr", 
        error = error, 
    }
end

function custom_result.isOk<T, U>(self: CustomResult<T, U>): Ok<T>?
	if self.value and self.value.kind == "CustomResultOk" then
		return self.value
	end
	return nil
end

function custom_result.isErr<T, U>(self: CustomResult<T, U>): Err<U>?
	if self.value and self.value.kind == "CustomResultErr" then
		return self.value
	end
	return nil
end

return custom_result
