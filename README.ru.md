# 🔮 PermissionWizard

[![CocoaPods](https://img.shields.io/badge/CocoaPods-supported-success)](https://cocoapods.org/pods/PermissionWizard)
![Carthage](https://img.shields.io/badge/Carthage-supported-success)

[Read in English](https://github.com/debug45/PermissionWizard/blob/master/README.md)

Это универсальный инструмент для работы с системными разрешениями на доступ к чему-либо, самый удобный способ запросить у пользователя пермишен или проверить его текущий статус. Больше не нужно тратить время на изучение системного API для каждого нового типа разрешения или искать готовые реализации на Stack Overflow. 😄

## Преимущества

📱 Поддерживает новейшие фичи **iOS 16** и **macOS 13 Ventura**
<br/>
🖥 Отлично работает с **Mac Catalyst**

✋ Поддерживает **все существующие типы пермишенов**
<br/>
🛡 Защищает от падений, **валидируя ваш plist-файл**
<br/>
📬 Используйте **async/await** и **completion-блоки** даже там, где это не предусмотрено дефолтным системным API
<br/>
🛣 Забудьте об **управлении потоками**, всегда используя одну любую dispatch-очередь (опционально)

🚀 Библиотека написана на чистом **Swift**
<br/>
🍭 Унифицирует ваш код, **независимо от типов пермишенов**, с которыми вы работаете
<br/>
🖼 Включает **нативные иконки** и **локализованные строки** для вашего UI (опционально)
<br/>
🍕 Модульность, добавляйте в свой проект **лишь то, что вам нужно**
<br/>
🪁 Не содержит ничего лишнего

## Поддерживаемые типы

<img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Bluetooth@3x.png" width="29" height="29" title="Bluetooth"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Calendars@3x.png" width="29" height="29" title="Календари"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Camera@3x.png" width="29" height="29" title="Камера"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Contacts@3x.png" width="29" height="29" title="Контакты"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/FaceID@3x.png" width="29" height="29" title="Face ID"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Health@3x.png" width="29" height="29" title="Здоровье"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Home@3x.png" width="29" height="29" title="Дом"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/LocalNetwork@3x.png" width="29" height="29" title="Локальная сеть"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Location@3x.png" width="29" height="29" title="Геолокация"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Microphone@3x.png" width="29" height="29" title="Микрофон"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Motion@3x.png" width="29" height="29" title="Движение"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Music@3x.png" width="29" height="29" title="Музыка"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Notifications@3x.png" width="29" height="29" title="Уведомления"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Photos@3x.png" width="29" height="29" title="Фото"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Reminders@3x.png" width="29" height="29" title="Напоминания"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Siri@3x.png" width="29" height="29" title="Siri"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/SpeechRecognition@3x.png" width="29" height="29" title="Распознавание речи"/> <img src="https://github.com/debug45/PermissionWizard/raw/master/Documentation/Tracking@3x.png" width="29" height="29" title="Отслеживание"/>

## Требования

- iOS 12 / macOS 10.15 Catalina
- Xcode 14
- Swift 5.5

## Установка

### [CocoaPods](https://cocoapods.org)

Чтобы подключить **PermissionWizard** к вашему Xcode-проекту, добавьте это в `Podfile`:

```ruby
pod 'PermissionWizard'
```

По умолчанию библиотека устанавливается целиком.

В силу политики Apple относительно системных пермишенов модераторы могут отклонить ваше приложение из-за присутствующих в коде ссылок на API, которое вы на самом деле не используете. По этой причине рекомендуется устанавливать лишь нужные вам компоненты — в таком случае не возникнет **никаких проблем**. ⚠️

```ruby
pod 'PermissionWizard/Assets' # Иконки и локализованные строки
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

Не добавляйте строку `pod 'PermissionWizard'`, если устанавливаете компоненты выборочно.

### [Carthage](https://github.com/Carthage/Carthage)

Для интеграции **PermissionWizard** в ваш Xcode-проект добавьте это в `Cartfile`:

```ogdl
github "debug45/PermissionWizard"
```

По умолчанию при сборке вашего проекта библиотека будет компилироваться целиком.

В силу политики Apple относительно системных пермишенов модераторы могут отклонить ваше приложение из-за присутствующих в коде ссылок на API, которое вы на самом деле не используете. По этой причине рекомендуется включать лишь нужные вам компоненты — в таком случае не возникнет **никаких проблем**. ⚠️

Чтобы включить только те компоненты, что вам нужны, создайте файл `PermissionWizard.xcconfig` в корневой папке вашего проекта и укажите в нём подходящие настройки по следующему шаблону:

```
ENABLED_FEATURES = ASSETS BLUETOOTH CALENDARS CAMERA CONTACTS FACE_ID HEALTH HOME LOCAL_NETWORK LOCATION MICROPHONE MOTION MUSIC NOTIFICATIONS PHOTOS REMINDERS SIRI SPEECH_RECOGNITION TRACKING
SWIFT_ACTIVE_COMPILATION_CONDITIONS = $(inherited) $(ENABLED_FEATURES) CUSTOM_SETTINGS
```

Измените первую строку шаблона, удалив из неё названия ненужных компонентов.

## Как использовать

Использовать **PermissionWizard** проще некуда!

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
    error.userInfo["message"] // You must add a row with the “NSLocationWhenInUseUsageDescription” key to your app‘s plist file and specify the reason why you are requesting access to location. This information will be displayed to a user.
    
    guard let error = error as? Permission.Error else {
        return
    }
    
    error.type // .missingPlistKey
}
```

Для некоторых типов пермишенов реализованы дополнительные фичи. Например, если на iOS 14 пользователь разрешил доступ ко своей геолокации только со сниженной точностью, вы можете запросить временный доступ без ограничений:

```swift
try? Permission.location.requestTemporaryPreciseAccess(purposePlistKey: "Default") { result in
    result // true
}
```

К сожалению, возможности по работе с некоторыми пермишенами ограничены дефолтным системным API. Например, вы не можете проверить статус доступа к «Дому», не запросив при этом разрешение на него.

### Info.plist

Для каждого пермишена, с которым вы работаете, Apple требует добавлять соответствующие строки в ваш `Info.plist` и описывать там причины, по которым у пользователей запрашиваются доступы. **PermissionWizard** поможет найти названия требуемых plist-ключей:

```swift
Permission.faceID.usageDescriptionPlistKey // NSFaceIDUsageDescription

Permission.health.readingUsageDescriptionPlistKey // NSHealthUpdateUsageDescription
Permission.health.writingUsageDescriptionPlistKey // NSHealthShareUsageDescription
```

Если вы запросите доступ к тому или иному пермишену, используя дефолтное системное API и забыв отредактировать свой `Info.plist`, приложение упадёт. Однако с **PermissionWizard** такого не будет — просто используйте `try`.

### Управление потоками

В некоторых случаях дефолтное системное API может ответить на запрос не в той dispatch-очереди, из которой вы к нему обратились. Чтобы защититься от потенциальных падений и не писать всюду `DispatchQueue.main.async`, вы можете попросить **PermissionWizard** всегда вызывать completion-блоки в удобной вам очереди:

```swift
Permission.preferredQueue = .main // Настройка по умолчанию
Permission.preferredQueue = nil // Управление потоками отключено
```

### UI-ресурсы

Если для вашего интерфейса нужны иконки или локализованные названия пермишенов, вы легко можете получить их, используя **PermissionWizard**:

```swift
let permission = Permission.speechRecognition.self

imageView.image = permission.getIcon(squircle: true)
label.text = permission.getLocalizedName() // Распознавание речи
```

Помните, что иконки и локализованные строки доступны, только если установлен (CocoaPods) или включён (Carthage) компонент `Assets`. Поддерживаются все системные языки.

## Известные проблемы

- Bluetooth-пермишен всегда возвращает `.granted` на симуляторах
- На симуляторах не функционирует работа с доступом к локальной сети
- Пермишен музыки не работает на симуляторах с iOS 12

## Дальнейшие планы

- Расширить поддержку macOS (специфичные типы пермишенов, нативные иконки)
- Сделать библиотеку доступной к установке через Swift Package Manager
- Поддержать использование в SwiftUI-коде

## Заключение

Вы можете связаться со мной в [Telegram](https://t.me/debug45) и на [LinkedIn](https://linkedin.com/in/debug45). Если обнаружили проблему, пожалуйста, [сообщите](https://github.com/debug45/PermissionWizard/issues/new) о ней.

Библиотека распространяется по лицензии MIT. Иконки и локализованные строки пермишенов принадлежат Apple, их использование регулируется правилами компании.

Если вам понравился **PermissionWizard**, пожалуйста, поставьте звёздочку этому репозиторию. Спасибо! 👍