#
# Be sure to run `pod lib lint ZLUIUtilities.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZLUIUtilities'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ZLUIUtilities.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ExistOrLive/ZLUIUtilities'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ExistOrLive' => '2068531506@qq.com' }
  s.source           = { :git => 'https://github.com/ExistOrLive/ZLUIUtilities.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'ZLUIUtilities/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ZLUIUtilities' => ['ZLUIUtilities/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'ZLBaseUI'

  s.dependency 'ZLBaseExtension'
  
  s.dependency 'ZLUtilities'

  # 刷新控件
  s.dependency 'MJRefresh'
  # 转圈控件
  s.dependency 'MBProgressHUD'
  # ToastView https://github.com/scalessec/Toast-Swift
  s.dependency 'Toast'
  
  s.dependency 'SnapKit'
end
