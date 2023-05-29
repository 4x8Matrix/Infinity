-- // Dependencies
local Promise = require(script.Parent.Promise)
local Signal = require(script.Parent.Signal)

local DELAY_BEFORE_WARN = 5

-- // Module
local Infinity = { }

Infinity.Internal = { }
Infinity.Interface = { }

Infinity.Interface.Component = require(script.Component)
Infinity.Interface.Singleton = require(script.Singleton)

Infinity.Internal.Timeout = DELAY_BEFORE_WARN

Infinity.Internal.ComponentTagAdded = Signal.new()
Infinity.Internal.ComponentTagRemoved = Signal.new()

function Infinity.Interface:SetTimeout(Timeout)
	Infinity.Internal.Timeout = Timeout
end

function Infinity.Interface:Start()
	return Promise.new(function(resolve)
		local singletons = Infinity.Interface.Singleton._getInstances()
		local activeThread = coroutine.running()

		for _, singleton in singletons do
			local timeoutThread = task.delay(Infinity.Internal.Timeout, function()
				warn(`Singleton '{tostring(singleton)}' has taken over {Infinity.Internal.Timeout} to start.\nStack Begin\n{debug.traceback(activeThread)}\nStackEnd`)
			end)

			debug.profilebegin(singleton.Name)
			singleton:InvokeLifecycle("OnStart")
			debug.profileend()

			task.cancel(timeoutThread)
		end

		resolve()
	end)
end

return Infinity.Interface