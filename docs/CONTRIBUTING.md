# コントリビューションガイド

Flutter iOS Setupへのコントリビューションに興味を持っていただきありがとうございます！

## コントリビューション方法

### 問題の報告

バグを発見したり、機能リクエストがある場合は、以下の情報を含めてIssueを作成してください：

- **macOSバージョン**とアーキテクチャ（Intel/Apple Silicon）
- **エラーメッセージ**（完全な出力）
- **再現手順**
- **期待される動作と実際の動作**
- **ログファイル**（`logs/`ディレクトリから）

### 改善提案

以下のような提案を歓迎します：
- より良いエラーメッセージ
- 追加のチェックと検証
- ドキュメントの改善
- 新機能

### コードコントリビューション

1. **リポジトリをフォーク**
2. **フィーチャーブランチを作成**：
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **変更を加える**
4. **徹底的にテスト**（可能であればクリーンなmacOSインストールで）
5. **明確なメッセージでコミット**：
   ```bash
   git commit -m "feat: add XYZ feature"
   ```
6. **フォークにプッシュ**：
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Pull Requestを作成**

## 開発ガイドライン

### コードスタイル

- Bashのベストプラクティスを使用（shellcheck準拠）
- 既存のコード構造に従う
- 複雑なロジックにはコメントを追加
- 意味のある変数名を使用

### テスト

以下の環境で変更をテスト：
- **IntelとApple Silicon両方のMac**（可能であれば）
- **クリーンインストール**（既存のFlutter/Xcodeなし）
- **既存インストール**（再開機能が動作することを確認）

### ドキュメント

- `docs/`ディレクトリの関連ドキュメントを更新
- 新しい問題のトラブルシューティングエントリを追加
- 機能を追加する場合はREADMEを更新

### コミットメッセージフォーマット

[Conventional Commits](https://www.conventionalcommits.org/)に従ってください：

- `feat:` - 新機能
- `fix:` - バグ修正
- `docs:` - ドキュメントのみ
- `refactor:` - コードのリファクタリング
- `test:` - テストの追加
- `chore:` - メンテナンスタスク

例：
```
feat: add support for Android setup
fix: resolve CocoaPods installation on Apple Silicon
docs: improve device connection guide
refactor: modularize installation functions
```

## プロジェクト構造

```
flutter-ios-setup/
├── setup.sh              # メインスクリプト
├── config/
│   └── config.example.sh # 設定テンプレート
├── scripts/
│   ├── verify.sh         # 検証スクリプト
│   └── lib/              # 共有ライブラリ
│       ├── logger.sh     # ログ関数
│       ├── utils.sh      # ユーティリティ関数
│       └── checks.sh     # システムチェック
├── docs/                 # ドキュメント
│   ├── DEVICE-CONNECTION.md
│   ├── APPLE-DEVELOPER.md
│   ├── TROUBLESHOOTING.md
│   └── CONTRIBUTING.md
├── logs/                 # インストールログ（git除外）
└── state/                # 状態ファイル（git除外）
```

## 新機能の追加

### 新しいインストールステップの追加

1. `setup.sh`に関数を追加：
   ```bash
   install_new_tool() {
       local step_name="new_tool"

       if is_step_completed "$step_name"; then
           log_info "Skipping: New Tool (already installed)"
           return 0
       fi

       log_step X $TOTAL_STEPS "Installing New Tool"

       # インストールロジックをここに

       mark_step_completed "$step_name"
   }
   ```

2. `main()`関数で呼び出す
3. `TOTAL_STEPS`定数を更新
4. `scripts/lib/checks.sh`にチェック関数を追加
5. ドキュメントを更新

### 新しい設定オプションの追加

1. `config/config.example.sh`に追加
2. コメントでオプションを説明
3. 関連するインストール関数で使用
4. ユーザー向けの場合はREADMEを更新

### 新しいユーティリティ関数の追加

適切なライブラリに追加：
- **ログ**: `scripts/lib/logger.sh`
- **システムチェック**: `scripts/lib/checks.sh`
- **ユーティリティ**: `scripts/lib/utils.sh`

## Pull Requestプロセス

1. **説明**: PRが何をするか明確に説明
2. **テスト**: 変更をテストしたことを確認
3. **ドキュメント**: 必要に応じてドキュメントを更新
4. **レビュー**: フィードバックに迅速に対応
5. **マージ**: 承認されたらメンテナがマージ

## 質問がある場合

- `question`ラベルでIssueを作成
- Pull Requestで議論
- 既存のIssue/PRを先に確認

## 行動規範

- 敬意を持ち、包括的に
- 建設的なフィードバックを提供
- 他の人が学び成長するのを助ける
- プロジェクトにとって最善のことに焦点を当てる

## ライセンス

コントリビューションすることで、あなたのコントリビューションがMITライセンスの下でライセンスされることに同意したことになります。
