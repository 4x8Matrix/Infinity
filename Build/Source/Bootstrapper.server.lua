local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EmoticonReporter = require(ReplicatedStorage.Reporters.EmoticonReporter)
local TestEz = require(ReplicatedStorage.DevPackages.TestEz)

if RunService:IsStudio() and not script.Parent.Development.Enabled then
	local Reporter = EmoticonReporter.new()

	TestEz.TestBootstrap:run({
		ReplicatedStorage.UnitTests,
		ReplicatedStorage.Packages.Infinity
	}, Reporter)

	Reporter:Print()
end
