function TestSuite__ChannelPerformanceComponent__Suite() as Object
  this = BaseTestSuite()

  this.name = "TestSuite__ChannelPerformanceComponent__Suite"

  this.addTest("TestCase__ExportsBeaconIds", TestCase__ExportsBeaconIds)
  this.addTest("TestCase__ExportsBeaconTypes", TestCase__ExportsBeaconTypes)
  this.addTest("TestCase__SendBeacon__UnsupportedBeacon", TestCase__SendBeacon__UnsupportedBeacon)
  this.addTest("TestCase__SendBeacon__UnknownBeaconByType", TestCase__SendBeacon__UnknownBeaconByType)
  this.addTest("TestCase__SendBeacon__CompleteWithoutInitiate", TestCase__SendBeacon__CompleteWithoutInitiate)
  this.addTest("TestCase__SendBeacon__AppLaunchCompleteWithoutInitiate", TestCase__SendBeacon__AppLaunchCompleteWithoutInitiate)
  this.addTest("TestCase__SendBeacon__InitiateByOS", TestCase__SendBeacon__InitiateByOS)
  this.addTest("TestCase__SendBeacon__CompleteByOS", TestCase__SendBeacon__CompleteByOS, TestCase__SendBeacon__CompleteByOS__Setup)
  this.addTest("TestCase__SendBeacon__InitiateCustom", TestCase__SendBeacon__InitiateCustom)
  this.addTest("TestCase__SendBeacon__CompleteCustom", TestCase__SendBeacon__CompleteCustom, TestCase__SendBeacon__CompleteCustom__Setup)
  this.addTest("TestCase__SendBeacon__InitiateCustomMessageStructure", TestCase__SendBeacon__InitiateCustomMessageStructure)
  this.addTest("TestCase__SendBeacon__CompleteCustomMessageStructure", TestCase__SendBeacon__CompleteCustomMessageStructure, TestCase__SendBeacon__CompleteCustomMessageStructure__Setup)

  return this
end function

function TestCase__ExportsBeaconIds() as Object
  self = getGlobalAA()
  beaconIds = ["EpgLaunch", "AppDialog", "AppLaunch", "AppLaunchCustom"]

  return m.assertAAHasKeys(self.top.beaconIds, beaconIds)
end function

function TestCase__ExportsBeaconTypes() as Object
  self = getGlobalAA()
  beaconTypes = ["Initiate", "Complete"]

  return m.assertAAHasKeys(self.top.beaconTypes, beaconTypes)
end function

function TestCase__SendBeacon__UnsupportedBeacon() as Object
  self = getGlobalAA()
  beaconId = "UnsupportedBeaconId"
  beaconType = "Initiate"

  response = self.top.callFunc("sendBeacon", beaconId, beaconType)

  return m.assertEqual(response.status, "error")
end function

function TestCase__SendBeacon__UnknownBeaconByType() as Object
  self = getGlobalAA()
  beaconId = "AppLaunch"
  beaconType = "UnknownBeaconByType"

  response = self.top.callFunc("sendBeacon", beaconId, beaconType)

  return m.assertEqual(response.status, "error")
end function

function TestCase__SendBeacon__CompleteWithoutInitiate() as Object
  self = getGlobalAA()
  beaconId = "EpgLaunch"
  beaconType = "Complete"

  response = self.top.callFunc("sendBeacon", beaconId, beaconType)

  return m.assertEqual(response.status, "error")
end function

' Special case for AppLauch, as it's OS driven it can be sent without an initiate
function TestCase__SendBeacon__AppLaunchCompleteWithoutInitiate() as Object
  self = getGlobalAA()
  beaconId = "AppLaunch"
  beaconType = "Complete"

  response = self.top.callFunc("sendBeacon", beaconId, beaconType)

  return m.assertEqual(response.status, "success")
end function

function TestCase__SendBeacon__InitiateByOS() as Object
  self = getGlobalAA()
  beaconId = "EpgLaunch"
  beaconType = "Initiate"

  response = self.top.callFunc("sendBeacon", beaconId, beaconType)

  return m.assertEqual(response.status, "success")
end function

sub TestCase__SendBeacon__CompleteByOS__Setup()
  self = getGlobalAA()
  beaconId = "EpgLaunch"
  beaconType = "Initiate"

  self.top.callFunc("sendBeacon", beaconId, beaconType)
end sub

function TestCase__SendBeacon__CompleteByOS() as Object
  self = getGlobalAA()
  beaconId = "EpgLaunch"
  beaconType = "Complete"

  response = self.top.callFunc("sendBeacon", beaconId, beaconType)

  return m.assertEqual(response.status, "success")
end function

function TestCase__SendBeacon__InitiateCustom() as Object
  self = getGlobalAA()
  beaconId = "AppLaunchCustom"
  beaconType = "Initiate"

  response = self.top.callFunc("sendBeacon", beaconId, beaconType)

  return m.assertEqual(response.status, "success")
end function

sub TestCase__SendBeacon__CompleteCustom__Setup()
  self = getGlobalAA()
  beaconId = "AppLaunchCustom"
  beaconType = "Initiate"

  self.top.callFunc("sendBeacon", beaconId, beaconType)
end sub

function TestCase__SendBeacon__CompleteCustom() as Object
  self = getGlobalAA()
  beaconId = "AppLaunchCustom"
  beaconType = "Complete"

  response = self.top.callFunc("sendBeacon", beaconId, beaconType)

  return m.assertEqual(response.status, "success")
end function

function TestCase__SendBeacon__InitiateCustomMessageStructure() as Object
  self = getGlobalAA()
  beaconId = "AppLaunchCustom"
  beaconType = "Initiate"

  response = self.top.callFunc("sendBeacon", beaconId, beaconType)
  regex = createObject("roRegex", "\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3} \[beacon\.signal\.custom\] \|[A-Za-z]+Initiate ---------> Timebase\(-?\d+ ms\)", "i")

  return m.assertTrue(regex.isMatch(response.message))
end function

sub TestCase__SendBeacon__CompleteCustomMessageStructure__Setup()
  self = getGlobalAA()
  beaconId = "AppLaunchCustom"
  beaconType = "Initiate"

  self.top.callFunc("sendBeacon", beaconId, beaconType)
end sub

function TestCase__SendBeacon__CompleteCustomMessageStructure() as Object
  self = getGlobalAA()
  beaconId = "AppLaunchCustom"
  beaconType = "Complete"

  response = self.top.callFunc("sendBeacon", beaconId, beaconType)
  regex = createObject("roRegex", "\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3} \[beacon\.signal\.custom\] \|[A-Za-z]+Complete ---------> Duration\(-?\d+ ms\)", "i")

  return m.assertTrue(regex.isMatch(response.message))
end function