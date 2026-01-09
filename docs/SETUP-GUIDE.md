# 完全セットアップガイド

macOS上でFlutter iOS開発環境をセットアップする詳細ガイドです。

## 概要

このセットアッププロセスでインストール・設定されるもの：
- Flutter SDK（最新安定版）
- Xcodeと iOS開発ツール
- CocoaPods（iOS依存関係管理ツール）
- 開発ツール（ios-deploy、libimobiledeviceなど）
- シェル環境設定

**所要時間**: 1〜2時間（主にXcodeのダウンロード時間）

## 前提条件

セットアップを実行する前に：

- **macOS 12.0以降**（Monterey以降）
- **20GB以上**の空きディスク容量
- **安定したインターネット**接続
- **管理者権限**（sudoコマンド用）
- **Apple ID**（無料アカウントでOK）

## インストール手順

### ステップ1: クローンまたはダウンロード

```bash
# リポジトリをクローン
git clone https://github.com/glkt3912/flutter-ios-setup.git
cd flutter-ios-setup

# またはZIPをダウンロードして解凍
```

### ステップ2: 設定の確認（オプション）

スクリプトはデフォルト設定を使用しますが、カスタマイズも可能です：

```bash
# サンプル設定をコピー
cp config/config.example.sh config/config.sh

# 設定を編集
nano config/config.sh
```

**主な設定項目**:
- `FLUTTER_INSTALL_DIR`: Flutterのインストール先
- `TEST_PROJECT_NAME`: テストプロジェクト名
- `CREATE_TEST_PROJECT`: テストプロジェクトを作成するか

### ステップ3: セットアップスクリプトを実行

```bash
./setup.sh
```

スクリプトが以下を実行します：
1. システム要件のチェック
2. Homebrewのインストール/確認
3. Xcodeインストールのプロンプト（必要な場合）
4. Flutter SDKのインストール
5. シェル環境の設定
6. CocoaPodsのインストール
7. iOS開発ツールのインストール
8. Flutter Doctorの実行
9. テストプロジェクトの作成（有効な場合）

### ステップ4: Xcodeをインストール

プロンプトが表示されたら：

1. スクリプトが自動的にApp Storeを開きます
2. 自動で開かない場合は「Xcode」を検索
3. 「入手」またはクラウドダウンロードアイコンをクリック
4. ダウンロードを待つ（12〜15GB、30〜60分）
5. インストール完了後、ターミナルに戻る
6. Enterキーを押して続行
7. パスワード入力を求められたら管理者パスワードを入力

その後、スクリプトが自動的に：
- Xcodeライセンスの承認
- Xcode設定の構成
- 追加コンポーネントのインストール

### ステップ5: ターミナルを再起動

セットアップ完了後、ターミナルを再起動するか、以下を実行：

```bash
# zshの場合（最近のmacOSのデフォルト）
source ~/.zshrc

# bashの場合
source ~/.bashrc
```

これによりFlutterがPATHに追加されます。

### ステップ6: インストールを確認

```bash
# 検証スクリプトを実行
./scripts/verify.sh

# または手動で確認
flutter doctor -v
```

期待される出力：
```
[✓] Flutter (Channel stable, X.X.X)
[✓] Xcode - develop for iOS and macOS (X.X.X)
[✓] CocoaPods version X.X.X
```

## インストール後

### シミュレータでテスト

1. シミュレータを起動：
   ```bash
   open -a Simulator
   ```

2. テストアプリを実行（作成した場合）：
   ```bash
   cd flutter_test_app
   flutter run
   ```

3. アプリがシミュレータでビルド・起動されます

### 実機デバイスを接続

[DEVICE-CONNECTION.md](DEVICE-CONNECTION.md)を参照：
- Developerモードの有効化
- コンピュータの信頼
- コード署名の設定

### Apple Developerアカウントのセットアップ

[APPLE-DEVELOPER.md](APPLE-DEVELOPER.md)を参照：
- 無料 vs 有料アカウント
- コード署名の設定
- TestFlightのセットアップ

## インストールされるもの

### システムへの変更

**Homebrew**（存在しない場合）:
- 場所: `/opt/homebrew`（Apple Silicon）または `/usr/local`（Intel）
- 用途: ツールと依存関係のインストール

