
Pod::Spec.new do |s|
  s.name         = "YiRefresh"
  s.version      = "0.0.6"
  s.summary      = "pull-to-refresh"


  s.description  = "An easy way to use pull-to-refresh"

  s.homepage     = "https://github.com/XiaoYiShi/YiRefresh"

  s.license      = "MIT"


  s.author             = { "XiaoYiShi" => "1270654114@qq.com" }

  s.platform     = :ios, "9.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "9.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"



  s.source       = { :git => "https://github.com/XiaoYiShi/YiRefresh.git", :tag => "#{s.version}" }




  s.source_files  = "YiRefresh/**/*.{swift,h,m}"
#s.exclude_files = ""

  # s.public_header_files = "Classes/**/*.h"



  # s.resource  = "icon.png"
  s.resources = "YiRefresh/YiRefresh.bundle"



  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"



  s.requires_arc = true
  s.swift_version = "4.2"
  #s.pod_target_xcconfig = { "SWIFT_VERSION" => "4.2" }
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
