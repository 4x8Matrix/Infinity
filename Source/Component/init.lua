-- // Dependencies
local Sift = require(script.Parent.Parent.Sift)

-- // Module
local Component = { }

Component.Type = "Component"

Component.Interface = { }
Component.Prototype = { }

function Component.Prototype:ToString()
	return `{Component.Type}<"{self.Name}">`
end

function Component.Prototype:Extend(source)
	assert(type(source) == "table", `Expected 'source' argument to be a table, got {type(source)}`)
	assert(type(source.Name) == "string", `Expected 'source.Name' to be a string, got {type(source.Name)}`)

	return Component.Interface.new(Sift.Dictionary.mergeDeep(self, source))
end

function Component.Interface.new(source)
	assert(type(source) == "table", `Expected 'source' argument to be a table, got {type(source)}`)

	local self = setmetatable(source, {
		__index = Component.Prototype,
		__type = Component.Type,

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

	for _, component in self.Components or { } do
		component.Super = self
	end

	for _, extension in self.Extensions or { } do
		for index, value in extension do
			if self[index] then
				continue
			end

			self[index] = value
		end
	end

	return self
end

function Component.Interface.is(source)
	if not source or type(source) ~= "table" then
		return
	end

	local metatable = getmetatable(source)

	return metatable and metatable.__type == Component.Type
end

return Component.Interface