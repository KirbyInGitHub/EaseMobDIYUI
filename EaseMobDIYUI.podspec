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
      view.source_files = 'EaseMobUI/EaseMobUI/View/*.{h.m}'
      view.public_header_files = 'EaseMobUI/EaseMobUI/View/*.h'

      view.subspec 'ChatBar' do |chatBar|
          chatBar.source_files = 'EaseMobUI/EaseMobUI/View/ChatBar/*.{h,m}'
          chatBar.public_header_files = 'EaseMobUI/EaseMobUI/View/ChatBar/*.h'

          chatBar.subspec 'Tool' do |tool|
              tool.source_files = 'EaseMobUI/EaseMobUI/View/ChatBar/Tool/*.{h,m}'
              tool.public_header_files = 'EaseMobUI/EaseMobUI/View/ChatBar/Tool/*.h'
          end
      end

      view.subspec 'ChatCell' do |chatCell|
          chatCell.source_files = 'EaseMobUI/EaseMobUI/View/ChatCell/*.{h,m}'
          chatCell.public_header_files = 'EaseMobUI/EaseMobUI/View/ChatCell/*.h'

          chatCell.subspec 'Bubble' do |bubble|
              bubble.source_files =  'EaseMobUI/EaseMobUI/View/ChatCell/Bubble/*.{h,m}'
              bubble.public_header_files = 'EaseMobUI/EaseMobUI/View/ChatCell/Bubble/*.h'
          end
      end

  end

  s.subspec 'Model' do |model|
      model.source_files = 'EaseMobUI/EaseMobUI/Model/*.{h,m}'
      model.public_header_files = 'EaseMobUI/EaseMobUI/Model/*.h'

      model.subspec 'DB' do |db|
          db.source_files = 'EaseMobUI/EaseMobUI/Model/DB/*.{h,m}'
          db.public_header_files = 'EaseMobUI/EaseMobUI/Model/DB/*.h'
      end

      model.subspec 'Message' do |message|
          message.source_files = 'EaseMobUI/EaseMobUI/Model/Message/*.{h,m}'
          message.public_header_files = 'EaseMobUI/EaseMobUI/Model/Message/*.h'
      end
  end

  s.subspec 'Common' do |common|
      common.source_files = 'EaseMobUI/EaseMobUI/Common/*.{h,m}'
      common.public_header_files = 'EaseMobUI/EaseMobUI/Common/*.h'

      common.subspec 'Utils' do |utils|
          utils.source_files = 'EaseMobUI/EaseMobUI/Common/Utils/*.{h,m}'
          utils.public_header_files = 'EaseMobUI/EaseMobUI/Common/Utils/*.h'
      end

      common.subspec 'DB' do |db|
          db.source_files = 'EaseMobUI/EaseMobUI/Common/DB/*.{h,m}'
          db.public_header_files = 'EaseMobUI/EaseMobUI/Common/DB/*.h'
      end

      common.subspec 'Rdparty' do |rdparty|
          rdparty.source_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/*.{h,m}'
          rdparty.public_header_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/*.h'

          rdparty.subspec 'DeviceUtil' do |deviceUtil|
              deviceUtil.source_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/DeviceUtil/*.{h,m}'
              deviceUtil.public_header_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/DeviceUtil/*.h'

              deviceUtil.subspec 'delegates' do |delegates|
                  delegates.source_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/DeviceUtil/delegates/*.{h,m}'
                  delegates.public_header_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/DeviceUtil/delegates/*.h'
              end

              deviceUtil.subspec 'internal' do |internal|
                  internal.source_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/DeviceUtil/internal/*.{h,m}'
                  internal.public_header_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/DeviceUtil/internal/*.h'
              end
          end

          rdparty.subspec 'VoiceConvert' do |voiceConvert|
              voiceConvert.source_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/VoiceConvert/*.{h,m}'
              voiceConvert.public_header_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/VoiceConvert/*.h'

              voiceConvert.subspec 'amrwapper' do |amrwapper|
                  amrwapper.source_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/VoiceConvert/amrwapper/*.{h,m}'
                  amrwapper.public_header_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/VoiceConvert/amrwapper/*.h'
              end

              voiceConvert.subspec 'opencore-amrnb' do |opencore-amrnb|
                  opencore-amrnb.source_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/VoiceConvert/opencore-amrnb/*'
                  opencore-amrnb.public_header_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/VoiceConvert/opencore-amrnb/*.h'
              end

              voiceConvert.subspec 'opencore-amrwb' do |opencore-amrwb|
                  opencore-amrwb.source_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/VoiceConvert/opencore-amrwb/*'
                  opencore-amrwb.public_header_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/VoiceConvert/opencore-amrwb/*.h'
              end

          end

          rdparty.subspec 'Emoji' do |emoji|
              emoji.source_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/Emoji/*.{h,m}'
              emoji.public_header_files = 'EaseMobUI/EaseMobUI/Common/Rdparty/Emoji/*.h'
          end

      end

      common.subspec 'Category' do |category|
          category.source_files = 'EaseMobUI/EaseMobUI/Common/Category/*.{h,m}'
          category.public_header_files = 'EaseMobUI/EaseMobUI/Common/Category/*.h'
      end

      common.subspec 'Class' do |class|
          class.source_files = 'EaseMobUI/EaseMobUI/Common/Class/*.{h,m}'
          class.public_header_files = 'EaseMobUI/EaseMobUI/Common/Class/*.h'
      end

  end

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.resources = ["EaseMobUI/Resource/EM_Resource.bundle","EaseMobUI/Resource/EM_ChatStrings.strings"]
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
