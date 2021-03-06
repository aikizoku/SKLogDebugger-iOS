#
# Be sure to run `pod lib lint SKLogDebugger.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SKLogDebugger'
  s.version          = '1.2.0'
  s.summary          = 'This is Saikyo.'
  s.swift_version    = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Saikyo log debugger.
                       DESC

  s.homepage         = 'https://github.com/aikizoku/SKLogDebugger-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aikizoku' => 'yuki@thehero.jp' }
  s.source           = { :git => 'https://github.com/aikizoku/SKLogDebugger-iOS.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/aikizoku'

  s.ios.deployment_target = '10.0'

  s.source_files = 'SKLogDebugger/Classes/**/*'
  
  s.resource_bundles = {
'SKLogDebugger' => ['SKLogDebugger/Assets/**/*.{xib,storyboard}']
  }

  s.frameworks = 'UIKit'
  s.dependency 'RxSwift', '~> 4.0'
  s.dependency 'RxCocoa', '~> 4.0'
  s.dependency 'SwiftyJSON'
  s.dependency 'SwiftyAttributes'
end
