
#!/bin/sh

xcodebuildListResult=$(xcodebuild -list -json)

# 打包环境 - debug
Archive_Configuration="archive"

# 钥匙串密码
Keychain_Password="13"

# 当前路径
Current_Path=$(pwd)
echo "Current_Path: ${Current_Path}"

# 打包路径
Archive_Path="${Current_Path}/build/Debug-iphoneos/导出应用名称.xcarchive"
echo "Archive_Path: ${Archive_Path}"

# 导出ipa包路径
Export_Path="${Current_Path}/build/导出ipa包路径"
echo "Export_Path: ${Export_Path}"

Export_Option_Plist_Path="${Current_Path}/ExportOptions.plist"
echo "Export_Option_Plist_Path: ${Export_Option_Plist_Path}"

pod install

xcodebuild clean -workspace 你的WORKSPACE名.xcworkspace -scheme 你的TARGET名基本和项目名一样

security unlock-keychain -p 你的钥匙串密码

echo "Begin archive..."
xcodebuild -archivePath ${Archive_Path} -workspace 你的WORKSPACE名.xcworkspace -sdk iphoneos -scheme 你的TARGET名基本和项目名一样 archive
echo "Archive success"

echo "Export ipa file"
xcodebuild -exportArchive -archivePath ${Archive_Path} -exportPath ${Export_Path} -exportOptionsPlist ${Export_Option_Plist_Path} -allowProvisioningUpdates
echo "Export ipa file success"
