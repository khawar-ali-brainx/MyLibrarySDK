
Pod::Spec.new do |spec|
  spec.name         = "MyLibrarySDK"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of MyLibrarySDK is this."
  spec.homepage     = "http://EXAMPLE/MyLibrarySDK"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Khawar Ali" => "khawar.ali@brainxtech.com" }
  spec.source       = { :git => "http://EXAMPLE/MyLibrarySDK.git", :tag => "#{spec.version}" }
  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"
end
