sub init()
  m.msSinceAppLaunchInitiateBeacon = createObject("roDateTime").toSeconds() * 1000
  m.scene = m.top.getParent()

  m.beaconIds = {
    epgLaunch: "EpgLaunch",
    appDialog: "AppDialog",
    appLaunch: "AppLaunch"
  }
  m.beaconTypes = {
    initiate: "Initiate",
    complete: "Complete"
  }
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

  m.beacons = {}
  m.beacons.append(m.requiredBeacons)
  m.beacons.append(m.customBeacons)
end sub

sub sendBeacon(beaconId as String, beaconType as String)
  beacon = m.beacons[beaconId]

  if beacon = Invalid
    print "Unsupported beacon, not sending"

    return
  end if

  beaconByType = beacon[beaconType]

  if beaconByType = Invalid
    print "Unknown beacon by type, not sending"

    return
  end if

  completeBeacon = beaconType = m.beaconTypes.complete
  noInitiate = beacon.initiate.timebase = Invalid
  appLaunchBeacon = beaconId = m.beaconIds.appLaunch

  if completeBeacon and noInitiate and not appLaunchBeacon
    print "Attempting to send complete beacon without initiate, not sending"

    return
  end if

  beaconDateTime = createObject("roDateTime")
  requiredBeacon = m.requiredBeacons[beaconId]

  if beaconType = m.beaconTypes.initiate
    timebase = (beaconDateTime.toSeconds() * 1000) - m.msSinceAppLaunchInitiateBeacon
    m.beacons[beaconId][beaconType].timebase = timebase

    if requiredBeacon <> Invalid
      m.scene.signalBeacon(beaconId + beaconType)

      return
    end if

    initiateString = "Timebase({timebase} ms)"

    print getBaseBeaconString() + initiateString.replace("{timebase}", timebase.toStr())
  else
    timebase = beacon.initiate.timebase
    duration = (beaconDateTime.toSeconds() * 1000) - timebase
    m.beacons[beaconId][beaconType].duration = duration

    if requiredBeacon <> Invalid
      m.scene.signalBeacon(beaconId + beaconType)
      resetBeacon(beaconId)

      return
    end if

    completeString = "Duration({duration} ms)"

    print getBaseBeaconString() + completeString.replace("{duration}", duration.toStr())

    resetBeacon(beaconId)
  end if
end sub

function getBaseBeaconString(beaconDateTime as String, beaconId as String, beaconType as String) as String
  baseBeaconString = "{day}-{month} {hour}:{minute}:{second}.{millisecond} [beacon.signal.custom] |{beaconId}{beaconType} ---------> "

  day = padTimeUnit(beaconDateTime.getDayOfMonth())
  month = padTimeUnit(beaconDateTime.getMonth())

  hour = padTimeUnit(beaconDateTime.getHours())
  minute = padTimeUnit(beaconDateTime.getMinutes())
  second = padTimeUnit(beaconDateTime.getSeconds())
  millisecond = padTimeUnit(beaconDateTime.getMilliseconds())

  return baseBeaconString.replace("{day}", day).replace("{month}", month).replace("{hour}", hour).replace("{minute}", minute).replace("{second}", second).replace("{millisecond}", millisecond).replace("{beaconId}", beaconId).replace("{beaconType}", beaconType)
end function

function padTimeUnit(timeUnit as Int) as String
  if timeUnit < 10
    return "0" + timeUnit.toStr()
  end if

  return timeUnit.toStr()
end function

sub resetBeacon(beaconId as String)
  m.beacons[beaconId].initiate.timebase = Invalid
  m.beacons[beaconId].complete.duration = Invalid
end sub