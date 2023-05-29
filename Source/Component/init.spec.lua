return function()
	local Component = require(script.Parent)

	it("Should be able to generate an object", function()
		expect(Component.new({ Name = "Test" })).to.be.ok()
	end)

	it("Should fail when an invalid name has been given", function()
		expect(function()
			Component.new({ Name = 123 })
		end).to.throw()

		expect(function()
			Component.new()
		end).to.throw()
	end)

	it("Should identify as an 'Component' object", function()
		local object = Component.new({ Name = "Test" })

		expect(Component.is(object)).to.equal(true)
	end)

	describe("Component ':ToString' method", function()
		it("Should be able to generate name when calling :ToString", function()
			local object = Component.new({ Name = "Test" })

			expect(object:ToString()).to.equal(`Component<"Test">`)
		end)

		it("Should call :ToString when calling 'tostring' on object", function()
			local object = Component.new({ Name = "Test" })

			expect(tostring(object)).to.equal(`Component<"Test">`)
		end)
	end)

	describe("Component ':Extend' method", function()
		it("Should be able to Extend from an object", function()
			local object = Component.new({
				Name = "Test",

				Property = 123
			})

			local object2 = object:Extend({
				Name = "Test2"
			})

			expect(object2.Name).to.equal(`Test2`)
			expect(object2.Property).to.equal(123)
		end)
	end)

	describe("Component 'Extensions' table", function()
		it("Should be able to inherit fields from 'Extensions' tables", function()
			local object = Component.new({
				Name = "Test",

				Extensions = {
					{ Property = 123, Name = "Test2" }
				}
			})

			expect(object.Name).to.equal(`Test`)
			expect(object.Property).to.equal(123)
		end)
	end)

	describe("Component 'Components' table", function()
		it("Should be able to instantiate child components", function()
			local object1, object2

			object2 = Component.new({ })
			object1 = Component.new({
				Name = "Test",

				Components = { object = object2 }
			})

			expect(object1.Name).to.equal(`Test`)
			expect(object1.Components.object.Super).to.equal(object1)
		end)
	end)
end