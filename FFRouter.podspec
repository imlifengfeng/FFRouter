Pod::Spec.new do |s|
  s.name         = 'FFRouter'
  s.version      = '1.0.0'
  s.summary      = 'Powerful and easy-to-use URL routing library in iOS that supports URL Rewrite'
  s.homepage     = "https://github.com/imlifengfeng/FFRouter"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "imlifengfeng" => "imlifengfeng@gmail.com" }
  s.source       = { :git => 'https://github.com/imlifengfeng/FFRouter.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'FFRouter/**/*.{h,m}'

end
