# iOSシミュレータ & Flutter開発コマンドガイド

Flutter iOS開発で使用するシミュレータの管理方法と、`flutter run`で利用できる便利なキーコマンドの完全ガイドです。

---

## 目次

1. [iOSシミュレータの管理](#iosシミュレータの管理)
2. [Flutterデバイスの確認](#flutterデバイスの確認)
3. [Flutter Runキーコマンド](#flutter-runキーコマンド)
4. [実践的な開発フロー](#実践的な開発フロー)

---

## iOSシミュレータの管理

### シミュレータランタイムのインストール

初回セットアップ時、またはXcodeアップデート後にiOSシミュレータランタイムをインストールする必要があります。

**方法1: Xcode GUI（推奨）**

```bash
# Xcodeを起動
open /Applications/Xcode.app
```

1. メニューバー → **Settings...** (または **Preferences...**)
2. **Platforms** タブをクリック
3. **iOS** の横にある **GET** ボタンをクリック
4. ダウンロード完了を待つ（数GB、10-20分程度）

**方法2: コマンドライン**

```bash
# 最新のiOSプラットフォームをダウンロード
xcodebuild -downloadPlatform iOS
```

### 利用可能なシミュレータの確認

```bash
# すべてのシミュレータデバイスを表示
xcrun simctl list devices

# 起動可能なデバイスのみ表示
xcrun simctl list devices available

# iPhoneのみ表示
xcrun simctl list devices available | grep iPhone
```

**出力例:**
```
== Devices ==
-- iOS 26.2 --
    iPhone 17 Pro (246348E1-4EDC-4CC4-A65A-EE2F63071496) (Shutdown)
    iPhone 17 Pro Max (523DF2FF-C00B-4181-8D5E-9F49FBFE5880) (Shutdown)
    iPhone Air (55DCF710-6B32-48B2-A1A4-D227412F31C5) (Shutdown)
    iPhone 17 (445A3561-2B8D-48F7-A2E4-F8B353905996) (Shutdown)
    iPhone 16e (32360D6C-F669-4E59-AAB2-56E5B8C50DBC) (Shutdown)
```

### シミュレータの起動

**方法1: Simulatorアプリを起動（推奨）**

```bash
# デフォルトのシミュレータを起動
open -a Simulator
```

Simulatorアプリが起動したら、メニューから任意のデバイスを選択可能：
- **File** → **Open Simulator** → デバイスを選択

**方法2: 特定のデバイスを起動**

```bash
# デバイスID（UUID）を指定して起動
xcrun simctl boot 32360D6C-F669-4E59-AAB2-56E5B8C50DBC

# または、起動後にSimulatorアプリで表示
open -a Simulator
```

**方法3: デバイス名で起動**

```bash
# デバイス名を指定（スペースはエスケープ）
xcrun simctl boot "iPhone 16e"
open -a Simulator
```

### シミュレータの操作

```bash
# シミュレータをシャットダウン
xcrun simctl shutdown <device-id>

# すべてのシミュレータをシャットダウン
xcrun simctl shutdown all

# シミュレータをリセット（データ削除）
xcrun simctl erase <device-id>

# シミュレータを削除
xcrun simctl delete <device-id>

# 新しいシミュレータを作成
xcrun simctl create "My iPhone" "iPhone 16e" "iOS 26.2"
```

---

## Flutterデバイスの確認

### 接続されているデバイスの確認

```bash
# 利用可能なデバイス一覧
flutter devices
```

**出力例:**
```
Found 2 connected devices:
  iPhone 16e (mobile) • 32360D6C-F669-4E59-AAB2-56E5B8C50DBC • ios          • com.apple.CoreSimulator.SimRuntime.iOS-26-2 (simulator)
  macOS (desktop)     • macos                                • darwin-arm64 • macOS 15.7.3 24G419 darwin-arm64
```

### 特定のデバイスで実行

```bash
# デバイスIDを指定
flutter run -d 32360D6C-F669-4E59-AAB2-56E5B8C50DBC

# デバイス名を指定（部分一致）
flutter run -d iPhone

# macOSで実行（デスクトップアプリとして）
flutter run -d macos
```

### エミュレータ一覧の確認

```bash
# 利用可能なエミュレータ一覧
flutter emulators

# エミュレータを起動
flutter emulators --launch <emulator-id>
```

---

## Flutter Runキーコマンド

`flutter run` でアプリを起動中に、ターミナルで以下のキーを押すことで様々な操作が可能です。

### 🔥 開発の基本コマンド

| キー | コマンド | 説明 |
|------|----------|------|
| `r` | **Hot Reload** | コード変更を即座に反映（状態を保持）。最も使用頻度が高い |
| `R` | **Hot Restart** | アプリ全体を再起動（状態はリセット） |
| `q` | **Quit** | アプリを終了 |
| `d` | **Detach** | flutter runを終了するがアプリは動作継続 |
| `h` | **Help** | コマンド一覧を表示 |
| `c` | **Clear** | コンソール画面をクリア |

#### Hot Reload vs Hot Restart

**Hot Reload (`r`):**
- 変更したコードのみを再読み込み
- アプリの状態（変数の値、スクロール位置など）を保持
- 超高速（1-3秒）
- **使用例**: UIの色、テキスト、レイアウトの変更

**Hot Restart (`R`):**
- アプリ全体を再起動
- すべての状態がリセット
- 通常の再起動より高速（5-10秒）
- **使用例**: `initState`、`const`、クラス構造の変更

### 📸 デバッグ・検証コマンド

| キー | コマンド | 説明 |
|------|----------|------|
| `s` | **Screenshot** | スクリーンショットを `flutter.png` として保存 |
| `v` | **DevTools** | Flutter DevToolsをブラウザで開く |
| `g` | **Generators** | コード生成ツール（build_runner等）を実行 |

**DevTools (`v`) でできること:**
- パフォーマンス分析
- メモリ使用量確認
- ネットワークリクエスト監視
- ウィジェットツリー表示
- ログ確認

### 🔍 ウィジェット階層デバッグ

| キー | コマンド | 説明 |
|------|----------|------|
| `w` | **Widget Hierarchy** | ウィジェットツリーをコンソールに出力 (`debugDumpApp`) |
| `t` | **Rendering Tree** | レンダリングツリーを出力 (`debugDumpRenderTree`) |
| `L` | **Layer Tree** | レイヤーツリーを出力 (`debugDumpLayerTree`) |
| `f` | **Focus Tree** | フォーカスツリーを出力 (`debugDumpFocusTree`) |
| `S` | **Accessibility (順方向)** | アクセシビリティツリーを順方向で出力 |
| `U` | **Accessibility (逆方向)** | アクセシビリティツリーを逆方向で出力 |

**使い分け:**
- `w`: UI構造の確認、ウィジェット階層のデバッグ
- `t`: レイアウト問題の調査（サイズ、位置）
- `L`: 描画パフォーマンスの調査
- `f`: キーボードフォーカスのデバッグ
- `S`/`U`: スクリーンリーダー対応の確認

### 🎨 ビジュアルデバッグ

| キー | コマンド | 説明 |
|------|----------|------|
| `i` | **Widget Inspector** | 画面上でウィジェットをタップして情報確認 |
| `p` | **Construction Lines** | ウィジェットの境界線を表示（超便利！） |
| `I` | **Oversized Images** | 大きすぎる画像を反転表示 |

**Widget Inspector (`i`):**
1. `i` を押してインスペクターモードをON
2. シミュレータ上でウィジェットをタップ
3. サイズ、位置、プロパティが表示される
4. 再度 `i` でOFF

**Construction Lines (`p`):**
```
┌─────────────────┐
│  Container      │  ← 境界線が表示される
│  ┌───────────┐  │
│  │  Text     │  │  ← 各ウィジェットのサイズが視覚化
│  └───────────┘  │
└─────────────────┘
```

### 🌓 プラットフォームシミュレーション

| キー | コマンド | 説明 |
|------|----------|------|
| `o` | **Operating System** | iOS/Android間の動作を切り替え |
| `b` | **Brightness** | ダークモード ⇔ ライトモード切り替え |

**OS切り替え (`o`):**
- プラットフォーム固有のコードをテスト
- `Platform.isIOS` / `Platform.isAndroid` の動作確認
- 注意: 完全なエミュレートではなく、一部の動作のみ

**ダークモード切り替え (`b`):**
- アプリのテーマ対応を即座に確認
- ThemeDataの動作確認に便利

### ⚡ パフォーマンス監視

| キー | コマンド | 説明 |
|------|----------|------|
| `P` | **Performance Overlay** | FPS（フレームレート）を画面に表示 |
| `a` | **Widget Build Events** | すべてのウィジェットビルドをプロファイリング |

**Performance Overlay (`P`):**
```
画面上部に2つのグラフが表示される:
- 上: GPU レンダリング（16ms以下が理想）
- 下: UI スレッド（16ms以下が理想）

目標: 60FPS = 各フレーム16.67ms以内
```

**グラフの見方:**
- 緑のバー: 正常（16ms以内）
- 赤いバー: フレーム落ち（16ms超過）

---

## 実践的な開発フロー

### 基本的な開発サイクル

```bash
# 1. シミュレータを起動
open -a Simulator

# 2. Flutterアプリを実行
flutter run
```

**コード編集ループ:**
```
1. コードを編集して保存
   ↓
2. ターミナルで `r` を押す
   ↓
3. 1-3秒でシミュレータに反映
   ↓
4. 動作確認
   ↓
5. 繰り返し
```

### レイアウトデバッグ

```bash
# 起動後、以下のキーを順番に試す
p  # 境界線を表示してレイアウト確認
i  # ウィジェットインスペクターをON
   # シミュレータで問題のウィジェットをタップ
w  # 必要に応じてウィジェットツリーを出力
```

### テーマ・デザイン確認

```bash
# ダークモード/ライトモードを切り替えながらデザイン確認
b  # ライトモード → ダークモード
   # 確認
b  # ダークモード → ライトモード
```

### パフォーマンスチェック

```bash
# 1. パフォーマンスオーバーレイを表示
P

# 2. アプリを操作しながらFPSを確認
#    - スクロール
#    - アニメーション
#    - 画面遷移

# 3. 赤いバー（フレーム落ち）が出たら
a  # ウィジェットビルドのプロファイリングをON
v  # DevToolsでパフォーマンスタブを開く
```

### アクセシビリティ確認

```bash
# スクリーンリーダーの情報を確認
S  # アクセシビリティツリーを出力

# 実際のスクリーンリーダーで確認（推奨）
# シミュレータの設定 → アクセシビリティ → VoiceOver をON
```

### スクリーンショット撮影

```bash
# ドキュメント用のスクリーンショットを撮影
s  # flutter.png として保存される

# 複数の画面を撮影する場合
s  # 1枚目
# 画面を切り替え
s  # 2枚目（上書きされるので注意！）
# 必要に応じてファイルをリネーム
```

### デバッグ情報の収集

```bash
# 問題が発生した場合
w  # ウィジェットツリーを出力
t  # レンダリングツリーを出力
v  # DevToolsでログを確認
```

---

## トラブルシューティング

### シミュレータが表示されない

**問題:** `flutter devices` でシミュレータが表示されない

**解決策:**
```bash
# 1. シミュレータを起動
open -a Simulator

# 2. 5秒待ってから確認
flutter devices
```

### シミュレータランタイムがない

**問題:** `Unable to find any emulator sources`

**解決策:**
```bash
# Xcodeを開いてiOSプラットフォームをインストール
open /Applications/Xcode.app
# Settings → Platforms → iOS → GET
```

### Hot Reloadが動作しない

**問題:** `r` を押しても変更が反映されない

**原因と解決策:**
- `const` コンストラクタの変更 → `R` でHot Restart
- `initState()` の変更 → `R` でHot Restart
- クラス構造の変更 → `R` でHot Restart
- それでも動かない場合 → `q` で終了して再実行

### シミュレータが重い

**解決策:**
```bash
# 1. 不要なアプリを終了
# 2. シミュレータの解像度を下げる
#    Hardware → Device → iPhone SE (小さいデバイス)
# 3. Xcodeを終了
# 4. シミュレータをリセット
xcrun simctl erase all
```

---

## 参考資料

### 公式ドキュメント

- [Flutter DevTools](https://docs.flutter.dev/tools/devtools/overview)
- [iOS Simulator Guide](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device)
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)

### 関連ドキュメント

- [SETUP-GUIDE.md](SETUP-GUIDE.md) - 環境セットアップ手順
- [DEVICE-CONNECTION.md](DEVICE-CONNECTION.md) - 実機接続方法
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - トラブルシューティング

---

## まとめ

### 最も使うコマンドTop 5

1. **`r`** - Hot Reload（ほぼ毎分使う）
2. **`p`** - 境界線表示（レイアウトデバッグ）
3. **`b`** - ダークモード切り替え（テーマ確認）
4. **`i`** - ウィジェットインスペクター（詳細確認）
5. **`P`** - パフォーマンス表示（最適化時）

### 開発効率を上げるコツ

1. **Hot Reloadを活用** - アプリを再起動せずにコード変更を確認
2. **Construction Lines (`p`)** - レイアウト問題の早期発見
3. **DevTools (`v`)** - パフォーマンス問題の特定
4. **ダークモード確認 (`b`)** - 両テーマで見た目をチェック
5. **キーボードショートカットを覚える** - マウス操作より圧倒的に速い

Happy Flutter Development! 🚀
