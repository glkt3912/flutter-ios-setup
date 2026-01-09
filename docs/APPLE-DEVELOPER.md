# Apple Developerアカウント設定ガイド

iOSアプリ開発のためのApple Developerアカウント設定とコード署名のガイドです。

## アカウントタイプの概要

### 無料Apple IDアカウント

**費用**: 無料
**適している人**: 学習、個人プロジェクト、自分のデバイスでのテスト

**できること**:
- 自分のデバイスでアプリをテスト（各デバイスタイプで最大3台）
- アプリは7日で期限切れ（再インストールが必要）
- App Storeへの配布は不可
- TestFlightは利用不可
- 基本的なアプリサービスのみ

**制限事項**:
- 各デバイスタイプで最大3台（iPhone 3台、iPad 3台など）
- 7日ごとにアプリを再インストールする必要がある
- プッシュ通知、アプリ内課金などは使用不可
- 他の人に配布できない

### Apple Developer Program

**費用**: 年間$99（米ドル）
**適している人**: App Store配布、プロフェッショナル開発

**できること**:
- 無制限のデバイステスト
- アプリの期限切れなし
- App Storeへの配布
- TestFlight（最大10,000人のベータテスター）
- すべてのアプリ機能とサービス
- アプリアナリティクス
- ベータ版OSへのアクセス

**必要な場面**:
- App Storeへの公開
- 高度なアプリ機能の使用
- 長期的な開発

### Apple Developer Enterprise Program

**費用**: 年間$299（米ドル）
**適している人**: 社内アプリ配布のみ（App Storeには出せない）

**注意**: 組織内でのアプリ配布専用です。一般向けApp Storeには公開できません。

## 無料アカウントで始める

### 1. XcodeにApple IDを追加

1. **Xcode**を開く
2. **Settings**（または古いバージョンでは**Preferences**）へ
3. **Accounts**タブをクリック
4. 左下の**+**ボタンをクリック
5. **Apple ID**を選択
6. Apple IDでサインイン
7. **次へ**をクリック

アカウントがリストに表示されます。

### 2. コード署名を設定（無料アカウント）

1. Flutter プロジェクトをXcodeで開く:
   ```bash
   cd your_flutter_project
   open ios/Runner.xcworkspace
   ```

2. プロジェクトナビゲータ（左サイドバー）で**Runner**をクリック

3. **Runner**ターゲット（TARGETSの下）を選択

4. **Signing & Capabilities**タブへ

5. **Signing**の下で**"Automatically manage signing"**にチェック

6. **Team**で自分のApple IDを選択

7. Xcodeが自動的に以下を行います:
   - 開発証明書の作成
   - プロビジョニングプロファイルの生成
   - Bundle Identifierの設定

**重要**: Bundle Identifierにはチーム IDが追加されます。
例: `com.example.app` → `com.example.app.TEAM123`

### 3. デバイスで実行

```bash
flutter run
```

またはXcodeで: Product > Run（Cmd+R）

**初回実行時**: Xcodeがデバイスの登録を求める場合があります。**登録**をクリックして完了を待ってください。

## 有料Developer Programへのアップグレード

### メリット

- 7日の期限切れなし
- 無制限のデバイス
- App Store配布
- TestFlightベータテスト
- プッシュ通知、アプリ内課金など

### 登録プロセス

