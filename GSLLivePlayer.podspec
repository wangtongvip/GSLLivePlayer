Pod::Spec.new do |spec|

  spec.name         = "GSLLivePlayer"
  spec.version      = "0.0.1"
  spec.summary      = "GSL LivePlayer"
  spec.description  = <<-DESC
                        哥斯拉六路连麦
                   DESC

  spec.homepage     = "https://github.com/wangtongvip/GSLLivePlayer"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "wangtong" => "wangtong0@gaosiedu.com" }

  spec.platform     = :ios
  spec.platform     = :ios, "9.0"

  spec.source       = { :git => "https://github.com/wangtongvip/GSLLivePlayer.git", :tag => spec.version }
  spec.source_files  = "GSLLivePlayerFramework.framework/Headers/*.{h,m}"
  spec.public_header_files = "GSLLivePlayerFramework.framework/Headers/*.h"
  spec.vendored_frameworks = ["GSLLivePlayerFramework.framework"]
  spec.requires_arc = true

  spec.dependency "GSLKit", "~> 0.0.1"
  spec.dependency "GSLSignalingCenter", "~> 0.0.1"
  spec.dependency "TXLiteAVSDK_TRTC", "~> 6.6.7459"

  spec.xcconfig = { "VALID_ARCHS" =>  "arm64 armv7 armv7s x86_64"}

  spec.prefix_header_contents = '#import <UIKit/UIKit.h>'

end
