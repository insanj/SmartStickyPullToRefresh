#
# Be sure to run `pod lib lint SmartStickyPullToRefresh.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SmartStickyPullToRefresh"
  s.version          = "0.1"
  s.summary          = "Smart, sticky pull to refresh control for any UIScrollView."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
  Smart, sticky pull to refresh control for any UIScrollView. Instead of relying on the header view of a table or collection view, SmartStickyPullToRefresh uses a custom banner view that drops down from a user-selected `parentView` after a `parentScrollView` surpasses `stickyScrollViewActivationOffset` (use `stickyScrollViewPreActivationOffset` for pre-activation instructions and `stickyScrollViewDeactivationOffset` to hide these instructions).
                      DESC

  s.homepage         = "https://github.com/insanj/SmartStickyPullToRefresh"
  s.screenshots      = "https://raw.githubusercontent.com/insanj/SmartStickyPullToRefresh/master/Example/Screenshots/screenie_1.png", "https://raw.githubusercontent.com/insanj/SmartStickyPullToRefresh/master/Example/Screenshots/screenie_2.png", "https://raw.githubusercontent.com/insanj/SmartStickyPullToRefresh/master/Example/Screenshots/screenie_3.png"
  s.license          = 'MIT'
  s.author           = { "insanj" => "insanjmail@gmail.com" }
  s.source           = { :git => "https://github.com/insanj/SmartStickyPullToRefresh.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/insanj'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SmartStickyPullToRefresh' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'CompactConstraint'
end