1. [developer.apple.com/programs/enroll](https://developer.apple.com/programs/enroll/)へ
2. **Start Your Enrollment**をクリック
3. Apple IDでサインイン
4. Apple Developer Agreementを確認
5. エンティティタイプを選択（個人または組織）
6. 個人/会社情報を入力
7. メンバーシップを購入（$99/年）

**処理時間**: 通常は即時ですが、確認に最大48時間かかる場合があります。

### 登録後

1. Xcodeで**Settings** > **Accounts**へ
2. Apple IDを選択
3. **Download Manual Profiles**をクリック
4. アカウントタイプが「Apple Developer Program」に更新されます

## コード署名の概念

### コード署名とは？

コード署名は以下を証明します：
1. アプリが既知の開発者（あなた）からのものであること
2. 署名後にアプリが変更されていないこと
3. アプリが特定のデバイスで実行できること

### 署名の構成要素

**開発証明書**:
- あなたを開発者として識別
- Keychainに保存
- 開発中のアプリ署名に使用

**プロビジョニングプロファイル**:
- 証明書、App ID、デバイスをリンク
- 特定のデバイスでアプリの実行を許可
- 開発用、配布用などで異なるプロファイル

**Bundle Identifier**:
- アプリの一意の識別子
- 形式: `com.company.appname`
- App Store全体で一意である必要がある

### 自動 vs 手動署名

**自動署名**（初心者におすすめ）:
- Xcodeが証明書とプロファイルを管理
- 更新を自動処理
- 最もシンプルなアプローチ

**手動署名**（上級者向け）:
- 自分で証明書とプロファイルを管理
- より細かい制御が可能
- 複雑なセットアップ（CI/CD、複数チームなど）で必要

## よくあるコード署名の問題

### 「Bundle identifierの登録に失敗しました」

**問題**: Bundle IDが既に使用されているか、無効です。

**解決策**:
1. Xcodeで Bundle Identifierを変更:
   - Runnerターゲット > General > Bundle Identifier
2. 逆ドメイン表記を使用: `com.yourname.appname`
3. 一意にする（必要に応じて数字を追加）: `com.yourname.myapp2`

### 「署名証明書が見つかりません」

**問題**: Keychainに有効な証明書がありません。

**解決策**:
1. 「Automatically manage signing」を有効化
2. チームを選択
3. Xcodeが自動的に証明書を作成

それでもダメな場合:
1. Xcode > Settings > Accounts
2. Apple IDを選択
3. 「Manage Certificates」をクリック
4. 「+」 > 「Apple Development」をクリック

### 「プロビジョニングプロファイルが一致しません」

**解決策**:
1. ビルドフォルダをクリーン: Product > Clean Build Folder（Cmd+Shift+K）
2. Derived Dataを削除:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. プロジェクトを再ビルド

### 「証明書の生成数が上限に達しました」

**問題**: 作成した証明書が多すぎます（アカウントタイプごとに上限あり）。

**解決策**:
1. [developer.apple.com/account/resources/certificates](https://developer.apple.com/account/resources/certificates)へ
2. 古い/未使用の証明書を取り消す
3. Xcodeで新しい証明書を作成

## TestFlight（有料アカウントのみ）

TestFlightを使用すると、ベータ版をテスターに配布できます。

### セットアップ

1. Xcodeでアプリをアーカイブ:
   - Product > Archive
2. 「Distribute App」をクリック
3. 「TestFlight & App Store」を選択
4. プロンプトに従う
5. App Store Connectにアップロード

### テスターの招待

1. [appstoreconnect.apple.com](https://appstoreconnect.apple.com)へ
2. アプリを選択
3. TestFlightタブへ
4. 内部テスターを追加（チーム、最大100人）
5. 外部テスターを追加（一般、最大10,000人）

## ベストプラクティス

1. **無料アカウントから始める** - 支払う前に学習とテスト
2. **自動署名を使用** - 特定のニーズがない限り
3. **Bundle IDを一貫させる** - App Store提出後は変更しない
4. **証明書をバックアップ** - Keychainからエクスポート（ファイル > 項目をエクスポート）
5. **一意のBundle IDを使用** - 逆ドメイン表記に従う

## リソース

- [Apple Developer Portal](https://developer.apple.com)
- [App Store Connect](https://appstoreconnect.apple.com)
- [コード署名ガイド](https://developer.apple.com/support/code-signing/)
- [TestFlightドキュメント](https://developer.apple.com/testflight/)

## 次のステップ

- iOSデバイスを接続: [DEVICE-CONNECTION.md](DEVICE-CONNECTION.md)
- 初めてのアプリをデバイスにデプロイ
- App Store提出プロセスについて学ぶ
