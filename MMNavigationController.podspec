#
#  Be sure to run `pod spec lint MMNavigationController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "MMNavigationController"
  s.version      = "0.0.3"
  s.summary      = "A NavigationController with fullscreen pop gesture. You can change color of navigation bar in a sample way!"

  s.description  = <<-DESC
  一句代码，即可修改导航栏颜色。
  附加全屏pop手势。
  A NavigationController with fullscreen pop gesture. 
  You can change color of navigation bar in a sample way!
                   DESC

  s.homepage     = "https://github.com/MangoMade/MMNavigationController"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "MangoMade" => "781132399@qq.com" }
  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/MangoMade/MMNavigationController.git", :tag => "#{s.version}" }

  s.source_files  = "MMNavigationController/Source"

  s.requires_arc = true


end
