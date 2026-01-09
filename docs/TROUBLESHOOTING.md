# トラブルシューティングガイド

Flutter iOS開発環境セットアップでよくある問題と解決策をまとめています。

## セットアップの問題

### `flutter: command not found`

**原因**: FlutterがPATHに含まれていません。

**解決策**:
```bash
# Flutterがインストールされているか確認
ls -la ~/development/flutter/bin/flutter

# 一時的にPATHに追加
export PATH="$HOME/development/flutter/bin:$PATH"

# 恒久的に追加 - シェル設定ファイルを編集
# zshの場合:
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# bashの場合:
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### `brew: command not found`

**原因**: Homebrewがインストールされていないか、PATHに含まれていません。

**解決策**:
```bash
# Homebrewをインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Apple Siliconの場合、PATHに追加:
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc
```

### CocoaPodsのインストールに失敗

**エラー**: `gem install cocoapods`が失敗する。

**解決策1**: Homebrew経由でインストール（推奨）:
```bash
brew install cocoapods
```

**解決策2**: システムRubyを使用:
```bash
sudo gem install cocoapods
```

**解決策3**: sudoなしでインストール（より安全）:
```bash
# ~/.zshrcまたは~/.bashrcに追加
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"

# その後インストール
gem install cocoapods
```

### Xcodeライセンスが未承認

**エラー**: `Xcode license needs to be accepted`

**解決策**:
```bash
sudo xcodebuild -license accept
```

うまくいかない場合:
```bash
sudo xcodebuild -license
# 読み進めて'agree'と入力
```

### `xcode-select: error: tool 'xcodebuild' requires Xcode`

**原因**: Xcodeがインストールされていないか、正しく設定されていません。

**解決策**:
```bash
# Xcodeがインストールされているか確認
ls -la /Applications/Xcode.app

# Xcodeのパスを設定
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# 確認
xcode-select -p
```

## Flutterの問題

### `flutter doctor`で問題が表示される

よくある問題と修正方法:

**Android toolchain**（iOSのみの開発の場合）:
- iOS開発のみであれば、この警告は無視できます

**CocoaPods not installed**:
```bash
brew install cocoapods
pod setup
```

**Xcode - develop for iOS unavailable**:
- App StoreからXcodeをインストール
- ライセンス承認: `sudo xcodebuild -license`

**iOS deployment target warning**:
- 通常は警告のみで、エラーではありません
- 古いiOSバージョンをターゲットにしない限り無視できます

### `pod install`が失敗する

**エラー**: 様々なCocoaPodsエラー。

**解決策1**: CocoaPodsを更新:
```bash
brew upgrade cocoapods
```

**解決策2**: CocoaPodsキャッシュをクリア:
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
```

**解決策3**: リポジトリを更新:
```bash
pod repo update
cd your_flutter_project/ios
pod install
```

## デバイス接続の問題

### デバイスが表示されない

**解決策**: 詳しくは[DEVICE-CONNECTION.md](DEVICE-CONNECTION.md)を参照してください。

クイックフィックス:
```bash
# usbmuxdを再起動
sudo killall -9 usbmuxd

# libimobiledeviceを更新
brew reinstall --HEAD libimobiledevice
```

### Developerモードが利用できない

**原因**: 一度アプリを実行してからDeveloperモードのオプションが表示されます。

**解決策**:
1. デバイスでFlutterアプリを実行してみる
2. 設定にDeveloperモードのオプションが表示される
3. 有効化してデバイスを再起動

## ビルドの問題

### コード署名エラー

詳しくは[APPLE-DEVELOPER.md](APPLE-DEVELOPER.md)を参照してください。

クイックフィックス:
1. Xcodeを開く: `open ios/Runner.xcworkspace`
2. Runnerターゲットを選択
3. Signing & Capabilitiesタブ
4. 「Automatically manage signing」を有効化
5. チームを選択

### `The operation couldn't be completed`

**完全なエラー**: `The operation couldn't be completed. Unable to launch...`

**解決策**:
1. デバイスのロックが解除されていることを確認
2. コンピュータを信頼していることを確認
3. ビルドをクリーン:
   ```bash
   flutter clean
   flutter pub get
   cd ios && pod install && cd ..
   flutter run
   ```

### `Error: No valid code signing certificates were found`

**解決策**:
1. Xcodeを開く
2. Preferences > Accounts
3. Apple IDを選択
4. 「Manage Certificates」をクリック
5. 「+」 > 「Apple Development」をクリック

### ビルドが「Running Xcode build...」で止まる

**解決策**:
```bash
# プロセスを停止（Ctrl+C）
# すべてクリーン
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
# 再試行
flutter run
```

## パフォーマンスの問題

### ビルドが遅い

**解決策**:
1. シミュレータではなく実機を使用
2. 不要なアプリケーションを閉じる
3. Xcodeのビルドシステムのパフォーマンスを向上:
   - Xcode > Preferences > Locations
   - Derived Dataをローカルのに設定
4. derived dataをクリーン:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```

### シミュレータが遅い・応答しない

**解決策**:
1. シミュレータを終了して再起動
2. シミュレータをリセット: Hardware > Erase All Content and Settings
3. リソース消費の少ないシミュレータを使用（iPhone Pro MaxよりiPhone SE）

## ネットワークの問題

### セットアップ中のダウンロード失敗

**解決策**:
1. インターネット接続を確認
2. 再試行（スクリプトにはリトライロジックあり）
3. プロキシ環境下の場合、gitを設定:
   ```bash
   git config --global http.proxy http://proxy:port
   git config --global https.proxy https://proxy:port
   ```

## macOSバージョンの問題

### 「macOS 12.0以上が必要です」

**原因**: Flutter 3.xはmacOS Monterey以降が必要です。

**解決策**:
- macOSを12.0以上にアップグレード、または
- 古いFlutterバージョンを使用（非推奨）

## 権限の問題

### 「Permission denied」エラー

**解決策**:
```bash
# Homebrewディレクトリの場合
sudo chown -R $(whoami) /usr/local/*

# Flutterディレクトリの場合
sudo chown -R $(whoami) ~/development/flutter
```

### macOSで「Operation not permitted」

**原因**: macOSのセキュリティ制限。

**解決策**:
1. システム設定 > プライバシーとセキュリティ > フルディスクアクセス
2. ターミナルまたは使用中のターミナルアプリを追加
3. ターミナルを再起動

## まだ問題が解決しない場合

1. **ログを確認**: `cat logs/setup-*.log`
2. **Flutter issuesを検索**: [github.com/flutter/flutter/issues](https://github.com/flutter/flutter/issues)
3. **コミュニティに質問**: [stackoverflow.com/questions/tagged/flutter](https://stackoverflow.com/questions/tagged/flutter)
4. **Issueを作成**: 以下を含めてください:
   - macOSバージョン
   - `flutter doctor -v`の出力
   - 完全なエラーメッセージ
   - ログファイルの内容

## 便利なコマンド

```bash
# Flutterインストールを確認
flutter doctor -v

# Flutterバージョンを確認
flutter --version

# Flutterを更新
flutter upgrade

# プロジェクトをクリーン
flutter clean

# Flutterをリセット
flutter channel stable
flutter upgrade --force

# 接続されたデバイスを確認
flutter devices

# 詳細出力で実行
flutter run -v
```
