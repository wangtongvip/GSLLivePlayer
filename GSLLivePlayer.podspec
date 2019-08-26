#
#  Be sure to run `pod spec lint GSLLivePlayer.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "GSLLivePlayer"
  spec.version      = "0.0.1"
  spec.summary      = "GSL LivePlayer"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = <<-DESC
                        哥斯拉六路连麦
                   DESC

  spec.homepage     = "https://github.com/wangtongvip/GSLLivePlayer"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  # spec.license      = "MIT (example)"
  spec.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "wangtong" => "wangtong0@gaosiedu.com" }
  # Or just: spec.author    = "wangtong"
  # spec.authors            = { "wangtong" => "wangtong0@gaosiedu.com" }
  # spec.social_media_url   = "https://twitter.com/wangtong"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  spec.platform     = :ios
  spec.platform     = :ios, "9.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source       = { :git => "https://github.com/wangtongvip/GSLLivePlayer.git", :tag => spec.version }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  # spec.source_files  = "GSLLivePlayer/GSLLivePlayerDemo/LiveRoomViewController.{h,m}", "GSLLivePlayer/GSLLivePlayerDemo/LiveControlView.{h,m}", "GSLLivePlayer/GSLLivePlayerDemo/PreviewView.{h,m}", "GSLLivePlayer/GSLLivePlayerDemo/SettingManager.{h,m}", "GSLLivePlayerFramework.framework/Headers/*.{h,m}", "GSLSignalingCenterFramework.framework/Headers/*.{h,m}", "TXLiteAVSDK_TRTC.framework/Headers/*.{h,m}"
  spec.source_files  = "GSLLivePlayerFramework.framework/Headers/*.{h,m}"
  # spec.source_files  = "GSLLivePlayerFramework.framework/Headers/*.{h,m}", "GSLSignalingCenterFramework.framework/Headers/*.{h,m}", "TXLiteAVSDK_TRTC.framework/Headers/*.{h,m}"
  # spec.source_files  = "GSLLivePlayerFramework.framework/Headers/*.h", "TXLiteAVSDK_TRTC.framework/Headers/*.h"
  # spec.exclude_files = "Classes/Exclude"

  spec.public_header_files = "GSLLivePlayerFramework.framework/Headers/*.h"

  # spec.prefix_header_contents = "#import <GSLLivePlayerFramework/GSLLivePlayerFramework.h>", "#import <GSLSignalingCenterFramework/GSLSignalingCenterFramework.h>"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "GSLLivePlayerFramework.framework", "TXLiteAVSDK_TRTC.framework"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "UIKit"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.vendored_framework = "GSLLivePlayer/GSLLivePlayerDemo/GSLSignalingCenterFramework.framework"
  # spec.vendored_framework = "GSLSignalingCenterFramework.framework"
  # spec.vendored_library = "GSLSignalingCenterFramework.framework"
  # spec.vendored_frameworks = "GSLLivePlayerFramework.framework", "TXLiteAVSDK_TRTC.framework"
  spec.vendored_framework = "GSLLivePlayerFramework.framework"
  # spec.library   = "c++"
  # spec.libraries = "c++", "resolv"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.xcconfig = { "VALID_ARCHS" =>  "arm64 armv7 armv7s x86_64", }
  spec.dependency "GSLKit", "~> 0.0.1"
  spec.dependency "GSLSignalingCenter", "~> 0.0.1"
  spec.dependency "TXLiteAVSDK_TRTC", "~> 6.6.7459"
  # spec.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 armv7 x86_64 i386' }

end
