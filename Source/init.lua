-- // Dependencies
local Promise = require(script.Parent.Promise)
local Signal = require(script.Parent.Signal)

-- // Module
local Infinity = { }

Infinity.Internal = { }
Infinity.Interface = { }

Infinity.Interface.Component = require(script.Component)
Infinity.Interface.Singleton = require(script.Singleton)

Infinity.Internal.ComponentTagAdded = Signal.new()
Infinity.Internal.ComponentTagRemoved = Signal.new()

function Infinity.Interface:Start()
	return Promise.new(function(resolve)
		local singletons = Infinity.Interface.Singleton._getInstances()

		for _, singleton in singletons do
			singleton:InvokeLifecycle("OnStart")
		end

		resolve()
	end)
end

return Infinity.Interface