sub init()
  m.msSinceAppLaunchInitiate = createObject("roDateTime").asSeconds() * 1000
  m.scene = m.top.getScene()

  m.beaconIds = {
    epgLaunch: "EpgLaunch",
    appDialog: "AppDialog",
    appLaunch: "AppLaunch",
    appLaunchCustom: "AppLaunchCustom"
  }
  m.top.beaconIds = m.beaconIds
  m.beaconTypes = {
    initiate: "Initiate",
    complete: "Complete"
  }
  m.top.beaconTypes = m.beaconTypes
  m.baseBeaconFormat = {
    initiate: {
      timebase: Invalid
    },
    complete: {
      duration: Invalid
    }
  }

  m.requiredBeacons = {}
  m.requiredBeacons[m.beaconIds.epgLaunch] = m.baseBeaconFormat
  m.requiredBeacons[m.beaconIds.appDialog] = m.baseBeaconFormat
  m.requiredBeacons[m.beaconIds.appLaunch] = m.baseBeaconFormat

  m.customBeacons = {}
  m.customBeacons[m.beaconIds.appLaunchCustom] = m.baseBeaconFormat

  m.beacons = {}
  m.beacons.append(m.requiredBeacons)
  m.beacons.append(m.customBeacons)
end sub

function sendBeacon(beaconId as String, beaconType as String) as Object
  beacon = m.beacons[beaconId]

  if beacon = Invalid
    print "[ChannelPerformanceComponent] Unsupported beacon (" + beaconId + "), not sending"

    return getSendBeaconResponseObject("error", "Unsupported beacon", { beaconId: beaconId, beaconType: beaconType })
  end if

  beaconByType = beacon[beaconType]

  if beaconByType = Invalid
    print "[ChannelPerformanceComponent] Unknown beacon by type (" + beaconId + ", " + beaconType + "), not sending"

    return getSendBeaconResponseObject("error", "Unknown beacon by type", { beaconId: beaconId, beaconType: beaconType })
  end if

  completeBeacon = beaconType = m.beaconTypes.complete
  noInitiate = beacon.initiate.timebase = Invalid
  appLaunchBeacon = beaconId = m.beaconIds.appLaunch

  if completeBeacon and noInitiate and not appLaunchBeacon
    print "[ChannelPerformanceComponent] Attempting to send complete beacon (" + beaconId + ") without initiate, not sending"

    return getSendBeaconResponseObject("error", "Attempting to send complete beacon without initiate", { beaconId: beaconId, beaconType: beaconType })
  end if

  beaconDateTime = createObject("roDateTime")
  requiredBeacon = m.requiredBeacons[beaconId]

  if beaconType = m.beaconTypes.initiate
    timebase = beaconDateTime.asSeconds() * 1000
    m.beacons[beaconId][beaconType].timebase = timebase

    if requiredBeacon <> Invalid
      m.scene.signalBeacon(beaconId + beaconType)

      return getSendBeaconResponseObject("success", "Beacon sent by OS", { beaconId: beaconId, beaconType: beaconType })
    end if

    if not m.top.customBeaconsEnabled
      print "[ChannelPerformanceComponent] Custom beacons are disabled, not sending custom beacon (" + beaconId + beaconType + ")"

      return getSendBeaconResponseObject("error", "Custom beacons are disabled", { beaconId: beaconId, beaconType: beaconType })
    end if

    initiateString = "Timebase({timebase} ms)"

    returnString = getBaseBeaconString(beaconDateTime, beaconId, beaconType) + initiateString.replace("{timebase}", (timebase - m.msSinceAppLaunchInitiate).toStr())
    print returnString
    return getSendBeaconResponseObject("success", returnString, { beaconId: beaconId, beaconType: beaconType })
  else
    timebase = beacon.initiate.timebase
    if timebase = Invalid
      timebase = beaconDateTime.asSeconds() * 1000
    end if
    duration = (beaconDateTime.asSeconds() * 1000) - timebase
    m.beacons[beaconId][beaconType].duration = duration

    if requiredBeacon <> Invalid
      m.scene.signalBeacon(beaconId + beaconType)
      resetBeacon(beaconId)

      return getSendBeaconResponseObject("success", "Beacon sent by OS", { beaconId: beaconId, beaconType: beaconType })
    end if

    if not m.top.customBeaconsEnabled
      print "[ChannelPerformanceComponent] Custom beacons are disabled, not sending custom beacon (" + beaconId + beaconType + ")"

      return getSendBeaconResponseObject("error", "Custom beacons are disabled", { beaconId: beaconId, beaconType: beaconType })
    end if

    completeString = "Duration({duration} ms)"

    returnString = getBaseBeaconString(beaconDateTime, beaconId, beaconType) + completeString.replace("{duration}", duration.toStr())
    print returnString

    resetBeacon(beaconId)
    return getSendBeaconResponseObject("success", returnString, { beaconId: beaconId, beaconType: beaconType })
  end if
end function

function getBaseBeaconString(beaconDateTime as Object, beaconId as String, beaconType as String) as String
  baseBeaconString = "{month}-{day} {hour}:{minute}:{second}.{millisecond} [beacon.signal.custom] |{beaconId}{beaconType} ---------> "

  month = padTimeUnit(beaconDateTime.getMonth())
  day = padTimeUnit(beaconDateTime.getDayOfMonth())

  hour = padTimeUnit(beaconDateTime.getHours())
  minute = padTimeUnit(beaconDateTime.getMinutes())
  second = padTimeUnit(beaconDateTime.getSeconds())
  millisecond = padTimeUnit(beaconDateTime.getMilliseconds())

  return baseBeaconString.replace("{day}", day).replace("{month}", month).replace("{hour}", hour).replace("{minute}", minute).replace("{second}", second).replace("{millisecond}", millisecond).replace("{beaconId}", beaconId).replace("{beaconType}", beaconType)
end function

function padTimeUnit(timeUnit as Integer) as String
  if timeUnit < 10
    return "0" + timeUnit.toStr()
  end if

  return timeUnit.toStr()
end function

sub resetBeacon(beaconId as String)
  m.beacons[beaconId].initiate.timebase = Invalid
  m.beacons[beaconId].complete.duration = Invalid
end sub

function getSendBeaconResponseObject(status as String, message as String, args as Object) as Object
  statuses = {
    "error": "error",
    "success": "success"
  }
  finalStatus = statuses[status]
  if finalStatus = Invalid
    finalStatus = "error"
  end if

  return {
    "status": finalStatus,
    "message": message,
    "args": args
  }
end function