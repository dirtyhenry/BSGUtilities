#
# Be sure to run `pod lib lint BSGUtilities.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BSGUtilities"
  s.version          = "0.5.0"
  s.summary          = "Bootstragram iOS Utilities Pod"
  s.description      = <<-DESC
                       Bootstragram iOS Utilities Pod

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/dirtyhenry/BSGUtilities"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Mick F" => "contact@bootstragram.com" }
  s.source           = { :git => "https://github.com/dirtyhenry/BSGUtilities.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  # s.resource_bundles = {
  #   'BSGUtilities' => ['Pod/Assets/*.png']
  # }
  s.resources = ['Pod/Assets/html/*.html', 'Pod/Assets/css/*.css']

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'MMMarkdown', '~> 0.3'
end
