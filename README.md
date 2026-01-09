# Flutter iOS 開発環境セットアップ

macOS上でFlutter iOS開発環境を自動構築するスクリプト集です。

## 特徴

- Flutter SDK、Xcode、CocoaPodsの自動インストール
- 中断・再開可能（完了済みステップをスキップ）
- 詳細なログとエラーハンドリング
- カスタマイズ可能な設定ファイル
- Git管理対応（チームで共有可能）

## 必要な環境

- macOS 12.0以降（Apple Silicon / Intel 両対応）
- 20GB以上の空きディスク容量
- インターネット接続
- 管理者権限（sudo コマンド用）

## クイックスタート

```bash
# リポジトリをクローン
git clone <your-repo-url> flutter-ios-setup
cd flutter-ios-setup

# セットアップを実行
./setup.sh
```

スクリプトは以下を実行します：
1. システム要件のチェック
2. Homebrewのインストール・設定
3. Xcodeのセットアップ（App Storeからインストール）
4. Flutter SDKのインストール
5. シェル環境の設定
6. CocoaPodsとiOS開発ツールのインストール
7. テストプロジェクトの作成（オプション）

## 設定のカスタマイズ

`config/config.sh`を編集してカスタマイズ：
- Flutterインストール先ディレクトリ
- テストプロジェクトの設定
- コンポーネントの有効/無効

## 検証

```bash
# 検証スクリプトを実行
./scripts/verify.sh

# または手動で確認
flutter doctor -v
```

## ドキュメント

- [セットアップガイド](docs/SETUP-GUIDE.md) - 詳細な手順
- [実機接続](docs/DEVICE-CONNECTION.md) - iPhone/iPad接続方法
- [Apple Developer設定](docs/APPLE-DEVELOPER.md) - 開発者アカウント設定
- [トラブルシューティング](docs/TROUBLESHOOTING.md) - よくある問題と解決策
- [Webアプリ開発者向けガイド](docs/WEB-TO-MOBILE.md) - Flutter/モバイル用語集

## プロジェクト構造

```
flutter-ios-setup/
├── setup.sh              # メインセットアップスクリプト
├── config/
│   └── config.example.sh # 設定ファイルテンプレート
├── scripts/
│   ├── verify.sh         # 検証スクリプト
│   └── lib/              # ユーティリティライブラリ
├── docs/                 # ドキュメント
└── logs/                 # インストールログ
```

## コントリビューション

[CONTRIBUTING.md](docs/CONTRIBUTING.md)を参照してください。

## ライセンス

MIT License - [LICENSE](LICENSE)を参照
