#
# Be sure to run `pod lib lint PrescreeniOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PrescreeniOS'
  s.version          = '2.1.5'
  s.summary          = 'PrescreeniOS detect and verify Thai national ID cards.'
  s.description      = <<-DESC
  'PrescreeniOS detect and verify Thai national ID cards. It works for both realtime input (camera feed) or an image.'
                       DESC

  s.homepage         = 'https://github.com/Seen-Digital/prescreen-ios-pod.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'northanapon' => 'nor.thanapon@gmail.com' }
  s.source           = { :http => 'https://github.com/Seen-Digital/prescreen-ios-pod/releases/download/v2.1.5/PrescreeniOS-2.1.5.zip' }
  s.swift_versions = '5.0'
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.ios.vendored_frameworks = 'PrescreeniOS.xcframework'
  s.resources = 'PrescreeniOS.bundle'
  s.static_framework = true
  s.dependency 'GoogleMLKit/TextRecognition'
  s.dependency 'GoogleMLKit/ObjectDetectionCustom'
end
