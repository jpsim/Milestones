# Milestones

An app to count down the days until upcoming milestones. We all have something to look forward to.

Built to try out the [Swift Composable Architecture][tca], [SwiftUI][swiftui] and [Combine][combine].

| List | Context Menu | Edit | Calendar |
| ---- | ------------ | ---- | -------- |
|![](images/iphone-1.png)|![](images/iphone-2.png)|![](images/iphone-3.png)|![](images/iphone-4.png)|

![](images/mac.png)

## Building & Running

Tested with Xcode 11.5. Requires iOS 13.0 or later.

## Known Issues

Unfortunately SwiftUI is still buggy as of iOS 13.5. Here are some of the issues impacting this app
that I'm aware of:

1. [FB7736428][FB7736428]: Navigation bar buttons are sometimes unresponsive after dismissing the edit modal.
2. [FB7740178][FB7740178]: Baseline in the edit modal `TextField` is off when using an emoji as the first character. **[Fixed in iOS 14 Beta 3][FB7740178-fix]**
3. Delete animation in List view is janky.
4. No way to programmatically make `TextField` the first responder without resorting to `UITextField` (mitigated).

## Credits

The videos and library from [Point Free][point-free]. Highly recommend both.

The [RKCalendar][rkcalendar] project, which I used and incrementally modified for the calendar functionality.

The [SwiftUI-Introspect][introspect] library to fix bugs or address limitations in SwiftUI.

## License

MIT.

[tca]: https://github.com/pointfreeco/swift-composable-architecture
[swiftui]: https://developer.apple.com/xcode/swiftui/
[combine]: https://developer.apple.com/documentation/combine
[FB7736428]: https://gist.github.com/jpsim/9bea8715291850e0bc3c6042eee10db5
[FB7740178]: https://gist.github.com/jpsim/7520685ab9ab459131624de30114581c
[FB7740178-fix]: https://twitter.com/simjp/status/1286464001409458177
[point-free]: https://www.pointfree.co
[rkcalendar]: https://github.com/RaffiKian/RKCalendar
[introspect]: https://github.com/siteline/SwiftUI-Introspect
