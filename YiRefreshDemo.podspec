Pod::Spec.new do |s|
  #库的名称
  s.name         = "YiRefresh"
  #库的版本
  s.version      = "0.0.1"
  #库的摘要
  s.summary      = "MJRefresh用swift重写"
  #远程仓库的地址
  s.homepage     = "https://github.com/XiaoYiShi/YiRefresh"
  s.license      = "MIT (example)"
  s.author       = { "XiaoYiShi" => "1270654114@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/XiaoYiShi/YiRefresh.git", :tag => "#{s.version}" }
  s.source_files = "YiRefresh/**/*.{swift}"
  s.resource  = "YiRefresh/Current/YiRefresh.bundle"
  s.requires_arc = true
endC
