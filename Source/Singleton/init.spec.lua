return function()
	local Singleton = require(script.Parent)

	it("Should be able to generate an object", function()
		expect(Singleton.new({ Name = "Test" })).to.be.ok()
	end)

	it("Should fail when an invalid name has been given", function()
		expect(function()
			Singleton.new({ Name = 123 })
		end).to.throw()

		expect(function()
			Singleton.new()
		end).to.throw()
	end)

	it("Should fail when generating an already existing object", function()
		expect(function()
			Singleton.new({ Name = "Test" })
		end).to.throw()
	end)

	it("Should identify as an 'Singleton' object", function()
		local object = Singleton.new({ Name = "Test_0" })

		expect(Singleton.is(object)).to.equal(true)
	end)

	describe("Singleton ':ToString' method", function()
		it("Should be able to generate name when calling :ToString", function()
			local object = Singleton.new({ Name = "Test_1" })

			expect(object:ToString()).to.equal(`Singleton<"Test_1">`)
		end)

		it("Should call :ToString when calling 'tostring' on object", function()
			local object = Singleton.new({ Name = "Test_2" })

			expect(tostring(object)).to.equal(`Singleton<"Test_2">`)
		end)
	end)

	describe("Singleton lifecycle patterns", function()
		it("Shouldn't error if there's no lifecycle method", function()
			local object = Singleton.new({ Name = "Test_3" })

			expect(function()
				object:InvokeLifecycle("LifecycleTest")
			end).never.to.throw()
		end)

		it("Should be able to call lifecycles", function()
			local object = Singleton.new({ Name = "Test_4" })
			local lifecycleFlag = false

			function object:lifecycle()
				lifecycleFlag = true
			end

			object:InvokeLifecycle("lifecycle")

			expect(lifecycleFlag).to.equal(true)
		end)

		it("Should be able to handle varadic lifecycle arguments", function()
			local object = Singleton.new({ Name = "Test_5" })
			local lifecycleFlag = false

			function object:lifecycle(...)
				lifecycleFlag = ...
			end

			object:InvokeLifecycle("lifecycle", 1)

			expect(lifecycleFlag).to.equal(1)
		end)

		it("Should return the result of a lifecycle call", function()
			local object = Singleton.new({ Name = "Test_6" })

			function object:lifecycle()
				return 123
			end

			expect(object:InvokeLifecycle("lifecycle")).to.equal(123)
		end)
	end)
end