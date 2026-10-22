{ pkgs, pkgs-unstable, ... }:
{
  home.packages = with pkgs; [
    android-studio
    android-tools
    jdk17
    pkgs-unstable.flutter344
  ];

  # Android Studio's SDK Manager installs the SDK and emulator under this path.
  home.sessionVariables = {
    ANDROID_HOME = "/home/hoge/Android/Sdk";
    ANDROID_SDK_ROOT = "/home/hoge/Android/Sdk";
  };
}
