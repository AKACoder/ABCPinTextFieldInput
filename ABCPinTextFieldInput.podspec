Pod::Spec.new do |s|
  s.name         = "ABCPinTextFieldInput"
  s.version      = "0.1"
  s.summary      = "A simple pin code input control / 一个简单的pin码输入控件"
  s.homepage     = "https://github.com/AKACoder/ABCPinTextFieldInput/"
  s.license      = { :type => "MIT" }
  s.author       = { "AKACoder" => "akacoder@outlook.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/AKACoder/ABCPinTextFieldInput.git", :tag => "0.1" }
  s.source_files = "SourceCode/**/*.{swift}"
  s.requires_arc = true
  s.dependency "AsyncSwift", "2.0.4"
  s.dependency "Neon", "0.4.0"
end
