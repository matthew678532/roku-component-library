# ChannelPerformanceComponent

Component to manage the signaling of beacons (https://developer.roku.com/en-gb/docs/developer-program/performance-guide/measuring-channel-performance.md), to achieve the following: 1) Sending required beacons for certification, e.g. AppLaunch, AppDialog, etc, and 2) Allowing for the extension of further beacons to be triggered satisfying Roku certification requirements, but also allowing for further metrics capture to assess the general health of a channel (screen to screen transitions).

## How To

The component is intended to sit on the scene node(s), and called through the scene which can be made accessible throughout the application.

To signal a beacon through the `ChannelPerformanceComponent` we can run the following code:

```
channelPerformanceComponent = m.top.findNode("ChannelPerformanceComponent") ' Where top refers to the scene
beaconIds = channelPerformanceComponent.beaconIds
beaconTypes = channelPerformanceComponent.beaconTypes

channelPerformanceComponent.callFunc("sendBeacon", beaconIds.appLaunch, beaconTypes.complete)
```

The beaconIds contain the ids exported by the component that we wish to track. Currently this is only the "required for certification" ids: "AppLaunch", "AppDialog" and "EpgLaunch".

The beaconTypes contain the types exported by the component which are: "Initiate" and "Complete" which details the type of beacon i.e. on start of an action, or on complete of an action.

We then proceed to call `sendBeacon` which will either:

- Not send our beacon if:
  - We try to send an unaccounted for beacon id.
  - We try to send an unaccounted for beacon type.
  - We try to send a complete before an initiate (unless it's an "AppLaunch" id in which case this is ok, as the initiate is triggered automatically by the channel).
- Send our beacon if it's required for certification via the `signalBeacon` call.
- Send our beacon if it's not required for certification (custom) to the terminal mimicking the output structure of a required beacon.

## Possible Improvements

- Test case improvements to account for the various logic flows (potentially moving to a different framework).
- Adding logic for the memory points where possible.

## Version

1.0.0

## Changelog

1.0.0

- Initial release
- Covers triggering of required beacons, and basic tests