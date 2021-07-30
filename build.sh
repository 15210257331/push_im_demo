#!/bin/bash

#选择平台
read -p "输入平台（1: ios，2: android） :" PlatformKey


case $PlatformKey in
1)
    echo "ios"
    echo -e "开始执行构建脚本 flutter build ios --profile --flavor prod -t lib/main_prod.dart"
    flutter build ios -t lib/main.dart
    ;;
2)
    echo "android"
    echo -e "开始执行构建脚本 build apk -t lib/main.dart"
    flutter build apk -t lib/main.dart
    ;;
*)
    echo "输入平台不存在，脚本执行已终止"
    ;;
esac

#构建安卓
function android_build() {
  echo "上传apk文件至蒲公英..."
  curl -F 'file=@"./build/app/outputs/flutter-apk/app-release.apk"' -F '_api_key=031795818e9d0e21c952ab30478dd654' https://www.pgyer.com/apiv2/app/upload
  echo "finish upload"
}

echo "android build"
android_build