#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint sshvpn_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sshvpn_flutter'
  s.version          = '1.0.0'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://naviddev.info'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Navid Shokoufeh' => 'Navidshokoufeh.dev@gmail.com.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.static_framework = true
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'
  s.vendored_libraries = "**/*.a"
  s.dependency 'vpn_adapter_ios', '~> 1.0.0'


  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'}
end
