#
#  Be sure to run `pod spec lint EaseMobDIYUI.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "EaseMobDIYUI"
  s.version      = "0.1.4"
  s.summary      = "环信DIY聊天UI"

  s.description  = <<-DESC
                   环信DIY聊天UI.

                   * 方便集成环信的开发者,快速的开发和定制自己的聊天界面
                   * 快速,简单,集成
                   * 0.1.0暂时只有聊天界面,暂时未开发语音和视频聊天
                   DESC

  s.homepage     = "https://github.com/AwakenDragon/EaseMobDIYUI"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = "MIT"


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author               = { "周玉震" => "940549652@qq.com" }
  # s.authors            = { "周玉震" => "" }
  # s.social_media_url   = "http://twitter.com/周玉震"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "7.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "8.4"
  # s.osx.deployment_target = "10.10.4"
  # s.watchos.deployment_target = "1.0.1"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/AwakenDragon/EaseMobDIYUI.git", :tag => s.version.to_s }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.subspec 'Controller' do |controller|
      controller.source_files = 'EaseMobUI/EaseMobUI/Controller/**/*'
      controller.public_header_files = 'EaseMobUI/EaseMobUI/Controller/**/*.h'
  end

  s.subspec 'View' do |view|
      view.source_files = 'EaseMobUI/EaseMobUI/View/**/*'
      view.public_header_files = 'EaseMobUI/EaseMobUI/View/**/*.h'
  end

  s.subspec 'Model' do |model|
      model.source_files = 'EaseMobUI/EaseMobUI/model/**/*.'
      model.public_header_files = 'EaseMobUI/EaseMobUI/model/**/*.h'
  end

  s.subspec 'Common' do |common|
      common.source_files = 'EaseMobUI/EaseMobUI/Common/**/*.{h,m}'
      common.public_header_files = 'EaseMobUI/EaseMobUI/Common/**/*.h'
  end

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.resources = "EaseMobUI/Resource/EM_Resource.bundle,EaseMobUI/Resource/EM_ChatStrings.strings"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.frameworks = "UIKit", "MapKit","Foundation"
  s.vendored_libraries = ['EaseMobUI/EaseMobUI/Common/Rdparty/VoiceConvert/opencore-amrnb/libopencore-amrnb.a',
                          'EaseMobUI/EaseMobUI/Common/Rdparty/VoiceConvert/opencore-amrwb/libopencore-amrwb.a']
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "EaseMobSDKFull", "2.1.7"
  s.dependency "SDWebImage", "3.7.3"
  s.dependency "MJRefresh", "2.0.4"
  s.dependency "MWPhotoBrowser", "2.1.1"
  s.dependency "MBProgressHUD", "0.9.1"
  s.dependency "FMDB", "2.5"
  s.dependency "TTTAttributedLabel", "1.13.4"

end
