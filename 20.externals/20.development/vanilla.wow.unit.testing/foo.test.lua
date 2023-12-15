Numbers = function()
    return 1, 2, 3
end

FoobarTestGroup = VWoWUnit.I:GetOrCreateGroup('MyAddonName')

FoobarTestGroup:AddTest("PassingTest", function()
    VWoWUnit:AreEqual({ 1, 2, 3 }, { Numbers() })

    VWoWUnit:IsTrue(true)
end)

FoobarTestGroup:AddTest("FaillingTest", function()
    VWoWUnit:AreEqual('Apple', 'Pie')

    VWoWUnit:IsTrue(false)
end)
