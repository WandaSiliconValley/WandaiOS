platform :ios, '10.3'

target 'Wanda' do
  use_frameworks!
  pod 'FacebookCore'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
end


/* to do understand this better */
post_install do |installer|
  installer.pods_project.target.each do |config|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['EXPANDED_CODE_SIGN_IDTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
    end
  end
end
