# iOS実機接続ガイド

Flutter開発のためにiPhoneやiPadを接続する手順を説明します。

## 前提条件

- iOS 16以降のiOSデバイス（iPhoneまたはiPad）
- データ転送可能なUSB/USB-Cケーブル
- Flutter開発環境がインストール済みのMac

## ステップ1: Developerモードを有効化（iOS 16以降必須）

iOS 16以降では、Developerモードの有効化が必須です。

1. デバイスをMacに接続
2. デバイスで：**設定** > **プライバシーとセキュリティ** > **Developerモード**
3. **Developerモード**をオンに切り替え
4. 再起動を求められたら**再起動**をタップ
5. 再起動後、**オンにする**をタップして確認

**注意**: 設定にDeveloperモードが表示されない場合は、まずデバイスを接続してFlutterアプリを実行してみてください。

## ステップ2: このコンピュータを信頼

1. USB/USB-Cケーブルでデバイスを接続
2. デバイスのロックを解除
3. 「このコンピュータを信頼しますか？」というプロンプトが表示される
4. **信頼**をタップ
5. デバイスのパスコードを入力

## ステップ3: Xcodeでデバイス接続を確認

1. Xcodeを開く
2. **Window** > **Devices and Simulators**（または`Cmd+Shift+2`）
3. 左サイドバーにデバイスが表示されることを確認
4. 以下が表示されていることを確認：
   - デバイス名
   - iOSバージョン
   - ステータス：「準備完了」（緑のドット）

## ステップ4: Flutterがデバイスを認識しているか確認

ターミナルを開いて以下を実行：

```bash
flutter devices
```

期待される出力：

```
iPhone (mobile) • 00008030-XXXXXXXXXXXX • ios • iOS 18.2
iPad (mobile)   • 00008110-XXXXXXXXXXXX • ios • iOS 18.2
```

## ステップ5: 初めてのアプリ実行

```bash
cd your_flutter_project
flutter run
```

Flutterは以下を実行します：
1. アプリをビルド
2. デバイスにインストール
3. アプリを起動

**初回は5〜10分かかる場合があります**（すべての依存関係をビルドするため）。

## トラブルシューティング

### `flutter devices`でデバイスが表示されない

**解決策1: ケーブルを確認**
- データ転送可能なケーブルを使用（充電専用は不可）
- 別のUSBポートを試す
- 別のケーブルを試す

**解決策2: すべて再起動**
```bash
# デバイスを取り外す
# Xcodeを完全に終了
killall Xcode

# サービスを再起動
sudo killall -9 usbmuxd

# デバイスを再接続
```

**解決策3: libimobiledeviceを更新**
```bash
brew uninstall --ignore-dependencies libimobiledevice
brew install --HEAD libimobiledevice
```

### 「デバイスの準備に失敗しました」

これは通常、Developerモードが有効になっていないことを意味します。

1. 設定 > プライバシーとセキュリティ > Developerモードを確認
2. すでに有効の場合は、オフにしてから再度オンにする
3. デバイスを再起動
4. Macに再接続

### 「コード署名が必要です」

Xcodeでコード署名を設定する必要があります。[APPLE-DEVELOPER.md](APPLE-DEVELOPER.md)を参照してください。

### デバイスが「利用できません」と表示される

- デバイスのロックが解除されていることを確認
- iOSバージョンがXcodeバージョンと互換性があることを確認
- 必要に応じてXcodeを更新

### 「'device'という名前のオプションが見つかりません」

Flutterを更新してください：
```bash
flutter upgrade
```

## 複数デバイスの使用

複数のデバイスが接続されている場合：

```bash
# すべてのデバイスをリスト表示
flutter devices

# 特定のデバイスで実行
flutter run -d <device-id>

# 例
flutter run -d 00008030-001234567890000A
```

## ワイヤレスデバッグ（iOS 17以降）

ケーブルで一度ペアリングした後、ワイヤレスデバッグを有効化できます：

1. Xcode: Window > Devices and Simulators
2. デバイスを選択
3. **「ネットワーク経由で接続」**にチェック
4. デバイスにネットワークアイコンが表示される

これでケーブルを外してワイヤレスでデプロイできます。

## ベストプラクティス

- 開発中はデバイスのロックを解除したままにする
- 自動ロックを一時的に無効化：設定 > 画面表示と明るさ > 自動ロック > なし
- デバイスを充電したままにする（開発はバッテリーを消耗します）
- 接続問題を避けるため、高品質なケーブルを使用

## 次のステップ

- Apple Developerアカウント設定: [APPLE-DEVELOPER.md](APPLE-DEVELOPER.md)
- デプロイ用のコード署名設定
- TestFlightによるベータテストについて学ぶ
