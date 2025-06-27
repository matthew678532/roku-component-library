sub init()
  m.top.backgroundUri = ""
  m.top.backgroundColor = "#000000"

  m.channelPerformanceComponent = m.top.findNode("channelPerformanceComponent")
  print "[MainScene][ChannelPerformanceComponent] beaconIds: " m.channelPerformanceComponent.beaconIds
  print "[MainScene][ChannelPerformanceComponent] beaconTypes: " m.channelPerformanceComponent.beaconTypes

  ' 1) Sending required appLaunch complete beacon (the intiate for this beacon is handled by the OS - we only need to send the complete, appLaunch is the only beacon that can do this)
  sendChannelPerformanceBeacon(m.channelPerformanceComponent.beaconIds.appLaunch, m.channelPerformanceComponent.beaconTypes.complete)

  ' 2) Sending our custom appLaunchCustom initiate beacon (bad example, but shows how to send custom beacons)
  sendChannelPerformanceBeacon(m.channelPerformanceComponent.beaconIds.appLaunchCustom, m.channelPerformanceComponent.beaconTypes.initiate)
  startTimer(2)
end sub

sub startTimer(duration as Integer)
  m.timer = createObject("roSGNode", "Timer")
  m.timer.duration = duration
  m.timer.observeField("fire", "onTimer")
  m.timer.control = "start"
end sub

sub onTimer()
  m.timer.unobserveField("fire")
  m.timer = Invalid

  ' 3) Sending our custom appLaunchCustom complete beacon
  sendChannelPerformanceBeacon(m.channelPerformanceComponent.beaconIds.appLaunchCustom, m.channelPerformanceComponent.beaconTypes.complete)
end sub

function getChannelPerformanceBeaconIds() as Object
  return m.channelPerformanceComponent.beaconIds
end function

function getChannelPerformanceBeaconTypes() as Object
  return m.channelPerformanceComponent.beaconTypes
end function

sub sendChannelPerformanceBeacon(beaconId as String, beaconType as String)
  m.channelPerformanceComponent.callFunc("sendBeacon", beaconId, beaconType)
end sub