Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '14.0'
s.name = "DHLCustomDropDown"
s.summary = "Selector de items de una lista."
s.requires_arc = true

s.version = "0.1.0"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Daniel-herlop" => "hzlzdaniel@gmail.com" }

s.source = { :git => "https://github.com/daniel-herlop/DHLCustomDropDown.git", 
             :tag => "#{s.version}" }

s.framework = "UIKit"

s.source_files = "DHLCustomDropDown/**/*.{swift}"

s.resources = "DHLCustomDropDown/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

s.swift_version = "5.0"

end
