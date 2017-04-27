# SKLogDebugger
Saikyo log debugger.

## Installation

SKLogDebugger is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SKLogDebugger'
```

## Example

Import this Library.
```swift
import SKLogDebugger
```

Add log data.
```swift
// Sample 1
SKLogDebugger.shared.addLog(
  action: "action_1",
  data: [:]
)

// Sample 2
SKLogDebugger.shared.addLog(
  action: "action_2",
  data: [
    "data1": 123,
    "data2": "aaa",
    "data3": true
  ]
)

// Sample 3
SKLogDebugger.shared.addLog(
  action: "action_3",
  data: [
    "data1": [1, 2, 3, "a", "b", "c"],
    "data2": [
      "data21": -123,
      "data22": "bbb",
      "data23": false
    ],
    "data3": [
      "data31": [
        "data311": "999"
       ]
    ]
  ]
)
```

Open setting view.
```swift
SKLogDebugger.shared.openSettingView()
```

Set omit actions.
```swift
SKLogDebugger.shared.setOmitActions(["action_2", "action_3"])
```

## Requirements

Swift3

RxSwift, RxCocoa, SwiftyJSON, SwiftyAttributes

## Author

aikizoku, yuki@thehero.jp

## License

SKLogDebugger is available under the MIT license. See the LICENSE file for more info.
