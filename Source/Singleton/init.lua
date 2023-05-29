-- // Dependencies
local Sift = require(script.Parent.Parent.Sift)

-- // Module
local Singleton = { }

Singleton.Type = "Singleton"

Singleton.Instances = { }

Singleton.Interface = { }
Singleton.Prototype = { }

function Singleton.Prototype:ToString()
	return `{Singleton.Type}<"{self.Name}">`
end

function Singleton.Prototype:InvokeLifecycle(lifecycleName, ...)
	if not self[lifecycleName] then
		return
	end

	return self[lifecycleName](self, ...)
end

function Singleton.Interface._getInstances()
	return Sift.Dictionary.values(Singleton.Instances)
end

function Singleton.Interface.new(source)
	assert(type(source) == "table", `Expected 'source' argument to be a table, got {type(source)}`)

	local self = setmetatable(source, {
		__index = Singleton.Prototype,
		__type = Singleton.Type,

		__tostring = function(object)
			return object:ToString()
		end
	})

	if self.Name then
		assert(type(self.Name) == "string", `Expected 'source.Name' to be a string, got {type(source.Name)}`)
	else
		local sourceFullName = string.split(debug.info(2, "s"), ".")
		local sourceName = sourceFullName[#sourceFullName]

		self.Name = sourceName
	end

	assert(Singleton.Instances[self.Name] == nil, `Expected '{self.Name}' to be unique, '{self.Name}' already exists!`)

	Singleton.Instances[self.Name] = self
	return Singleton.Instances[self.Name]
end

function Singleton.Interface.is(source)
	if not source or type(source) ~= "table" then
		return
	end

	local metatable = getmetatable(source)

	return metatable and metatable.__type == Singleton.Type
end

return Singleton.Interface