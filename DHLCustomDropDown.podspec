Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '14.0'
s.name = "DHLCustomDropDown"
s.summary = "Selector de un item/items de un listado"
s.requires_arc = true

s.version = "1.0.0"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Daniel Hernandez Lopez" => "hzlzdaniel@gmail.com" }

s.homepage = "https://github.com/daniel-herlop/DHLCustomDropDown"

s.source = { :git => "https://github.com/daniel-herlop/DHLCustomDropDown.git", 
             :tag => "#{s.version}" }

s.framework = "UIKit"

s.source_files = "DHLCustomDropDown/**/*.{swift}"

# 9
s.resources = "DHLCustomDropDown/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,strings}"

# 10
s.swift_version = "5.0"

end
