# Uncomment the next line to define a global platform for your project
platform :ios, '14.2'

target 'AppointmentChecker' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'PinLayout'
  pod 'FlexLayout'
  pod 'Alamofire', '~> 5.2'
  pod 'ReactiveSwift', '~> 6.1'
  pod 'ReactiveCocoa', '~> 10.1'
  pod 'Overture'
  pod 'SnapKit', '~> 5.0.0'
  pod 'KeychainSwift', '~> 19.0'
  # Pods for AppointmentChecker

  target 'AppointmentCheckerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AppointmentCheckerUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
