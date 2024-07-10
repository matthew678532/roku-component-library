function TestSuite__ChannelPerformanceComponent__Suite() as Object
  this = BaseSuiteTest()

  this.name = "TestSuite__ChannelPerformanceComponent__Tests"

  this.addTest("TestCase__ExportsBeaconIds", TestCase__ExportsBeaconIds)
  this.addTest("TestCase__ExportsBeaconTypes", TestCase__ExportsBeaconTypes)
end function

function TestCase__ExportsBeaconIds() as Object
  globalAA = getGlobalAA()

  requiredIds = ["EpgLaunch", "AppDialog", "AppLaunch"]

  return m.assertAAHasKeys(globalAA.top.beaconIds, requiredIds)
end function

function TestCase__ExportsBeaconTypes() as Object
  globalAA = getGlobalAA()

  beaconTypes = ["Initiate", "Complete"]

  return m.assertAAHasKeys(globalAA.top.beaconTypes, beaconTypes)
end function