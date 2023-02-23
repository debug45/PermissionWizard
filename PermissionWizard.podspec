Pod::Spec.new do |spec|
  
  spec.name = 'PermissionWizard'
  spec.version = '1.3.0'
  
  spec.summary = '🔮 An ultimate tool for system permissions management'
  
  spec.author = { 'Sergei Moskvin' => 's@mosk.vin' }
  spec.license = { :type => 'MIT', :file => 'LICENSE.md' }
  
  spec.homepage = 'https://github.com/debug45/PermissionWizard'
  spec.source = { :git => 'https://github.com/debug45/PermissionWizard.git', :tag => spec.version.to_s }
  
  spec.ios.deployment_target = '12.0'
  spec.swift_version = '5.5'
  
  spec.subspec 'Core' do |core|
    core.source_files = 'Source/Permission.swift', 'Source/Framework'
  end
  
  spec.subspec 'Assets' do |assets|
    assets.dependency 'PermissionWizard/Core'
    assets.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'ASSETS CUSTOM_SETTINGS' }
    
    assets.resource_bundles = {
      'Icons' => 'Source/Icons.xcassets',
      'Localizations' => 'Source/Localizations/*.lproj'
    }
  end
  
  spec.subspec 'Bluetooth' do |bluetooth|
    bluetooth.dependency 'PermissionWizard/Core'
    bluetooth.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'BLUETOOTH CUSTOM_SETTINGS' }
    bluetooth.source_files = 'Source/Supported Types/Bluetooth*.swift'
  end
  
  spec.subspec 'Calendars' do |calendars|
    calendars.dependency 'PermissionWizard/Core'
    calendars.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'CALENDARS CUSTOM_SETTINGS' }
    calendars.source_files = 'Source/Supported Types/Calendars*.swift'
  end
  
  spec.subspec 'Camera' do |camera|
    camera.dependency 'PermissionWizard/Core'
    camera.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'CAMERA CUSTOM_SETTINGS' }
    camera.source_files = 'Source/Supported Types/Camera*.swift'
  end
  
  spec.subspec 'Contacts' do |contacts|
    contacts.dependency 'PermissionWizard/Core'
    contacts.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'CONTACTS CUSTOM_SETTINGS' }
    contacts.source_files = 'Source/Supported Types/Contacts*.swift'
  end
  
  spec.subspec 'FaceID' do |face_id|
    face_id.dependency 'PermissionWizard/Core'
    face_id.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'FACE_ID CUSTOM_SETTINGS' }
    face_id.source_files = 'Source/Supported Types/FaceID*.swift'
  end
  
  spec.subspec 'Health' do |health|
    health.dependency 'PermissionWizard/Core'
    health.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'HEALTH CUSTOM_SETTINGS' }
    health.source_files = 'Source/Supported Types/Health*.swift'
  end
  
  spec.subspec 'Home' do |home|
    home.dependency 'PermissionWizard/Core'
    home.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'HOME CUSTOM_SETTINGS' }
    home.source_files = 'Source/Supported Types/Home*.swift'
  end
  
  spec.subspec 'LocalNetwork' do |local_network|
    local_network.dependency 'PermissionWizard/Core'
    local_network.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'LOCAL_NETWORK CUSTOM_SETTINGS' }
    local_network.source_files = 'Source/Supported Types/LocalNetwork*.swift'
  end
  
  spec.subspec 'Location' do |location|
    location.dependency 'PermissionWizard/Core'
    location.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'LOCATION CUSTOM_SETTINGS' }
    location.source_files = 'Source/Supported Types/Location*.swift'
  end
  
  spec.subspec 'Microphone' do |microphone|
    microphone.dependency 'PermissionWizard/Core'
    microphone.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'MICROPHONE CUSTOM_SETTINGS' }
    microphone.source_files = 'Source/Supported Types/Microphone*.swift'
  end
  
  spec.subspec 'Motion' do |motion|
    motion.dependency 'PermissionWizard/Core'
    motion.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'MOTION CUSTOM_SETTINGS' }
    motion.source_files = 'Source/Supported Types/Motion*.swift'
  end
  
  spec.subspec 'Music' do |music|
    music.dependency 'PermissionWizard/Core'
    music.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'MUSIC CUSTOM_SETTINGS' }
    music.source_files = 'Source/Supported Types/Music*.swift'
  end
  
  spec.subspec 'Notifications' do |notifications|
    notifications.dependency 'PermissionWizard/Core'
    notifications.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'NOTIFICATIONS CUSTOM_SETTINGS' }
    notifications.source_files = 'Source/Supported Types/Notifications*.swift'
  end
  
  spec.subspec 'Photos' do |photos|
    photos.dependency 'PermissionWizard/Core'
    photos.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'PHOTOS CUSTOM_SETTINGS' }
    photos.source_files = 'Source/Supported Types/Photos*.swift'
  end
  
  spec.subspec 'Reminders' do |reminders|
    reminders.dependency 'PermissionWizard/Core'
    reminders.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'REMINDERS CUSTOM_SETTINGS' }
    reminders.source_files = 'Source/Supported Types/Reminders*.swift'
  end
  
  spec.subspec 'Siri' do |siri|
    siri.dependency 'PermissionWizard/Core'
    siri.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'SIRI CUSTOM_SETTINGS' }
    siri.source_files = 'Source/Supported Types/Siri*.swift'
  end
  
  spec.subspec 'SpeechRecognition' do |speech_recognition|
    speech_recognition.dependency 'PermissionWizard/Core'
    speech_recognition.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'SPEECH_RECOGNITION CUSTOM_SETTINGS' }
    speech_recognition.source_files = 'Source/Supported Types/SpeechRecognition*.swift'
  end
  
  spec.subspec 'Tracking' do |tracking|
    tracking.dependency 'PermissionWizard/Core'
    tracking.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'TRACKING CUSTOM_SETTINGS' }
    tracking.source_files = 'Source/Supported Types/Tracking*.swift'
  end
  
  spec.default_subspec = 'Assets', 'Bluetooth', 'Calendars', 'Camera', 'Contacts', 'FaceID', 'Health', 'Home', 'LocalNetwork', 'Location', 'Microphone', 'Motion', 'Music', 'Notifications', 'Photos', 'Reminders', 'Siri', 'SpeechRecognition', 'Tracking'
  
end
