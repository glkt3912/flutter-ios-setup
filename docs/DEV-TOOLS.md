# 開発便利機能ガイド (Development Tools Guide)

Flutter iOS開発環境に含まれる開発便利機能の完全ガイドです。

---

## 目次

1. [概要](#概要)
2. [コード品質ツール](#コード品質ツール)
3. [VSCode設定](#vscode設定)
4. [Flutterコマンドエイリアス](#flutterコマンドエイリアス)
5. [Gitフック](#gitフック)
6. [カスタマイズ](#カスタマイズ)
7. [トラブルシューティング](#トラブルシューティング)

---

## 概要

flutter-ios-setupには、Flutter開発の効率を向上させる4つの便利機能が含まれています：

| 機能 | 説明 | デフォルト |
|------|------|----------|
| **コード品質ツール** | 強化されたLint設定 | 有効 |
| **VSCode設定** | ワークスペース設定、拡張機能、デバッグ構成 | 有効 |
| **コマンドエイリアス** | よく使うFlutterコマンドの短縮形 | 有効 |
| **Gitフック** | コミット前の自動コード整形と品質チェック | 有効 |

すべての機能は `config/config.sh` で個別にON/OFF可能です。

---

## コード品質ツール

### 概要

強化された `analysis_options.yaml` が自動的にFlutterプロジェクトに適用されます。

### 含まれるLintルール

**スタイルルール:**
- `prefer_single_quotes: true` - シングルクォート使用
- `always_declare_return_types: true` - 戻り値の型を明示
- `prefer_const_constructors: true` - constコンストラクタの使用推奨
- `prefer_final_fields: true` - finalフィールドの使用推奨

**エラー防止:**
- `avoid_print: true` - 本番コードでのprintを警告
- `use_build_context_synchronously: true` - 非同期でのBuildContext誤用を検出
- `avoid_dynamic_calls: true` - dynamic型の呼び出しを警告

**ベストプラクティス:**
- `use_key_in_widget_constructors: true` - ウィジェットにkeyを使用
- `prefer_is_empty: true` - `length == 0` より `isEmpty` を推奨

### 使い方

```bash
# プロジェクトディレクトリで実行
cd flutter_test_app
flutter analyze

# 問題を確認
flutter analyze --verbose

# 特定のファイルのみ
flutter analyze lib/main.dart
```

### カスタマイズ

`analysis_options.yaml` を直接編集して、ルールをカスタマイズできます：

```yaml
linter:
  rules:
    # ルールを無効化
    prefer_single_quotes: false

    # 新しいルールを追加
    avoid_catching_errors: true
```

---

## VSCode設定

### 概要

テストプロジェクトに `.vscode/` ディレクトリが自動作成され、以下のファイルが含まれます：

1. **settings.json** - ワークスペース設定
2. **extensions.json** - 推奨拡張機能
3. **launch.json** - デバッグ構成

### settings.json の機能

**自動フォーマット:**
```json
"editor.formatOnSave": true,
"editor.formatOnPaste": true
```
- ファイル保存時に自動整形
- ペースト時にも自動整形

**コードアクション:**
```json
"editor.codeActionsOnSave": {
  "source.fixAll": "explicit",
  "source.organizeImports": "explicit"
}
```
- import文の自動整理
- 修正可能な問題の自動修正

**Dart設定:**
```json
"dart.flutterSdkPath": "~/development/flutter",
"dart.lineLength": 80
```
- Flutter SDKパスの自動検出
- 80文字の行幅制限

### 推奨拡張機能

VSCodeを開くと、以下の拡張機能のインストールが推奨されます：

| 拡張機能 | 説明 |
|---------|------|
| **Dart** | Dart言語サポート（必須） |
| **Flutter** | Flutter開発サポート（必須） |
| **Error Lens** | エラーをコード内にインライン表示 |
| **Code Spell Checker** | スペルチェック |
| **Flutter Snippets** | Flutterコードスニペット |
| **Awesome Flutter Snippets** | さらに多くのスニペット |

### デバッグ構成

5つのデバッグ構成が利用可能：

1. **Flutter: Debug** - 通常のデバッグモード
2. **Flutter: Profile** - パフォーマンスプロファイリング
3. **Flutter: Release** - リリースビルド
4. **Flutter: Debug (iOS)** - iOS専用デバッグ
5. **Flutter: Debug (Simulator)** - シミュレータ専用

### VSCodeでプロジェクトを開く

```bash
# コマンドラインから
code flutter_test_app

# またはVSCodeから
# File > Open Folder... > flutter_test_appを選択
```

---

## Flutterコマンドエイリアス

### 概要

シェル設定ファイル（`.zshrc` または `.bashrc`）に便利なエイリアスが追加されます。

### 基本コマンド

| エイリアス | 実際のコマンド | 説明 |
|-----------|--------------|------|
| `fl` | `flutter` | Flutterコマンド |
| `flr` | `flutter run` | アプリ実行 |
| `flrd` | `flutter run -d` | デバイス指定実行 |
| `flb` | `flutter build` | ビルド |
| `flt` | `flutter test` | テスト実行 |
| `flc` | `flutter clean` | クリーン |
| `flpg` | `flutter pub get` | 依存関係取得 |
| `flpu` | `flutter pub upgrade` | 依存関係更新 |

### 開発・デバッグ

| エイリアス | 実際のコマンド | 説明 |
|-----------|--------------|------|
| `fld` | `flutter doctor -v` | 環境確認（詳細） |
| `fla` | `flutter analyze` | 静的解析 |
| `flf` | `dart format .` | コード整形 |
| `flfc` | `dart format --set-exit-if-changed .` | 整形チェック |
| `fldev` | `flutter devices` | デバイス一覧 |
| `fllog` | `flutter logs` | ログ表示 |

### iOS専用

| エイリアス | 実際のコマンド | 説明 |
|-----------|--------------|------|
| `flios` | `flutter run -d ios` | iOS実行 |
| `flsim` | `open -a Simulator` | シミュレータ起動 |
| `flbuildios` | `flutter build ios` | iOSビルド |
| `flbuildipa` | `flutter build ipa` | IPAファイル作成 |

### プロジェクト管理

| エイリアス | 実際のコマンド | 説明 |
|-----------|--------------|------|
| `flcreate` | `flutter create` | 新規プロジェクト作成 |
| `flupgrade` | `flutter upgrade` | Flutter更新 |
| `flchannel` | `flutter channel` | チャンネル確認 |
| `flconfig` | `flutter config` | 設定確認 |

### パフォーマンス

| エイリアス | 実際のコマンド | 説明 |
|-----------|--------------|------|
| `flprofile` | `flutter run --profile` | プロファイルモード |
| `flrelease` | `flutter run --release` | リリースモード |
| `fltrace` | `flutter run --trace-startup` | 起動トレース |

### クリーン・リセット

| エイリアス | 実際のコマンド | 説明 |
|-----------|--------------|------|
| `flcleanall` | `flutter clean && flutter pub get && cd ios && pod install && cd ..` | 完全クリーン |
| `flreset` | 完全リセット | Pods、symlinks、locksを削除して再構築 |

### 便利な関数

**fldoc** - flutter doctorの出力をクリップボードにコピー
```bash
fldoc
# 出力がクリップボードにコピーされます
```

**flnew** - 新規プロジェクト作成とディレクトリ移動
```bash
flnew my_app
# プロジェクトを作成して自動的にcdします
```

### エイリアスの有効化

```bash
# ターミナルを再起動、または
source ~/.zshrc

# エイリアス確認
type fl
# 出力: fl is an alias for flutter
```

---

## Gitフック

### 概要

pre-commitフックが自動的にインストールされ、コミット前に以下を実行します：

1. **Dartコード整形** - `dart format` で自動整形
2. **静的解析** - `flutter analyze` でエラー検出
3. **エラー時中断** - 問題があればコミット失敗

### フックの動作

```bash
# コミット実行時
git commit -m "Add new feature"

# フックが自動実行される：
# 🔍 Running pre-commit checks...
# 📝 Formatting Dart code...
#   → Formatted: lib/main.dart
#   ✓ Code formatting complete
# 🔎 Running static analysis...
#   ✓ Static analysis passed
# ✅ All pre-commit checks passed!
```

### フックをバイパス

緊急時や意図的にフックをスキップしたい場合：

```bash
git commit --no-verify -m "WIP: emergency fix"
```

**注意:** 通常は推奨されません。コード品質を保つためフックを有効にしておきましょう。

### フックの挙動

#### 成功時

```
🔍 Running pre-commit checks...
Found 3 Dart file(s) to check

📝 Formatting Dart code...
  ✓ All files already formatted

🔎 Running static analysis...
  ✓ Static analysis passed

✅ All pre-commit checks passed!

[feature/new-feature abc1234] Add new widget
 3 files changed, 45 insertions(+)
```

#### フォーマット修正時

```
🔍 Running pre-commit checks...
Found 2 Dart file(s) to check

📝 Formatting Dart code...
  → Formatted: lib/main.dart
  → Formatted: lib/widgets/custom_button.dart
  ✓ Code formatting complete

🔎 Running static analysis...
  ✓ Static analysis passed

✅ All pre-commit checks passed!

[feature/new-feature def5678] Add custom button
 2 files changed, 30 insertions(+)
```

#### エラー検出時

```
🔍 Running pre-commit checks...
Found 1 Dart file(s) to check

📝 Formatting Dart code...
  ✓ All files already formatted

🔎 Running static analysis...

Analyzing flutter_test_app...

  error • Undefined name 'widt' • lib/main.dart:45:18 • undefined_identifier

1 issue found.

✗ Static analysis found issues
Please fix the issues above before committing.

Tip: Run 'flutter analyze' to see all issues
Tip: To commit anyway, use: git commit --no-verify
```

### 厳格モードと寛容モード

**厳格モード（デフォルト）:**
```bash
# config/config.shで設定
GIT_HOOKS_STRICT=true
```
- 解析エラーがあるとコミット失敗
- コード品質を強制

**寛容モード:**
```bash
GIT_HOOKS_STRICT=false
```
- 警告のみ表示、コミットは成功
- 開発初期段階に便利

### フックの手動インストール

既存のプロジェクトにフックをインストール：

```bash
# プロジェクトディレクトリで
cp /Volumes/Dev-SSD/dev/flutter-ios-setup/templates/hooks/pre-commit .git/hooks/
chmod +x .git/hooks/pre-commit
```

---

## カスタマイズ

### 機能の有効/無効

`config/config.sh` を編集：

```bash
# コード品質ツール
SETUP_CODE_QUALITY_TOOLS=true  # false で無効化

# VSCode設定
SETUP_VSCODE_SETTINGS=true     # false で無効化

# エイリアス
SETUP_FLUTTER_ALIASES=true     # false で無効化

# Gitフック
SETUP_GIT_HOOKS=true            # false で無効化
GIT_HOOKS_STRICT=true           # false で寛容モード
```

変更後、`./setup.sh` を再実行してください。

### テンプレートのカスタマイズ

テンプレートファイルを直接編集できます：

```bash
# Lint設定
templates/analysis_options.yaml

# VSCode設定
templates/vscode/settings.json
templates/vscode/extensions.json
templates/vscode/launch.json

# エイリアス
templates/flutter_aliases.sh

# Gitフック
templates/hooks/pre-commit
```

編集後、セットアップを再実行するか、手動でファイルをコピーしてください。

### VSCode設定の上書き

プロジェクト固有の設定は `.vscode/settings.json` で直接編集：

```json
{
  "// カスタム設定を追加": "",
  "dart.lineLength": 120,
  "editor.rulers": [120]
}
```

---

## トラブルシューティング

### エイリアスが動作しない

**症状:** `fl` などのエイリアスが認識されない

**解決策:**
```bash
# シェル設定を再読み込み
source ~/.zshrc

# または新しいターミナルウィンドウを開く

# エイリアスが追加されているか確認
grep "Flutter Development Aliases" ~/.zshrc
```

### VSCodeでフォーマットが動作しない

**症状:** 保存時に自動整形されない

**解決策:**

1. **Dart拡張機能を確認:**
   ```
   VSCode > Extensions > "Dart" で検索 > インストール確認
   ```

2. **設定を確認:**
   ```json
   // .vscode/settings.jsonで
   "editor.formatOnSave": true
   ```

3. **Flutter SDKパスを確認:**
   ```json
   "dart.flutterSdkPath": "~/development/flutter"
   ```

4. **VSCode再起動:**
   ```
   Command + Q で完全終了 > 再起動
   ```

### Gitフックが実行されない

**症状:** コミット時にフックが動作しない

**解決策:**

1. **実行権限を確認:**
   ```bash
   ls -l .git/hooks/pre-commit
   # -rwxr-xr-x が表示されるはず

   # 権限がない場合
   chmod +x .git/hooks/pre-commit
   ```

2. **フックファイルの存在確認:**
   ```bash
   test -f .git/hooks/pre-commit && echo "存在する" || echo "存在しない"
   ```

3. **Gitリポジトリか確認:**
   ```bash
   test -d .git && echo "Gitリポジトリ" || echo "Gitリポジトリではない"
   ```

### flutter analyzeがエラーを出す

**症状:** Lint設定が厳しすぎる

**解決策:**

**一時的な回避:**
```bash
# --no-fatalでwarningsを無視
flutter analyze --no-fatal-warnings
```

**恒久的な解決:**
```yaml
# analysis_options.yamlでルールを調整
linter:
  rules:
    # 問題のあるルールを無効化
    prefer_single_quotes: false
```

### pre-commitフックが遅い

**症状:** コミットに時間がかかる

**原因:** `flutter analyze` が大きなプロジェクトで遅い

**解決策:**

1. **Podfile.lockなどを.gitignoreに追加:**
   ```bash
   echo "pubspec.lock" >> .gitignore
   ```

2. **フックを一時的にスキップ:**
   ```bash
   git commit --no-verify -m "message"
   ```

3. **寛容モードに変更:**
   ```bash
   # config/config.sh
   GIT_HOOKS_STRICT=false
   ```

### VSCodeが推奨拡張機能を表示しない

**症状:** 拡張機能のインストール促進が出ない

**解決策:**

1. **extensions.jsonを確認:**
   ```bash
   cat .vscode/extensions.json
   ```

2. **手動でインストール:**
   ```
   VSCode > Extensions > 以下を検索してインストール:
   - Dart
   - Flutter
   - Error Lens
   ```

3. **ワークスペースを閉じて再度開く:**
   ```
   File > Close Folder > File > Open Folder
   ```

---

## 関連ドキュメント

- [セットアップガイド](SETUP-GUIDE.md) - 初期環境構築
- [シミュレータ & 開発コマンドガイド](SIMULATOR-GUIDE.md) - シミュレータ管理
- [トラブルシューティング](TROUBLESHOOTING.md) - 一般的な問題
- [Firebase ガイド](FIREBASE-GUIDE.md) - バックエンド統合

---

## まとめ

開発便利機能により、以下のメリットがあります：

✅ **コード品質向上** - 自動Lintでバグを早期発見
✅ **開発効率化** - エイリアスでタイピング削減
✅ **VSCode最適化** - すぐに使える開発環境
✅ **自動品質チェック** - コミット前に問題を検出

すべての機能は任意で、プロジェクトに合わせてカスタマイズ可能です。

Happy Coding! 🚀
