#use_frameworks!

source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'
platform :ios, '10.0'

target 'NetworkMoyaBase' do
  
  pod 'YYModel', '1.0.4'
  pod 'HandyJSON', '~> 5.0.0-beta.1'
  pod 'SwiftyJSON'
  pod 'Alamofire', '~>5.6.4'
  pod 'Moya'
  pod 'extobjc'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
    end
   end
  installer.generated_projects.each do |project|
      project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['CODE_SIGN_IDENTITY'] = ''
           end
      end
    end
end
