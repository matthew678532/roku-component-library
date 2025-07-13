# ChannelPerformanceComponent

Component to manage the signaling of beacons (https://developer.roku.com/en-gb/docs/developer-program/performance-guide/measuring-channel-performance.md), to achieve the following: 1) Sending required beacons to pass certification, e.g. AppLaunch, AppDialog, etc, and 2) Allowing for the extension of custom beacons to be triggered to assess the general health of a channel (for example screen to screen transitions).

## How To

The component has been designed to be accessed through the scene node(s), so that from any component you can trigger beacons.

To signal a beacon with the `ChannelPerformanceComponent` we can run the following code:

```
channelPerformanceComponent = m.top.findNode("ChannelPerformanceComponent")
beaconIds = channelPerformanceComponent.beaconIds
beaconTypes = channelPerformanceComponent.beaconTypes

channelPerformanceComponent.callFunc("sendBeacon", beaconIds.appLaunch, beaconTypes.complete)
```

You may wish to expose abbreviated functions on the scene node to help child components call through the `ChannelPerformanceComponent` (see `MainScene` inside `/App` for an example).

The beaconIds contain the ids exported by the component that we wish to track. Currently this is the "required for certification" ids: "AppLaunch", "AppDialog" and "EpgLaunch", and an example custom id "AppLaunchCustom" which we reference inside our test cases.

The beaconTypes contain the types exported by the component which are: "Initiate" and "Complete", detailing the type of beacon (when the event takes place).

We then proceed to call `sendBeacon` which will either:

- Not send our beacon if:
  - We try to send an unaccounted for beacon id.
  - We try to send an unaccounted for beacon type.
  - We try to send a complete before an initiate (with the exception of the "AppLaunch" id as the initiate is triggered by the OS).
- Send our beacon if it's required for certification via the `signalBeacon` call.
- Send our beacon if it's not required for certification (custom) to the terminal mimicking the output structure of a required beacon (you'll be able to tell the difference due to the presence of the `custom` keyword in the output).

## Possible Improvements

- Adding logic for the memory points if possible.

## Version

2.0.0

## Changelog

1.0.0

- Initial release
- Covers triggering of required beacons, and basic tests

2.0.0

- Fixes for existing performance tracking
- Improvements to test cases and coverage
- Added an enablement flag for custom beacons
- Fixed timebase output to align with required metrics