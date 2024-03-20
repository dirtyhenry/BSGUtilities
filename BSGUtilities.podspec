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

  s.platform     = :ios, '12.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