**Flutter SDK**:
- デフォルト場所: `~/development/flutter`
- サイズ: 約1〜2GB
- 含まれるもの: Flutterフレームワーク、Dart SDK、iOSツールチェーン

**Xcode**:
- 場所: `/Applications/Xcode.app`
- サイズ: 約12〜15GB
- 含まれるもの: iOS SDK、シミュレータ、ビルドツール

**CocoaPods**:
- iOS依存関係管理ツール
- Homebrew経由でインストール
- Flutter iOSプロジェクトで使用

**iOS開発ツール**:
- `ios-deploy`: 実機へのアプリデプロイ
- `libimobiledevice`: iOSデバイスとの通信
- `ideviceinstaller`: デバイスへのアプリインストール

### 設定の変更

**シェル設定**（~/.zshrcまたは~/.bashrc）:
```bash
export FLUTTER_HOME="$HOME/development/flutter"
export PATH="$FLUTTER_HOME/bin:$PATH"
export PATH="$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"
```

**状態追跡**:
- `state/setup-state.json`: 再開機能用のインストール状態
- `logs/setup-*.log`: 詳細なインストールログ

## 再開機能

セットアップが中断された場合、`./setup.sh`を再実行するだけです。スクリプトは：
- 完了済みの内容を確認
- 完了済みステップをスキップ
- 中断した場所から続行

ステップを強制的に再実行したい場合は、`state/setup-state.json`を編集して`completed_steps`配列からステップ名を削除してください。

## カスタマイズ

### Flutterインストール先の変更

`config/config.sh`を編集：
```bash
FLUTTER_INSTALL_DIR="/custom/path/flutter"
```

### テストプロジェクト作成をスキップ

`config/config.sh`を編集：
```bash
CREATE_TEST_PROJECT=false
```

### iOS開発ツールを無効化

`config/config.sh`を編集：
```bash
INSTALL_IOS_TOOLS=false
```

## トラブルシューティング

詳しくは[TROUBLESHOOTING.md](TROUBLESHOOTING.md)を参照してください。

クイックフィックス：

**セットアップ後にFlutterが見つからない**:
```bash
source ~/.zshrc  # または ~/.bashrc
flutter --version
```

**Xcodeライセンスの問題**:
```bash
sudo xcodebuild -license accept
```

**CocoaPodsの問題**:
```bash
brew upgrade cocoapods
pod repo update
```

## アンインストール

FlutterとRelated toolsを削除するには：

1. **Flutterを削除**:
   ```bash
   rm -rf ~/development/flutter
   ```

2. **シェル設定から削除**:
   `~/.zshrc`または`~/.bashrc`を編集してFlutter関連の行を削除

3. **オプション - Homebrewパッケージを削除**:
   ```bash
   brew uninstall cocoapods ios-deploy libimobiledevice ideviceinstaller
   ```

4. **オプション - Xcodeを削除**:
   - `/Applications/Xcode.app`をゴミ箱へ
   - derived dataをクリア: `rm -rf ~/Library/Developer/Xcode/DerivedData`

**注意**: Homebrewそのものは削除しません。他のツールでも使用されている可能性があるためです。

## 次のステップ

1. **Flutterを学ぶ**: [flutter.dev/docs/get-started/codelab](https://flutter.dev/docs/get-started/codelab)
2. **デバイスを接続**: [DEVICE-CONNECTION.md](DEVICE-CONNECTION.md)
3. **コード署名をセットアップ**: [APPLE-DEVELOPER.md](APPLE-DEVELOPER.md)
4. **アプリを作成**: 開発を始めましょう！

## リソース

- [Flutter公式ドキュメント](https://flutter.dev/docs)
- [Flutterサンプル](https://flutter.github.io/samples/)
- [iOS開発](https://developer.apple.com/ios/)
- [Xcodeドキュメント](https://developer.apple.com/xcode/)

## ヘルプが必要な場合

- [TROUBLESHOOTING.md](TROUBLESHOOTING.md)を確認
- インストールログを確認: `cat logs/setup-*.log`
- [Flutter issues](https://github.com/flutter/flutter/issues)を検索
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)で質問
- このリポジトリでIssueを作成
