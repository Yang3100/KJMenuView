Pod::Spec.new do |s|
  s.name         = "KJMenuView"
  s.version      = "1.0.1"
  s.summary      = "Organize some menu controls."
  s.homepage     = "https://github.com/yangKJ/KJMenuView"
  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.license      = "Copyright (c) 2018 yangkejun"
  s.author       = { "77" => "393103982@qq.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/yangKJ/KJMenuView.git", :tag => "#{s.version}" }
  s.social_media_url = 'https://www.jianshu.com/u/c84c00476ab6'
  s.requires_arc = true
  
  
  s.ios.source_files = 'KJMenuView/KJMenuHeader.h' # 添加头文件
  
  s.subspec 'MenuCollectionView' do |ss|
    ss.source_files = "KJMenuView/MenuCollectionView/**/*.{h,m}" # 添加文件
    ss.public_header_files = "KJMenuView/MenuCollectionView/**/*.h",'KJMenuView/MenuCollectionView/*.h'# 添加头文件
  end

  s.subspec 'KJDropDownMenu' do |ss|
    ss.source_files = "KJMenuView/KJDropDownMenu/**/*.{h,m}" # 添加文件
    ss.public_header_files = "KJMenuView/KJDropDownMenu/**/*.h",'KJMenuView/KJDropDownMenu/*.h'# 添加头文件
    ss.resources    = "KJMenuView/KJDropDownMenu/**/*.{bundle}" # 添加数据资料
  end
  
  s.frameworks = 'Foundation','UIKit'#,'QuartzCore','Accelerate'#,'AssetsLibrary','MobileCoreServices','CoreFoundation','CoreGraphics','CoreImage','ImageIO','CoreText','SystemConfiguration'
  # s.dependency "JSONKit", "~> 1.4"
  
end


