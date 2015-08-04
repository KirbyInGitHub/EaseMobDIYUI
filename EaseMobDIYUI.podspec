Pod::Spec.new do |s|  
  s.name             = "EaseMobDIYUI"  
  s.version          = "0.1.0"  
  s.summary          = "环信DIY聊天UI"  
  s.description      = "集成环信SDK的可高度自定义的聊天UI,简单集成,即插即用"
  s.homepage         = "https://github.com/AwakenDragon/EaseMobDIYUI"   
  s.license          = 'MIT(LICENSE)'  
  s.author           = { "周玉震" => "940549652@qq.com" }  
  s.source           = { :git => "https://github.com/AwakenDragon/EaseMobDIYUI.git", :tag => s.version.to_s }   
  
  s.source_files     = 'EaseMobUI/EaseMobUI/*.{h,m}'  
  s.resources        = 'EaseMobUI/EaseMobUI/Supporting Files/*'  
  s.frameworks       = 'Foundation', 'CoreGraphics', 'UIKit','MapKit'

  s.platform         = :ios, '7.0'  
  # s.ios.deployment_target = '8.4'  
  # s.osx.deployment_target = '10.10.4'  
  s.requires_arc = true  
end  