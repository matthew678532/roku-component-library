sub init()
  m.channelPerformanceComponent = m.top.findNode("channelPerformanceComponent")
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