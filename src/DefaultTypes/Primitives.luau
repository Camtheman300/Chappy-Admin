local _K

local function simpleValidate(v)
	return v ~= nil
end

local booleanType = {
	transform = string.lower,
	validate = function(v)
		return string.find("true", v, 1, true) == 1 or string.find("false", v, 1, true) == 1,
			"Only use true or false for booleans."
	end,
	parse = function(v)
		if string.find("true", v, 1, true) == 1 then
			return true
		elseif string.find("false", v, 1, true) == 1 then
			return false
		else
			error("Invalid boolean value.")
		end
	end,
	log = function(arg)
		return _K.Util.Table.concat(arg.parsedArgs, ",")
	end,
	suggestions = function(text: string, from: number)
		return _K.Util.Suggest.query(text, { "true", "false" })
	end,
}

local integerType = {
	transform = function(v)
		return if v == "" then 0 else tonumber(v)
	end,
	validate = function(v)
		return v ~= nil and v == math.floor(v), "Only whole numbers are valid."
	end,
	parse = function(v)
		return v
	end,
}

local numberType = {
	transform = integerType.transform,
	validate = simpleValidate,
	parse = function(v)
		return v
	end,
}

local stringType = {
	validate = simpleValidate,
	parse = tostring,
}

return function(context)
	_K = context
	_K.Registry.registerType("boolean", booleanType)
	_K.Registry.registerType("booleans", {
		listable = true,
	}, booleanType)
	_K.Registry.registerType("integer", integerType)
	_K.Registry.registerType("integers", {
		listable = true,
	}, integerType)
	_K.Registry.registerType("number", numberType)
	_K.Registry.registerType("numbers", {
		listable = true,
	}, numberType)
	_K.Registry.registerType("string", stringType)
	_K.Registry.registerType("strings", {
		listable = true,
	}, stringType)
	_K.Registry.registerType("stringGreedy", {
		displayName = "string",
		validate = simpleValidate,
		parse = tostring,
	})
end
