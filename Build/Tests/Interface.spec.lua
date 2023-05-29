local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function()
	local Infinity = require(ReplicatedStorage.Packages.Infinity)

	it("Should be able to generate a mix of Singletons & Objects", function()
		Infinity.Singleton.new({
			Name = "InterfaceTest",

			Components = {
				Object = Infinity.Component.new({ Name = "Object" })
			}
		})
	end)

	it("Should be able to recieve default lifecycle events", function()
		local singleton = Infinity.Singleton.new({
			Name = "InterfaceTest_0",

			Components = {
				Object = Infinity.Component.new({ Name = "Object" })
			}
		})

		local lifecycleFlag = false

		function singleton:OnStart()
			lifecycleFlag = true
		end

		local success, response = Infinity:Start():await()

		expect(success).to.equal(true)
		expect(lifecycleFlag).to.equal(true)
	end)
end