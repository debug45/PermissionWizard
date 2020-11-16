Pod::Spec.new do |spec|
  
  spec.name = 'PermissionWizard'
  spec.version = '1.0'
  
  spec.summary = '🔮 An ultimate tool for system permissions management'
  
  spec.author = { 'Sergey Moskvin' => 'debug45@mail.ru' }
  spec.license = { :type => 'MIT', :file => 'LICENSE.md' }
  
  spec.homepage = 'https://github.com/debug45/PermissionWizard'
  spec.source = { :git => 'https://github.com/debug45/PermissionWizard.git', :tag => spec.version.to_s }
  
  spec.ios.deployment_target = '10.0'
  spec.swift_version = '5.0'
  
  spec.subspec 'Core' do |core|
    core.source_files = 'Source/Permission*.swift', 'Source/Framework/*.swift'
  end
  
  spec.subspec 'Icons' do |icons|
    icons.dependency 'PermissionWizard/Core'
    icons.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'ICONS CUSTOM_SETTINGS' }
    icons.resource_bundle = { 'Icons' => 'Source/Assets.xcassets' }
  end
  
  spec.subspec 'Bluetooth' do |bluetooth|
    bluetooth.dependency 'PermissionWizard/Core'
    bluetooth.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'BLUETOOTH CUSTOM_SETTINGS' }
    bluetooth.source_files = 'Source/Bluetooth*.swift'
  end
  
  spec.subspec 'Calendars' do |calendars|
    calendars.dependency 'PermissionWizard/Core'
    calendars.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'CALENDARS CUSTOM_SETTINGS' }
    calendars.source_files = 'Source/Calendars*.swift'
  end
  
  spec.subspec 'Camera' do |camera|
    camera.dependency 'PermissionWizard/Core'
    camera.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'CAMERA CUSTOM_SETTINGS' }
    camera.source_files = 'Source/Camera*.swift'
  end
  
  spec.subspec 'Contacts' do |contacts|
    contacts.dependency 'PermissionWizard/Core'
    contacts.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'CONTACTS CUSTOM_SETTINGS' }
    contacts.source_files = 'Source/Contacts*.swift'
  end
  
  spec.subspec 'FaceID' do |face_id|
    face_id.dependency 'PermissionWizard/Core'
    face_id.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'FACE_ID CUSTOM_SETTINGS' }
    face_id.source_files = 'Source/FaceID*.swift'
  end
  
  spec.subspec 'Health' do |health|
    health.dependency 'PermissionWizard/Core'
    health.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'HEALTH CUSTOM_SETTINGS' }
    health.source_files = 'Source/Health*.swift'
  end
  
  spec.subspec 'Home' do |home|
    home.dependency 'PermissionWizard/Core'
    home.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'HOME CUSTOM_SETTINGS' }
    home.source_files = 'Source/Home*.swift'
  end
  
  spec.subspec 'LocalNetwork' do |local_network|
    local_network.dependency 'PermissionWizard/Core'
    local_network.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'LOCAL_NETWORK CUSTOM_SETTINGS' }
    local_network.source_files = 'Source/LocalNetwork*.swift'
  end
  
  spec.subspec 'Location' do |location|
    location.dependency 'PermissionWizard/Core'
    location.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'LOCATION CUSTOM_SETTINGS' }
    location.source_files = 'Source/Location*.swift'
  end
  
  spec.subspec 'Microphone' do |microphone|
    microphone.dependency 'PermissionWizard/Core'
    microphone.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'MICROPHONE CUSTOM_SETTINGS' }
    microphone.source_files = 'Source/Microphone*.swift'
  end
  
  spec.subspec 'Motion' do |motion|
    motion.dependency 'PermissionWizard/Core'
    motion.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'MOTION CUSTOM_SETTINGS' }
    motion.source_files = 'Source/Motion*.swift'
  end
  
  spec.subspec 'Music' do |music|
    music.dependency 'PermissionWizard/Core'
    music.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'MUSIC CUSTOM_SETTINGS' }
    music.source_files = 'Source/Music*.swift'
  end
  
  spec.subspec 'Notifications' do |notifications|
    notifications.dependency 'PermissionWizard/Core'
    notifications.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'NOTIFICATIONS CUSTOM_SETTINGS' }
    notifications.source_files = 'Source/Notifications*.swift'
  end
  
  spec.subspec 'Photos' do |photos|
    photos.dependency 'PermissionWizard/Core'
    photos.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'PHOTOS CUSTOM_SETTINGS' }
    photos.source_files = 'Source/Photos*.swift'
  end
  
  spec.subspec 'Reminders' do |reminders|
    reminders.dependency 'PermissionWizard/Core'
    reminders.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'REMINDERS CUSTOM_SETTINGS' }
    reminders.source_files = 'Source/Reminders*.swift'
  end
  
  spec.subspec 'SpeechRecognition' do |speech_recognition|
    speech_recognition.dependency 'PermissionWizard/Core'
    speech_recognition.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'SPEECH_RECOGNITION CUSTOM_SETTINGS' }
    speech_recognition.source_files = 'Source/SpeechRecognition*.swift'
  end
  
  spec.default_subspec = 'Icons', 'Bluetooth', 'Calendars', 'Camera', 'Contacts', 'FaceID', 'Health', 'Home', 'LocalNetwork', 'Location', 'Microphone', 'Motion', 'Music', 'Notifications', 'Photos', 'Reminders', 'SpeechRecognition'
  
end
