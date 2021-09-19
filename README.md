# 🔮 PermissionWizard

[![CocoaPods](https://img.shields.io/badge/CocoaPods-supported-success)](https://cocoapods.org/pods/PermissionWizard)
![Carthage](https://img.shields.io/badge/Carthage-supported-success)

[Читать на русском](https://github.com/debug45/PermissionWizard/blob/master/README.ru.md)

It is an ultimate tool for system permissions management. No longer you have to understand system API of each new permission type or search it on the Stack Overflow. 😄

## Advantages

📱 Supports the newest features of **iOS 15** and **macOS 12 Monterey**
<br/>
🖥 Works great with **Mac Catalyst**

✋ Supports **all existing permission types**
<br/>
🛡 Provides crash free by **validating your plist** keys
<br/>
📬 Use **completion blocks** even where it is not provided by default system API
<br/>
🛣 Forget about **thread management** by using any preferred dispatch queue only (optional)

🚀 Completely written in **Swift**
<br/>
🍭 Unifies your code **regardless of permission types** you are working with
<br/>
🖼 Includes **native icons** and **localized strings** for your UI (optional)
<br/>
🍕 Modular, add to your project **only what you need**
<br/>
🪁 Does not contain anything redundant

## Supported Types

<img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Bluetooth@3x.png" width="29" height="29" title="Bluetooth"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Calendars@3x.png" width="29" height="29" title="Calendars"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Camera@3x.png" width="29" height="29" title="Camera"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Contacts@3x.png" width="29" height="29" title="Contacts"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/FaceID@3x.png" width="29" height="29" title="Face ID"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Health@3x.png" width="29" height="29" title="Health"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Home@3x.png" width="29" height="29" title="Home"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/LocalNetwork@3x.png" width="29" height="29" title="Local Network"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Location@3x.png" width="29" height="29" title="Location"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Microphone@3x.png" width="29" height="29" title="Microphone"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Motion@3x.png" width="29" height="29" title="Motion"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Music@3x.png" width="29" height="29" title="Music"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Notifications@3x.png" width="29" height="29" title="Notifications"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Photos@3x.png" width="29" height="29" title="Photos"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Reminders@3x.png" width="29" height="29" title="Reminders"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Siri@3x.png" width="29" height="29" title="Siri"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/SpeechRecognition@3x.png" width="29" height="29" title="Speech Recognition"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Tracking@3x.png" width="29" height="29" title="Tracking"/>

## Requirements

- iOS 10 / macOS 10.15 Catalina
- Xcode 12.2
- Swift 5

## Installation

### [CocoaPods](https://cocoapods.org)

To integrate **PermissionWizard** into your Xcode project, add it to your `Podfile`:

```ruby
pod 'PermissionWizard'
```

By default, the library will be installed fully.

Due to Apple’s policy regarding system permissions, your app may be rejected due to mention of API that is not actually used. It is recommended to install only components that you need. In this case **you will not have any troubles**. ⚠️

```ruby
pod 'PermissionWizard/Assets' # Icons and localized strings
pod 'PermissionWizard/Bluetooth'
pod 'PermissionWizard/Calendars'
pod 'PermissionWizard/Camera'
pod 'PermissionWizard/Contacts'
pod 'PermissionWizard/FaceID'
pod 'PermissionWizard/Health'
pod 'PermissionWizard/Home'
pod 'PermissionWizard/LocalNetwork'
pod 'PermissionWizard/Location'
pod 'PermissionWizard/Microphone'
pod 'PermissionWizard/Motion'
pod 'PermissionWizard/Music'
pod 'PermissionWizard/Notifications'
pod 'PermissionWizard/Photos'
pod 'PermissionWizard/Reminders'
pod 'PermissionWizard/Siri'
pod 'PermissionWizard/SpeechRecognition'
pod 'PermissionWizard/Tracking'
```

Do not specify `pod 'PermissionWizard'` if you install separate components.

### [Carthage](https://github.com/Carthage/Carthage)

To integrate **PermissionWizard** into your Xcode project, add it to your `Cartfile`:

```ogdl
github "debug45/PermissionWizard"
```

By default, the library is compiled fully when you build the project.

Due to Apple’s policy regarding system permissions, your app may be rejected due to mention of API that is not actually used. It is recommended to enable only components that you need. In this case **you will not have any troubles**. ⚠️

To enable only components that you need, create the `PermissionWizard.xcconfig` file in the root directory of your project. Put appropriate settings into the file according to the following template:

```
ENABLED_FEATURES = ASSETS BLUETOOTH CALENDARS CAMERA CONTACTS FACE_ID HEALTH HOME LOCAL_NETWORK LOCATION MICROPHONE MOTION MUSIC NOTIFICATIONS PHOTOS REMINDERS SIRI SPEECH_RECOGNITION TRACKING
SWIFT_ACTIVE_COMPILATION_CONDITIONS = $(inherited) $(ENABLED_FEATURES) CUSTOM_SETTINGS
```

Customize the first line of the template removing unnecessary component names.

## How to Use

Using of **PermissionWizard** is incredibly easy!

```swift
import PermissionWizard

Permission.contacts.checkStatus { status in
    status // .notDetermined
}

do {
    try Permission.location.requestAccess(whenInUseOnly: true) { status in
        status.value // .whenInUseOnly
        status.isAccuracyReducing // false
    }
    
    Permission.camera.checkStatus(withMicrophone: true) { status in
        status.camera // .granted
        status.microphone // .denied
    }
} catch let error {
    error.userInfo["message"] // You must add a row with the ”NSLocationWhenInUseUsageDescription“ key to your app‘s plist file and specify the reason why you are requesting access to location. This information will be displayed to a user.
    
    guard let error = error as? Permission.Error else {
        return
    }
    
    error.type // .missingPlistKey
}
```

Some permission types support additional features. For example, if an iOS 14 user allows access to his location only with reduced accuracy, you can request temporary access to full accuracy:

```swift
try? Permission.location.requestTemporaryPreciseAccess(purposePlistKey: "Default") { result in
    result // true
}
```

Unfortunately, the ability to work with certain permission types is limited by default system API. For example, you can check the current status of a home permission only by requesting it.

### Info.plist

For each permission type you are using, Apple requires to add the corresponding string to your `Info.plist` that describes a purpose of your access requests. **PermissionWizard** can help you to find the name of a necessary plist key:

```swift
Permission.faceID.usageDescriptionPlistKey // NSFaceIDUsageDescription

Permission.health.readingUsageDescriptionPlistKey // NSHealthUpdateUsageDescription
Permission.health.writingUsageDescriptionPlistKey // NSHealthShareUsageDescription
```

If you request access to some permission using default system API but forget to edit your `Info.plist`, the app will crash. However with **PermissionWizard** the crash will not occur — `try?` is just used.

### Thread Management

In some cases default system API may return a result in a different dispatch queue. To avoid a crash and instead of using `DispatchQueue.main.async`, you can ask **PermissionWizard** always to invoke completion blocks in a preferred queue:

```swift
Permission.preferredQueue = .main // Default setting
```

### UI Assets

If your UI needs permission type icons or localized names, you can easily get it using **PermissionWizard**:

```swift
let permission = Permission.speechRecognition.self

imageView.image = permission.getIcon(squircle: true)
label.text = permission.getLocalizedName() // Speech Recognition
```

Keep in mind that icons and localized strings are only available if the `Assets` component of **PermissionWizard** is installed (CocoaPods) or enabled (Carthage). All system languages are supported.

## Known Issues

- Bluetooth permission always returns `.granted` on simulators
- Local Network permission does not work on simulators
- Microphone permission always returns `.granted` on simulators with iOS 10 or 11
- Music permission does not work on simulators with iOS 12

## Roadmap

- Extend support of macOS (specific permission types, native icons)
- Make the library compatible with Swift Package Manager
- Support usage in SwiftUI code

## Conclusion

You can contact me on [Telegram](https://t.me/debug45) and [LinkedIn](https://linkedin.com/in/debug45). If you find an issue, please [tell](https://github.com/debug45/PermissionWizard/issues/new) about it.

Library is released under the MIT license. The permission type icons and localized strings belong to Apple, their use is regulated by the company rules.

If **PermissionWizard** is useful for you please star this repository. Thank you! 👍