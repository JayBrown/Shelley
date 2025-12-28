source 'https://github.com/CocoaPods/Specs.git'

platform :osx, '15.0'
use_frameworks!

target 'Shelley' do
  pod 'Sparkle', '~> 2.0'
  pod 'Criollo', '~> 1.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'CocoaAsyncSocket'
      umbrella_path = "#{installer.sandbox.target_support_files_dir(target.name)}/#{target.name}-umbrella.h"
      if File.exist?(umbrella_path)
        contents = File.read(umbrella_path)
        contents.gsub!(/#import "GCDAsyncSocket.h"/, '#import <CocoaAsyncSocket/GCDAsyncSocket.h>')
        contents.gsub!(/#import "GCDAsyncUdpSocket.h"/, '#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>')
        File.write(umbrella_path, contents)
      end
    end
  end
end
