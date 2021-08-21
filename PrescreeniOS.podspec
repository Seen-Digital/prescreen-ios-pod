#
# Be sure to run `pod lib lint PrescreeniOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PrescreeniOS'
  s.version          = '0.0.2'
  s.summary          = 'PrescreeniOS detect and verify Thai national ID cards.'
  s.description      = <<-DESC
  'PrescreeniOS detect and verify Thai national ID cards. It works for both realtime input (camera feed) or an image.'
                       DESC

  s.homepage         = 'https://github.com/InDistinct-Studio/prescreen-ios-pod.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'northanapon' => 'nor.thanapon@gmail.com' }
  s.source           = { :http => 'https://github.com/InDistinct-Studio/prescreen-ios-pod/releases/download/0.0.2/PrescreeniOS.zip' }
#  s.source           = { :git => 'https://github.com/InDistinct-Studio/prescreen-ios-pod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.1'
  s.ios.vendored_frameworks = 'PrescreeniOS.framework'
  # s.resource_bundles = {
  #   'PrescreeniOS' => ['PrescreeniOS/Assets/*.png']
  # }
  s.resources = 'PrescreeniOS.bundle'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.static_framework = true
  s.dependency 'GoogleMLKit/TextRecognition'
  s.dependency 'GoogleMLKit/ObjectDetectionCustom'
end
