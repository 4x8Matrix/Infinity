-- // Dependencies
local Promise = require(script.Parent.Promise)
local Signal = require(script.Parent.Signal)

-- // Constants
local DELAY_BEFORE_WARN = 5

-- // Module
local Infinity = { }

Infinity.Internal = { }
Infinity.Interface = { }

Infinity.Interface.Component = require(script.Component)
Infinity.Interface.Singleton = require(script.Singleton)

Infinity.Interface.OnStarted = Signal.new()
Infinity.Interface.Started = false

Infinity.Internal.Timeout = DELAY_BEFORE_WARN

Infinity.Internal.ComponentTagAdded = Signal.new()
Infinity.Internal.ComponentTagRemoved = Signal.new()

function Infinity.Interface:SetTimeout(Timeout)
	Infinity.Internal.Timeout = Timeout
end

function Infinity.Interface:Yield()
	if Infinity.Interface.Started then
		return
	end

	Infinity.Interface.OnStarted:Wait()
end

function Infinity.Interface:Start()
	return Promise.new(function(resolve)
		local singletons = Infinity.Interface.Singleton._getInstances()
		local singletonClocks = { }
		local activeThread = coroutine.running()

		for _, singleton in singletons do
			local singletonDelta = os.clock()
			local timeoutThread = task.delay(Infinity.Internal.Timeout, function()
				warn(`Singleton '{tostring(singleton)}' has taken over {Infinity.Internal.Timeout} to start.\nStack Begin\n{debug.traceback(activeThread)}\nStackEnd`)
			end)

			debug.profilebegin(singleton.Name)
			singleton:InvokeLifecycle("OnStart")
			debug.profileend()

			singletonClocks[singleton] = os.clock() - singletonDelta

			task.cancel(timeoutThread)
		end

		Infinity.Interface.Started = true
		Infinity.Interface.OnStarted:Fire(singletonClocks)

		resolve(singletonClocks)
	end)
end

return Infinity.Interface