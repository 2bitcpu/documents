# Setup MacOS Sonoma

#### Homebrew
[macOS（またはLinux）用パッケージマネージャー](https://brew.sh/ja/)
```bash
# 標準ターミナルで
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# インストールに失敗する場合は、Command line tools for Xcodeを先にインストールしておく
xcode-select --install
```
時間がかかります  
ターミナルを別途起動して下記設定を行っても良いです

#### キーリピートの速度/入力認識までの時間
[システム設定]→[キーボード]  
[キーリピートの速度]を最速  
[キーリーピート入力認識までの時間]を最短
```bash
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
```

#### CapsLockで日本語入力
[システム設定]→[キーボード]→[テキスト入力]→[入力ソース]→[編集]→[日本語 - ローマ字入力]→[Caps Lockの動作]→[オフの時「英字」を入力]
```bash
defaults write com.apple.inputmethod.Kotoeri JIMPrefCapsLockActionKey -int 4
```

#### トラックパッドの軌跡の速さ
[システム設定]→[ポインタとクリック]→[軌跡の速さ]を最大に
```bash
defaults write -g com.apple.trackpad.scaling 3
```

#### 副ボタンクリックを2本指でタップまたはクリックに
```bash
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true

defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
```

#### タップでクリックを有効に
```bash
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
```

#### ３本指でドラッグ
[システム設定]→[アクセシビリティ]→[ポインタコントロール]→[トラックパッドオプション]  
[ドラッグにトラックパッドを使用]をオン  
[ドラッグ方法]を「３本指のドラッグ」
```bash
# 接続機器用
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# 本体用
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
```

#### スクリーンショットの保存先変更
[cmd + shift + 5]→[オプション]→[保存先]→[一覧になければその他から]
```bash
defaults write com.apple.screencapture location ~/screenshot
killall SystemUIServer
```

#### 起動音を鳴らさない
[システム設定]→[サウンド]
「起動時にサウンドを再生」をオフ

#### Finderを終了可能に
GUIでの設定は見当たらない
```bash
defaults write com.apple.Finder QuitMenuItem -bool true
```

#### WezTerm + Cica Font + eza
```bash
brew install --cask wezterm
brew install --cask font-cica
brew install eza
```
