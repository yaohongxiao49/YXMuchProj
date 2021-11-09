platform :ios, '10.0'
inhibit_all_warnings!

target 'MuchProj' do

#source 'https://github.com/CocoaPods/Specs.git'
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

pod 'AFNetworking'                   #网络请求
pod 'Masonry'                        #布局
pod 'IQKeyboardManager'              #键盘管理
pod 'YYText'                         #富文本
pod 'YYWebImage'                     #网络图片
pod 'Realm'                          #简单强大的数据库
pod 'HXPhotoPicker'                  #相册选择
pod 'SVProgressHUD'                  #提示框
#pod 'MGSwipeTableCell'               #自定义cell的左滑右滑按钮
#pod 'SDWebImage'                     #网络图片
#pod 'SocketRocket'                   #长连接

post_install do |installer|
  installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
  if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 10.0
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
     end
   end
  end
end
end
