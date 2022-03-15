
Pod::Spec.new do |spec|
  spec.name         = "MyLibrarySDK"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of MyLibrarySDK is this."
  spec.homepage     = "https://github.com/khawar-ali-brainx/MyLibrarySDK.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Khawar Ali" => "khawar.ali@brainxtech.com" }
  spec.source       = { :git => "https://github.com/khawar-ali-brainx/MyLibrarySDK.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/**/*"
  spec.platform     = :ios
    spec.ios.deployment_target = "9.0"
end
