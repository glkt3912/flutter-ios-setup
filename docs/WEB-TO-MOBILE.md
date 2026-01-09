# Webアプリ開発者のためのFlutter/モバイルアプリ用語集

Webアプリ開発の経験があるエンジニア向けに、Flutter及びモバイルアプリ開発特有の概念や用語を説明します。

## 目次

- [開発環境](#開発環境)
- [言語とフレームワーク](#言語とフレームワーク)
- [アーキテクチャとバックエンド](#アーキテクチャとバックエンド)
- [UI/UXの概念](#uiuxの概念)
- [ビルドとデプロイ](#ビルドとデプロイ)
- [コード署名とセキュリティ](#コード署名とセキュリティ)
- [デバイスとテスト](#デバイスとテスト)
- [パフォーマンス](#パフォーマンス)
- [配布とストア](#配布とストア)

---

## 開発環境

### Flutter SDK vs Node.js/npm

| Web開発 | Flutter開発 |
|---------|-------------|
| Node.js + npm/yarn | Flutter SDK + Dart SDK |
| package.json | pubspec.yaml |
| node_modules/ | .dart_tool/, .pub-cache/ |
| npm install | flutter pub get |
| npm run build | flutter build |

**Flutter SDK**は、Dart言語、ビルドツール、フレームワーク、開発ツールをすべて含む統合開発キットです。Node.jsのようにランタイムだけでなく、フレームワークとツールチェーン全体が含まれます。

### Xcode（iOS開発）

**Xcode**はAppleが提供する統合開発環境（IDE）で、iOSアプリ開発に必須です。

- **Web開発との違い**: ブラウザで動くWebアプリと異なり、iOSアプリはAppleの署名済みバイナリとして配布する必要があります
- **サイズ**: 約12-15GB（Web開発ツールより遥かに大きい）
- **含まれるもの**:
  - iOS SDK（iOSのAPI群）
  - iOSシミュレータ
  - ビルドツール
  - デバッグツール
  - インターフェースビルダー

### CocoaPods

**CocoaPods**はiOS/macOS向けの依存関係管理ツールです。

| Web開発 | iOS開発 |
|---------|---------|
| npm/yarn | CocoaPods |
| package.json | Podfile |
| package-lock.json | Podfile.lock |
| node_modules/ | Pods/ |

**使用場面**: Flutterプロジェクトでネイティブプラグインを使う場合、iOS側の依存関係をCocoaPodsで管理します。

```bash
# Webの場合
npm install

# Flutterの場合
flutter pub get          # Dart依存関係
cd ios && pod install    # iOS依存関係
```

---

## 言語とフレームワーク

### Dart言語

**Dart**はFlutterで使用されるプログラミング言語です。

**JavaScriptとの類似点**:
- C言語系の構文
- 非同期処理（async/await）
- クラスベースのオブジェクト指向
- 型推論

**JavaScriptとの違い**:
```javascript
// JavaScript
const greeting = "Hello";
let count = 0;

// Dart
final greeting = "Hello";  // 再代入不可（JavaScriptのconstに相当）
int count = 0;             // 型を明示（省略も可能）
```

**Null安全性**:
```dart
// Null許容型
String? name;  // nullを許容
name = null;   // OK

// Non-null型
String title;  // nullは許容されない
title = null;  // エラー
```

### Widget（ウィジェット）

**Widget**はFlutterのUI構築の基本単位です。Webでいうコンポーネントに相当しますが、より細かい粒度です。

| Web開発 | Flutter |
|---------|---------|
| HTMLタグ + CSSスタイル | Widget |
| `<div>`, `<button>`, `<img>` | Container, ElevatedButton, Image |
| Reactコンポーネント | StatelessWidget / StatefulWidget |

**すべてがWidget**: Flutterでは、レイアウト、スタイリング、アニメーションなど、すべてがWidgetとして表現されます。

```dart
// Webでいうと <div style="padding: 8px; background: blue;">
Container(
  padding: EdgeInsets.all(8.0),
  color: Colors.blue,
  child: Text('Hello'),
)
```

### StatelessWidget vs StatefulWidget

**StatelessWidget**: 状態を持たないWidget（Reactの関数コンポーネントに相当）

```dart
class Greeting extends StatelessWidget {
  final String name;
  Greeting({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name');
  }
}
```

**StatefulWidget**: 状態を持つWidget（Reactのクラスコンポーネント + useState）

```dart
class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () => setState(() { count++; }),
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

### Hot Reload（ホットリロード）

**Hot Reload**は、アプリを再起動せずにコード変更を即座に反映する機能です。

| Web開発 | Flutter |
|---------|---------|
| ブラウザの自動リフレッシュ（Webpack HMRなど） | Hot Reload（`r`キー） |
| 完全な再読み込み（ページリフレッシュ） | Hot Restart（`R`キー） |

**違い**:
- **Web**: DOMが更新され、JavaScriptが再実行される
- **Flutter**: Widgetツリーが更新され、状態は保持される

**制限事項**: 以下の変更はHot Restartが必要:
- クラス名の変更
- 新しいファイルの追加
- const値の変更
- ネイティブコードの変更

---

## アーキテクチャとバックエンド

### Flutterはクライアントサイドのみ

**重要**: Flutter自体は**クライアントサイドのフレームワーク**であり、サーバーサイド処理は含まれません。

```
┌─────────────────────┐
│   Flutterアプリ      │  ← クライアント（モバイル/Web/デスクトップ）
│    (Dart言語)       │     UIとビジネスロジック
└──────────┬──────────┘
           │ HTTP/WebSocket/gRPC
           │
┌──────────▼──────────┐
│  バックエンドAPI     │  ← サーバーサイド（必要に応じて別途構築）
│ (Node.js/Go/Python等)│     データ処理、認証、ビジネスロジック
└─────────────────────┘
```

### Web開発との違い

**フルスタックWebフレームワーク（Next.js/Nuxt等）**:
```javascript
// pages/api/users.js - サーバーサイドで実行
export default async function handler(req, res) {
  const users = await db.users.findAll();
  res.json(users);
}

// pages/index.js - クライアントサイド
export async function getServerSideProps() {
  // サーバーサイドで実行
  const data = await fetchFromDB();
  return { props: { data } };
}
```
→ **同じプロジェクト・言語でクライアント・サーバー両方を扱える**

**Flutter**:
```dart
// lib/main.dart - クライアントサイドのみ
Future<List<User>> fetchUsers() async {
  // HTTPリクエストでAPIを呼び出す
  final response = await http.get(
    Uri.parse('https://api.example.com/users')
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}
```
→ **Flutterはクライアントのみ、APIは別途構築が必要**

### バックエンドAPIの構築

Flutterアプリで本格的な機能を実装する場合、バックエンドAPIが必要です。

**一般的な技術スタック**:

| 言語 | フレームワーク | 特徴 |
|------|---------------|------|
| Node.js | Express, Fastify, NestJS | JavaScript/TypeScript、高速開発 |
| Go | Gin, Echo, Fiber | 高パフォーマンス、並行処理 |
| Python | FastAPI, Django, Flask | AI/ML統合、豊富なライブラリ |
| Ruby | Ruby on Rails | 高速プロトタイピング |
| Java | Spring Boot | エンタープライズ、型安全 |
| Rust | Actix, Rocket | 最高レベルのパフォーマンス |

**REST API例（Node.js + Express）**:
```javascript
// server.js
const express = require('express');
const app = express();

app.get('/api/users', async (req, res) => {
  const users = await db.users.findAll();
  res.json(users);
});

app.post('/api/users', async (req, res) => {
  const user = await db.users.create(req.body);
  res.json(user);
});

app.listen(3000);
```

**Flutter側（クライアント）**:
```dart
// lib/services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const baseUrl = 'https://api.example.com';

  // GET リクエスト
  Future<List<User>> getUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // POST リクエスト
  Future<User> createUser(String name, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
      }),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }
}
```

### BaaS（Backend as a Service）を使う

バックエンドを自分で構築せず、マネージドサービスを利用する選択肢もあります。

**Firebase（最も人気）**:

> 📘 **詳細**: [Firebase ガイド](FIREBASE-GUIDE.md)で認証・Firestore・Storage・Push通知の実装方法を詳しく解説しています。
```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^2.0.0
  firebase_auth: ^4.0.0        # 認証
  cloud_firestore: ^4.0.0      # NoSQLデータベース
  firebase_storage: ^11.0.0    # ファイルストレージ
  firebase_messaging: ^14.0.0  # Push通知
```

```dart
// Firebase を使ったデータ操作（バックエンドコード不要）
import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;

// データ追加
Future<void> addUser(String name, String email) async {
  await db.collection('users').add({
    'name': name,
    'email': email,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

// データ取得
Future<List<User>> getUsers() async {
  final snapshot = await db.collection('users').get();
  return snapshot.docs
    .map((doc) => User.fromFirestore(doc))
    .toList();
}

// リアルタイムリスナー
Stream<List<User>> usersStream() {
  return db.collection('users').snapshots().map(
    (snapshot) => snapshot.docs
      .map((doc) => User.fromFirestore(doc))
      .toList()
  );
}

// ユーザー認証
import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential> signUp(String email, String password) async {
  return await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
}
```

**その他のBaaSサービス**:
- **Supabase**: オープンソース、PostgreSQL、リアルタイム同期
- **AWS Amplify**: AWS統合、GraphQL、認証
- **Appwrite**: セルフホスト可能、オープンソース
- **Back4App**: Parse Server、使いやすいUI

### バックエンドが不要なケース

以下のケースでは、バックエンドAPI不要でFlutterアプリを構築できます。

**1. ローカルストレージのみ使用**

```dart
// SQLiteを使った永続化
import 'package:sqflite/sqflite.dart';

final database = await openDatabase(
  'my_database.db',
  version: 1,
  onCreate: (db, version) {
    return db.execute(
      'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT)',
    );
  },
);

// データ挿入
await database.insert('users', {
  'name': 'John',
  'email': 'john@example.com',
});

// データ取得
final List<Map<String, dynamic>> users = await database.query('users');
```

```dart
// 簡易的な設定値の保存
import 'package:shared_preferences/shared_preferences.dart';

final prefs = await SharedPreferences.getInstance();
await prefs.setString('username', 'John');
final username = prefs.getString('username');
```

**2. 公開APIを使用**

```dart
// 天気予報API（OpenWeatherMap）
Future<Weather> fetchWeather(String city) async {
  final apiKey = 'YOUR_API_KEY';
  final response = await http.get(
    Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey')
  );
  return Weather.fromJson(jsonDecode(response.body));
}

// ニュースAPI
Future<List<Article>> fetchNews() async {
  final response = await http.get(
    Uri.parse('https://newsapi.org/v2/top-headlines?country=jp&apiKey=YOUR_KEY')
  );
  final data = jsonDecode(response.body);
  return (data['articles'] as List)
    .map((json) => Article.fromJson(json))
    .toList();
}
```

**3. 静的コンテンツのみ（オフラインアプリ）**

- 電卓アプリ
- ToDoアプリ（ローカルのみ）
- 辞書アプリ（データをアプリに同梱）
- ゲーム（オンライン要素なし）

### API通信パッケージ

**基本的なHTTP通信**:
```yaml
dependencies:
  http: ^1.0.0
```

**高機能なHTTPクライアント（Dio）**:
```yaml
dependencies:
  dio: ^5.0.0
```

```dart
import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: Duration(seconds: 5),
  receiveTimeout: Duration(seconds: 3),
));

// インターセプター（ログ、認証トークン追加など）
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    options.headers['Authorization'] = 'Bearer $token';
    return handler.next(options);
  },
  onError: (error, handler) {
    print('Error: ${error.message}');
    return handler.next(error);
  },
));

// リクエスト
final response = await dio.get('/users');
final users = (response.data as List).map((e) => User.fromJson(e)).toList();
```

**GraphQL**:
```yaml
dependencies:
  graphql_flutter: ^5.0.0
```

```dart
import 'package:graphql_flutter/graphql_flutter.dart';

final httpLink = HttpLink('https://api.example.com/graphql');
final client = GraphQLClient(
  link: httpLink,
  cache: GraphQLCache(),
);

// クエリ
const query = '''
  query GetUsers {
    users {
      id
      name
      email
    }
  }
''';

final result = await client.query(QueryOptions(document: gql(query)));
```

### まとめ: アーキテクチャの選択

| ケース | 推奨構成 |
|--------|----------|
| 学習・プロトタイプ | ローカルストレージ or Firebase |
| 小〜中規模アプリ | Firebase or Supabase（BaaS） |
| 大規模・エンタープライズ | 自前API（Node.js/Go/等） + データベース |
| 既存システムと連携 | 既存APIを利用 |
| オフラインファースト | ローカルDB + 同期機能 |

**Webとの違いのまとめ**:
- **Web（SSR）**: 同じコードベースでサーバー・クライアント両方
- **Flutter**: クライアントのみ、サーバーは別途構築または BaaS利用

---

## UI/UXの概念

### Material Design vs Cupertino

FlutterはAndroid風（Material）とiOS風（Cupertino）の2つのデザインシステムを提供します。

| デザインシステム | プラットフォーム | 例 |
|------------------|------------------|-----|
| Material Design | Android風 | MaterialApp, ElevatedButton, Card |
| Cupertino | iOS風 | CupertinoApp, CupertinoButton, CupertinoNavigationBar |

**Webとの違い**: WebではCSSで自由にスタイリングしますが、モバイルではプラットフォーム標準のデザインガイドラインに従うことが一般的です。

```dart
// Material（Android風）
ElevatedButton(
  onPressed: () {},
  child: Text('Click Me'),
)

// Cupertino（iOS風）
CupertinoButton(
  onPressed: () {},
  child: Text('Click Me'),
)
```

### レイアウト: Flexbox vs Flutter Layout

| Web（CSS Flexbox） | Flutter |
|--------------------|---------|
| `display: flex` | Row / Column |
| `flex-direction: row` | Row |
| `flex-direction: column` | Column |
| `justify-content` | mainAxisAlignment |
| `align-items` | crossAxisAlignment |
| `flex: 1` | Expanded(flex: 1) |

```dart
// Webの display: flex; flex-direction: row; に相当
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text('Left'),
    Text('Right'),
  ],
)
```

### ナビゲーション

**Web**: URL + React Router / Vue Router
```javascript
// React Router
<Route path="/profile" component={Profile} />
history.push('/profile');
```

**Flutter**: 名前付きルート + Navigator
```dart
// ルート定義
MaterialApp(
  routes: {
    '/profile': (context) => ProfileScreen(),
  },
);

// ナビゲーション
Navigator.pushNamed(context, '/profile');
```

**重要な違い**:
- モバイルアプリにはURLバーがない
- ブラウザの「戻る」ボタンの代わりに、ナビゲーションバーの「戻る」ボタンを使う
- Deep Link（後述）で外部からURLのように画面を開ける

---

## ビルドとデプロイ

### ビルドモード

Flutterには3つのビルドモードがあります。

| モード | 用途 | 特徴 | Web開発の相当 |
|--------|------|------|---------------|
| **Debug** | 開発中 | Hot Reload可能、デバッグ情報あり、低速 | `npm run dev` |
| **Profile** | パフォーマンス測定 | 本番に近いパフォーマンス、計測ツール利用可 | - |
| **Release** | 本番リリース | 最適化済み、高速、デバッグ不可 | `npm run build` |

```bash
# ビルド
flutter build ios --debug    # デバッグ版
flutter build ios --profile  # プロファイル版
flutter build ios --release  # リリース版
```

### APK / IPA / AAB

**モバイルアプリの配布形式**:

| プラットフォーム | ファイル形式 | 説明 | Web相当 |
|------------------|--------------|------|---------|
| Android | **APK** (Android Package) | アプリのインストールファイル | - |
| Android | **AAB** (Android App Bundle) | Google Play配布用（推奨） | - |
| iOS | **IPA** (iOS App Store Package) | iOSアプリのアーカイブ | - |
| Web | - | HTML/CSS/JSファイル群 | dist/ フォルダ |

**Webとの違い**:
- Webアプリは複数のファイル（HTML, JS, CSS, 画像など）として配信
- モバイルアプリは単一のパッケージファイルとして配信

```bash
# ビルド結果
flutter build web          # build/web/ に出力
flutter build apk          # build/app/outputs/flutter-apk/app-release.apk
flutter build ios          # build/ios/iphoneos/Runner.app（IPA作成にはXcode必要）
```

### Flutter Doctor

**Flutter Doctor**は環境セットアップの状態を診断するツールです。

```bash
flutter doctor -v
```

出力例:
```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Xcode - develop for iOS and macOS
[✓] Chrome - develop for the web
[✓] Android Studio
[!] CocoaPods (some issues)
```

**Webとの違い**: Web開発では環境チェックツールは通常不要ですが、モバイルは複数のSDK、ツール、証明書などが必要なため、このような診断ツールが重要です。

---

## コード署名とセキュリティ

### コード署名（Code Signing）

**コード署名**は、アプリが信頼できる開発者によって作成され、改ざんされていないことを証明する仕組みです。

**Webとの大きな違い**:
- **Web**: サーバーから配信されるファイルをブラウザが実行（SSL/TLSで通信は保護）
- **iOS**: Appleが承認した証明書で署名されたアプリのみデバイスで実行可能

**必要な理由**:
1. セキュリティ: マルウェアからユーザーを保護
2. 身元確認: 開発者の身元を確認
3. 完全性: アプリが改ざんされていないことを保証

### 開発証明書（Development Certificate）

**開発証明書**は、開発中のアプリをデバイスで実行するために必要な証明書です。

| 証明書タイプ | 用途 | 有効期限 |
|--------------|------|----------|
| **Apple Development** | 開発・テスト | 1年 |
| **Apple Distribution** | App Store配布 | 1年 |

**取得方法**:
- Xcodeの「Automatically manage signing」を有効にすると自動生成
- または Apple Developer Portalで手動生成

### プロビジョニングプロファイル（Provisioning Profile）

**プロビジョニングプロファイル**は、特定のデバイスでアプリを実行する許可証です。

**含まれる情報**:
- App ID（バンドル識別子）
- 開発証明書
- 許可されたデバイスのリスト
- アプリの権限（Push通知、位置情報など）

**Webとの対比**:
- **Web**: URLにアクセスすれば誰でも使える
- **iOS開発**: 特定のデバイスにのみインストール可能（プロビジョニングプロファイルで制限）

### Bundle Identifier（バンドル識別子）

**Bundle Identifier**は、アプリを一意に識別する文字列です。

形式: `com.company.appname`（逆ドメイン表記）

**Webとの対比**:
- **Web**: ドメイン名（example.com）
- **iOS**: Bundle Identifier（com.example.myapp）

**重要**:
- App Store全体で一意である必要がある
- 一度公開したら変更できない（変更すると別アプリ扱い）
- Webのドメイン名ほどの柔軟性はない

```dart
// iOS: Info.plist
<key>CFBundleIdentifier</key>
<string>com.example.myapp</string>

// Android: build.gradle
applicationId "com.example.myapp"
```

---

## デバイスとテスト

### iOS Simulator vs 実機

| 項目 | iOS Simulator | 実機 |
|------|---------------|------|
| 速度 | 高速（MacのCPUを使用） | 実デバイスの性能 |
| カメラ | 使えない | 使える |
| GPS | シミュレート可能 | 実際のGPS |
| Push通知 | 制限あり | 完全に機能 |
| Face ID | シミュレート可能 | 実際のセンサー |
| コード署名 | 不要 | 必須 |

**Webとの対比**:
- **Web**: Chrome DevToolsのデバイスモード ≒ Simulator
- **Web**: 実際のスマホでテスト ≒ 実機テスト

**推奨**:
- 開発初期: Simulatorで高速開発
- 本番前: 実機でテスト（パフォーマンス、センサー動作確認）

### Developer Mode（iOS 16以降）

**Developer Mode**は、iOS 16以降で開発アプリを実機で実行するために必要な設定です。

**有効化手順**:
1. 設定 > プライバシーとセキュリティ > Developerモード
2. オンに切り替え
3. デバイス再起動
4. 確認ダイアログで承認

**Webとの違い**: Webアプリは開発版も本番版もブラウザで自由に実行できますが、iOSは開発アプリの実行に特別な許可が必要です。

### デバイスログ

**ログの確認方法**:

| プラットフォーム | ツール | Webの相当 |
|------------------|--------|-----------|
| iOS | Xcode > Window > Devices and Simulators > Console | Chrome DevTools Console |
| Android | Android Studio > Logcat | Chrome DevTools Console |
| Flutter | `flutter logs` コマンド | - |

```bash
# Flutterアプリのログを表示
flutter logs
```

---

## パフォーマンス

### フレームレート

**モバイルアプリの目標**:
- **60 FPS**（1フレーム16ms）が基本
- 高リフレッシュレート端末では **120 FPS**（1フレーム8ms）

**Webとの違い**:
- **Web**: ブラウザがレンダリングを制御
- **Flutter**: アプリがフレームを直接描画（ゲームエンジンに近い）

### ビルドとレンダリング

**Widget → Element → RenderObject**:

```
Widget (設定)
  ↓
Element (Widgetの実体)
  ↓
RenderObject (実際の描画)
```

**Webとの対比**:
- **Web**: React仮想DOM → 実DOM → ブラウザレンダリング
- **Flutter**: Widget → Element → Canvas描画

**パフォーマンス計測**:
```bash
# パフォーマンスオーバーレイ表示
flutter run --profile
# アプリ内で "P" キーを押す
```

### Isolate

**Isolate**は、Dartの並行処理の仕組みです。

**Webとの対比**:
- **Web**: Web Workers（メモリを共有しない）
- **Dart**: Isolates（メモリを共有しない、メッセージパッシング）

```dart
// 重い処理をIsolateで実行
import 'dart:isolate';

Future<int> heavyComputation(int n) async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_isolateEntry, receivePort.sendPort);

  final sendPort = await receivePort.first as SendPort;
  final answerPort = ReceivePort();
  sendPort.send([answerPort.sendPort, n]);

  return await answerPort.first as int;
}

void _isolateEntry(SendPort sendPort) {
  final port = ReceivePort();
  sendPort.send(port.sendPort);

  port.listen((message) {
    final replyPort = message[0] as SendPort;
    final n = message[1] as int;

    // 重い計算
    int result = 0;
    for (int i = 0; i < n; i++) {
      result += i;
    }

    replyPort.send(result);
  });
}
```

---

## 配布とストア

### TestFlight（iOS）

**TestFlight**は、iOSアプリのベータテスト配布プラットフォームです。

**Webとの対比**:
- **Web**: Staging環境にデプロイしてURLを共有
- **iOS**: TestFlightでIPAファイルをアップロードして招待

**特徴**:
- **内部テスター**: チームメンバー（最大100人）
- **外部テスター**: 一般ユーザー（最大10,000人、審査あり）
- **有効期限**: 各ビルドは90日間有効

**手順**:
1. Xcodeでアプリをアーカイブ
2. App Store Connectにアップロード
3. テスターを招待
4. テスターはTestFlightアプリでインストール

### App Store vs Google Play

| 項目 | App Store（iOS） | Google Play（Android） | Web |
|------|------------------|------------------------|-----|
| 審査 | 厳格（1-3日） | 緩め（数時間） | なし |
| 年間費用 | $99 | $25（初回のみ） | ドメイン代のみ |
| 更新 | 審査通過後反映 | 審査通過後反映 | 即座 |
| ロールバック | 困難 | 段階的ロールアウト可能 | 簡単 |

**審査のポイント**:
- **機能の完全性**: クラッシュしない、主要機能が動作する
- **プライバシー**: 個人情報の扱いを明記
- **デザインガイドライン**: iOSらしい/AndroidらしいUI
- **コンテンツ**: 違法・有害コンテンツの禁止

### Deep Link / Universal Link

**Deep Link**は、アプリ内の特定画面を外部から開くための仕組みです。

**Webとの対比**:
- **Web**: `https://example.com/product/123` → 商品ページ
- **iOS**: `myapp://product/123` または `https://example.com/product/123` → アプリの商品画面

**種類**:
- **Custom URL Scheme**: `myapp://...`（アプリ専用）
- **Universal Link（iOS）**: `https://example.com/...`（WebとアプリどちらでもOK）
- **App Links（Android）**: Universal Linkと同様

```dart
// Deep Linkの処理
MaterialApp(
  onGenerateRoute: (settings) {
    // myapp://product/123 を処理
    if (settings.name?.startsWith('/product/') == true) {
      final id = settings.name!.split('/').last;
      return MaterialPageRoute(
        builder: (_) => ProductScreen(id: id),
      );
    }
  },
);
```

---

## その他の重要概念

### プラットフォームチャネル（Platform Channel）

**プラットフォームチャネル**は、Flutterからネイティブコード（Swift/Kotlin）を呼び出す仕組みです。

**使用例**:
- ネイティブAPIの呼び出し（Flutterにない機能）
- 既存のネイティブライブラリの利用
- ハードウェアアクセス

```dart
// Flutterからネイティブへ
import 'package:flutter/services.dart';

const platform = MethodChannel('com.example.app/battery');

Future<int> getBatteryLevel() async {
  try {
    final result = await platform.invokeMethod('getBatteryLevel');
    return result as int;
  } catch (e) {
    return -1;
  }
}
```

**Webとの対比**:
- **Web**: Web API（navigator.geolocation など）
- **Flutter**: Platform Channel → ネイティブAPI

### パーミッション（権限）

**パーミッション**は、ユーザーの許可が必要な機能です。

| 機能 | iOS | Android | Web |
|------|-----|---------|-----|
| カメラ | 必要 | 必要 | 必要（ブラウザ） |
| 位置情報 | 必要 | 必要 | 必要（ブラウザ） |
| 連絡先 | 必要 | 必要 | API自体がない |
| ファイルアクセス | 制限あり | 必要 | File API |

**設定方法**:
```yaml
# pubspec.yaml
dependencies:
  permission_handler: ^10.0.0
```

```dart
// 位置情報の許可を要求
import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermission() async {
  final status = await Permission.location.request();
  if (status.isGranted) {
    // 許可された
  } else {
    // 拒否された
  }
}
```

### Push通知

**Push通知**の仕組み:

**Web**:
- Service Worker + Push API
- ブラウザが閉じていても通知可能（デスクトップ）

**モバイル**:
- **iOS**: APNs (Apple Push Notification service)
- **Android**: FCM (Firebase Cloud Messaging)
- アプリが閉じていても通知可能

**実装**:
```yaml
# pubspec.yaml
dependencies:
  firebase_messaging: ^14.0.0
```

```dart
// Push通知の受信
import 'package:firebase_messaging/firebase_messaging.dart';

final messaging = FirebaseMessaging.instance;

// 許可を要求
await messaging.requestPermission();

// トークン取得（サーバーに送信して保存）
final token = await messaging.getToken();

// メッセージ受信
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('通知: ${message.notification?.title}');
});
```

### アプリライフサイクル

**モバイルアプリのライフサイクル**:

```
起動 → Active（フォアグラウンド） → Inactive → Background → Terminated
```

**Webとの対比**:
- **Web**: ページの表示/非表示（visibilitychange イベント）
- **Flutter**: AppLifecycleState

```dart
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print('アプリがフォアグラウンドに');
        break;
      case AppLifecycleState.inactive:
        print('アプリが非アクティブに');
        break;
      case AppLifecycleState.paused:
        print('アプリがバックグラウンドに');
        break;
      case AppLifecycleState.detached:
        print('アプリが終了');
        break;
    }
  }
}
```

---

## まとめ: WebとFlutterの主な違い

| 側面 | Web開発 | Flutter/モバイル開発 |
|------|---------|----------------------|
| **配布** | URLで即座にアクセス | ストアで審査後配布 |
| **更新** | デプロイ即反映 | ユーザーがアップデート |
| **実行環境** | ブラウザ | OS上で直接実行 |
| **パフォーマンス** | ブラウザに依存 | ネイティブに近い |
| **セキュリティ** | HTTPS、CORS | コード署名、サンドボックス |
| **UI** | HTML/CSS | Widget |
| **デバッグ** | DevTools | Xcode/Android Studio/DevTools |
| **ライフサイクル** | ページ単位 | アプリ全体 |

---

## 次のステップ

1. **Flutter公式チュートリアル**: [flutter.dev/docs/get-started/codelab](https://flutter.dev/docs/get-started/codelab)
2. **Widget カタログ**: [flutter.dev/docs/development/ui/widgets](https://flutter.dev/docs/development/ui/widgets)
3. **Dart言語ツアー**: [dart.dev/guides/language/language-tour](https://dart.dev/guides/language/language-tour)
4. **サンプルアプリ**: [flutter.github.io/samples/](https://flutter.github.io/samples/)

---

## 参考リソース

- [Flutter公式ドキュメント](https://flutter.dev/docs)
- [Dart公式ドキュメント](https://dart.dev/guides)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Material Design](https://material.io/design)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
