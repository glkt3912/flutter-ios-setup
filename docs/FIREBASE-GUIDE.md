# Firebase ガイド - Flutter開発者向けBaaS入門

FlutterアプリでFirebaseを使用する包括的なガイドです。

## 目次

- [Firebaseとは](#firebaseとは)
- [主要サービス](#主要サービス)
- [セットアップ](#セットアップ)
- [認証（Authentication）](#認証authentication)
- [データベース（Firestore）](#データベースfirestore)
- [ストレージ（Storage）](#ストレージstorage)
- [Push通知（Cloud Messaging）](#push通知cloud-messaging)
- [アナリティクス（Analytics）](#アナリティクスanalytics)
- [料金プラン](#料金プラン)
- [メリット・デメリット](#メリットデメリット)
- [代替サービス](#代替サービス)

---

## Firebaseとは

**Firebase**は、Googleが提供するモバイル・Web向けのBaaS（Backend as a Service）プラットフォームです。

### BaaSとは

**BaaS（Backend as a Service）**は、バックエンドの機能をマネージドサービスとして提供するプラットフォームです。

**従来の開発**:
```
┌──────────┐      ┌──────────────┐      ┌──────────┐
│ Flutter  │ HTTP │ Node.js API  │ SQL  │ データベース │
│ アプリ   │─────→│ (自前構築)   │─────→│ (自前構築) │
└──────────┘      └──────────────┘      └──────────┘
                         ↓
              サーバー管理・スケーリング
              セキュリティ対策・監視
```

**Firebaseを使用**:
```
┌──────────┐      ┌────────────────────────┐
│ Flutter  │ SDK  │ Firebase               │
│ アプリ   │─────→│ (Google管理)           │
└──────────┘      │ - 認証                 │
                  │ - データベース          │
                  │ - ストレージ            │
                  │ - Push通知             │
                  └────────────────────────┘
                         ↓
              サーバー不要！
```

### Firebaseの特徴

| 特徴 | 説明 |
|------|------|
| **サーバーレス** | サーバー構築・管理不要 |
| **リアルタイム同期** | データ変更が即座に全デバイスに反映 |
| **スケーラブル** | Googleのインフラで自動スケーリング |
| **統合されたサービス** | 認証・DB・ストレージなど一貫したAPI |
| **無料枠あり** | 小規模プロジェクトは無料で始められる |
| **SDK充実** | Flutter公式サポート |

---

## 主要サービス

### Firebase Authentication（認証）

**用途**: ユーザー認証・アカウント管理

**対応プロバイダ**:
- メールアドレス/パスワード
- 電話番号（SMS認証）
- Google、Apple、Facebook、Twitter
- 匿名認証
- カスタム認証

### Cloud Firestore（NoSQLデータベース）

**用途**: リアルタイムデータベース

**特徴**:
- NoSQL（ドキュメント指向）
- リアルタイムリスナー
- オフライン対応（自動キャッシュ）
- 複雑なクエリ対応
- セキュリティルール

### Realtime Database（旧リアルタイムDB）

**用途**: シンプルなリアルタイムデータ同期

**Firestoreとの違い**:
- より単純なJSON構造
- Firestoreより高速（シンプルなデータ向け）
- クエリ機能は制限的

**推奨**: 新規プロジェクトは**Firestore**を使用

### Cloud Storage（ファイルストレージ）

**用途**: 画像・動画・ファイルの保存

**特徴**:
- 大容量ファイル対応
- アップロード/ダウンロード進捗
- セキュリティルール
- CDN統合

### Cloud Messaging（Push通知）

**用途**: プッシュ通知送信

**特徴**:
- iOS/Android対応
- トピック購読
- デバイスグループ
- データペイロード

### Analytics（アナリティクス）

**用途**: ユーザー行動分析

**機能**:
- 自動イベント収集
- カスタムイベント
- ユーザープロパティ
- コンバージョントラッキング

### その他のサービス

- **Cloud Functions**: サーバーレス関数（Node.js/Python）
- **Hosting**: Webホスティング
- **Remote Config**: アプリの動的設定
- **Crashlytics**: クラッシュレポート
- **Performance Monitoring**: パフォーマンス監視
- **App Distribution**: テスター向け配布
- **Dynamic Links**: ディープリンク

---

## セットアップ

### 1. Firebaseプロジェクト作成

1. [Firebase Console](https://console.firebase.google.com/)にアクセス
2. 「プロジェクトを追加」をクリック
3. プロジェクト名を入力（例: `my-flutter-app`）
4. Google Analyticsを有効化（推奨）
5. プロジェクト作成

### 2. iOSアプリを追加

1. Firebase Consoleでプロジェクトを開く
2. iOSアイコンをクリック
3. **iOSバンドルID**を入力（Xcodeの Bundle Identifier）
   - 例: `com.example.myapp`
4. アプリのニックネームを入力（任意）
5. `GoogleService-Info.plist`をダウンロード

### 3. GoogleService-Info.plistを配置

```bash
# Flutterプロジェクトのiosディレクトリに配置
cd your_flutter_project
cp ~/Downloads/GoogleService-Info.plist ios/Runner/
```

**Xcodeで追加**:
1. Xcodeで `ios/Runner.xcworkspace`を開く
2. プロジェクトナビゲータで`Runner`フォルダを右クリック
3. 「Add Files to "Runner"」を選択
4. `GoogleService-Info.plist`を選択
5. **"Copy items if needed"にチェック**
6. 追加

### 4. Flutter パッケージのインストール

```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^2.24.0           # Firebase コア（必須）
  firebase_auth: ^4.15.0           # 認証
  cloud_firestore: ^4.13.0         # Firestore
  firebase_storage: ^11.5.0        # ストレージ
  firebase_messaging: ^14.7.0      # Push通知
  firebase_analytics: ^10.7.0      # アナリティクス
```

```bash
flutter pub get
```

### 5. iOS追加設定

**Podfile更新**:
```bash
cd ios
pod install
cd ..
```

**iOS 10以上のサポート（Push通知用）**:

`ios/Runner/AppDelegate.swift`を編集:
```swift
import UIKit
import Flutter
import Firebase  // 追加

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()  // 追加
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 6. Flutter側の初期化

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase初期化
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Demo',
      home: HomeScreen(),
    );
  }
}
```

### 7. 動作確認

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  print('Firebase initialized successfully!');

  runApp(MyApp());
}
```

アプリを実行して、コンソールに成功メッセージが表示されればOK。

---

## 認証（Authentication）

### メールアドレス/パスワード認証

**Firebase Consoleで有効化**:
1. Authentication > Sign-in method
2. 「メール/パスワード」を有効化

**実装**:

```dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 現在のユーザーを取得
  User? get currentUser => _auth.currentUser;

  // 認証状態の変更を監視
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 新規登録
  Future<UserCredential> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('パスワードが弱すぎます');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('このメールアドレスは既に使用されています');
      }
      throw Exception(e.message ?? 'エラーが発生しました');
    }
  }

  // ログイン
  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('ユーザーが見つかりません');
      } else if (e.code == 'wrong-password') {
        throw Exception('パスワードが間違っています');
      }
      throw Exception(e.message ?? 'エラーが発生しました');
    }
  }

  // ログアウト
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // パスワードリセットメール送信
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // メールアドレス確認メール送信
  Future<void> sendEmailVerification() async {
    final user = currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
}
```

**使用例**:
```dart
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      await _authService.signIn(
        _emailController.text,
        _passwordController.text,
      );
      // ログイン成功 - ホーム画面へ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ログイン')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'メールアドレス'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'パスワード'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handleLogin,
                    child: Text('ログイン'),
                  ),
          ],
        ),
      ),
    );
  }
}
```

### Google Sign-In

**追加パッケージ**:
```yaml
dependencies:
  google_sign_in: ^6.1.0
```

**実装**:
```dart
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    // Googleアカウント選択
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google Sign-In がキャンセルされました');
    }

    // 認証情報取得
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Firebase認証情報作成
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Firebaseにサインイン
    return await _auth.signInWithCredential(credential);
  }
}
```

### 認証状態の監視

```dart
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // ローディング中
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        // ログイン済み
        if (snapshot.hasData) {
          return HomeScreen();
        }

        // 未ログイン
        return LoginScreen();
      },
    );
  }
}
```

---

## データベース（Firestore）

### データ構造

**コレクション（Collection）とドキュメント（Document）**:

```
users (コレクション)
├── user1 (ドキュメント)
│   ├── name: "田中太郎"
│   ├── email: "tanaka@example.com"
│   └── age: 30
├── user2 (ドキュメント)
│   ├── name: "佐藤花子"
│   └── email: "sato@example.com"
└── ...

posts (コレクション)
├── post1 (ドキュメント)
│   ├── title: "初投稿"
│   ├── content: "よろしく"
│   ├── userId: "user1"
│   ├── createdAt: Timestamp
│   └── comments (サブコレクション)
│       ├── comment1
│       └── comment2
└── ...
```

### 基本的な操作

**Firebase Consoleで有効化**:
1. Firestore Database を選択
2. 「データベースを作成」
3. **本番環境モード**または**テストモード**を選択
   - テストモード: 30日間すべて読み書き可能（開発用）
   - 本番モード: セキュリティルール設定が必要

**初期化**:
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
```

**データ追加**:
```dart
// 自動生成されたIDでドキュメント追加
Future<void> addUser(String name, String email) async {
  await db.collection('users').add({
    'name': name,
    'email': email,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

// 指定したIDでドキュメント追加/更新
Future<void> setUser(String userId, String name, String email) async {
  await db.collection('users').doc(userId).set({
    'name': name,
    'email': email,
    'createdAt': FieldValue.serverTimestamp(),
  });
}
```

**データ取得**:
```dart
// 単一ドキュメント取得
Future<Map<String, dynamic>?> getUser(String userId) async {
  final doc = await db.collection('users').doc(userId).get();
  return doc.data();
}

// 全ドキュメント取得
Future<List<Map<String, dynamic>>> getAllUsers() async {
  final snapshot = await db.collection('users').get();
  return snapshot.docs.map((doc) => doc.data()).toList();
}

// クエリ（条件付き取得）
Future<List<Map<String, dynamic>>> getUsersByAge(int minAge) async {
  final snapshot = await db
      .collection('users')
      .where('age', isGreaterThanOrEqualTo: minAge)
      .orderBy('age')
      .limit(10)
      .get();
  return snapshot.docs.map((doc) => doc.data()).toList();
}
```

**データ更新**:
```dart
// 一部フィールドを更新
Future<void> updateUserName(String userId, String newName) async {
  await db.collection('users').doc(userId).update({
    'name': newName,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

// フィールドを削除
Future<void> removeUserAge(String userId) async {
  await db.collection('users').doc(userId).update({
    'age': FieldValue.delete(),
  });
}
```

**データ削除**:
```dart
Future<void> deleteUser(String userId) async {
  await db.collection('users').doc(userId).delete();
}
```

### リアルタイムリスナー

**単一ドキュメントの監視**:
```dart
Stream<Map<String, dynamic>?> userStream(String userId) {
  return db.collection('users').doc(userId).snapshots().map(
    (snapshot) => snapshot.data(),
  );
}

// 使用例
StreamBuilder<Map<String, dynamic>?>(
  stream: userStream('user1'),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }

    final user = snapshot.data!;
    return Text('名前: ${user['name']}');
  },
)
```

**コレクション全体の監視**:
```dart
Stream<List<Map<String, dynamic>>> usersStream() {
  return db.collection('users').snapshots().map(
    (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
  );
}
```

### モデルクラスの活用

```dart
class User {
  final String id;
  final String name;
  final String email;
  final int? age;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.age,
    required this.createdAt,
  });

  // Firestoreドキュメントから変換
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      age: data['age'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Firestoreドキュメントへ変換
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

// 使用例
Future<void> addUser(User user) async {
  await db.collection('users').add(user.toFirestore());
}

Future<List<User>> getUsers() async {
  final snapshot = await db.collection('users').get();
  return snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
}

Stream<List<User>> usersStream() {
  return db.collection('users').snapshots().map(
    (snapshot) => snapshot.docs.map((doc) => User.fromFirestore(doc)).toList(),
  );
}
```

### セキュリティルール

Firebase Consoleで設定（Firestore Database > ルール）:

**テスト用（すべて許可）**:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**本番用（認証済みユーザーのみ）**:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // ユーザーは自分のドキュメントのみ読み書き可能
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // 投稿は誰でも読める、作成者のみ編集可能
    match /posts/{postId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null
                           && request.auth.uid == resource.data.userId;
    }
  }
}
```

---

## ストレージ（Storage）

### ファイルアップロード

```dart
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  // 画像アップロード
  Future<String> uploadImage(File file, String userId) async {
    try {
      // ファイルパス: users/{userId}/profile.jpg
      final ref = storage.ref().child('users/$userId/profile.jpg');

      // アップロード
      final uploadTask = ref.putFile(file);

      // 進捗監視（オプション）
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('アップロード進捗: ${(progress * 100).toStringAsFixed(2)}%');
      });

      // 完了待機
      await uploadTask;

      // ダウンロードURL取得
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('アップロードエラー: $e');
    }
  }

  // ファイルダウンロードURL取得
  Future<String> getDownloadUrl(String path) async {
    final ref = storage.ref().child(path);
    return await ref.getDownloadURL();
  }

  // ファイル削除
  Future<void> deleteFile(String path) async {
    final ref = storage.ref().child(path);
    await ref.delete();
  }
}
```

**画像選択とアップロード（image_pickerパッケージ使用）**:
```yaml
dependencies:
  image_picker: ^1.0.0
```

```dart
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;
  bool _isUploading = false;

  Future<void> _pickAndUploadImage() async {
    // 画像選択
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _isUploading = true);

    try {
      // アップロード
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final url = await _storageService.uploadImage(
        File(image.path),
        userId,
      );

      setState(() {
        _imageUrl = url;
        _isUploading = false;
      });

      // Firestoreのユーザープロファイルも更新
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'profileImage': url});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('アップロード完了')),
      );
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラー: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('プロフィール')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageUrl != null)
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(_imageUrl!),
              )
            else
              CircleAvatar(
                radius: 60,
                child: Icon(Icons.person, size: 60),
              ),
            SizedBox(height: 20),
            _isUploading
                ? CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _pickAndUploadImage,
                    icon: Icon(Icons.photo_camera),
                    label: Text('画像を選択'),
                  ),
          ],
        ),
      ),
    );
  }
}
```

---

## Push通知（Cloud Messaging）

### iOS設定

**1. APNs認証キーの取得**:
1. [Apple Developer](https://developer.apple.com/account/)にログイン
2. Certificates, Identifiers & Profiles > Keys
3. 「+」ボタンで新しいキーを作成
4. Apple Push Notifications service (APNs)にチェック
5. ダウンロードした`.p8`ファイルを保存

**2. Firebase Consoleに追加**:
1. プロジェクト設定 > Cloud Messaging
2. APNs証明書 > 「APNs認証キーをアップロード」
3. `.p8`ファイル、キーID、チームIDを入力

**3. Xcode設定**:
1. Runner > Signing & Capabilities
2. 「+ Capability」 > Push Notifications を追加
3. Background Modes を追加し、"Background fetch" と "Remote notifications" にチェック

### Flutter実装

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // 初期化
  Future<void> initialize() async {
    // 通知許可リクエスト（iOS）
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('通知許可が得られました');
    }

    // FCMトークン取得
    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    // トークンをFirestoreに保存（サーバーから通知を送るため）
    if (token != null) {
      await _saveTokenToDatabase(token);
    }

    // トークン更新時
    _messaging.onTokenRefresh.listen(_saveTokenToDatabase);

    // フォアグラウンド通知受信
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('フォアグラウンドでメッセージ受信: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // バックグラウンドから開いた時
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('通知タップでアプリ起動: ${message.notification?.title}');
      _handleNotificationTap(message);
    });

    // アプリ終了状態から開いた時
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  Future<void> _saveTokenToDatabase(String token) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'fcmToken': token});
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    // ローカル通知表示（flutter_local_notificationsパッケージ使用）
    // 実装省略
  }

  void _handleNotificationTap(RemoteMessage message) {
    // 通知タップ時の処理（特定画面への遷移など）
    print('データ: ${message.data}');
  }

  // トピック購読
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  // トピック購読解除
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}
```

**main.dartで初期化**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // バックグラウンドメッセージハンドラ登録
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

// トップレベル関数（グローバル）
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('バックグラウンドでメッセージ受信: ${message.messageId}');
}
```

### 通知送信（Firebase Consoleから）

1. Firebase Console > Cloud Messaging
2. 「最初のキャンペーンを作成」または「新しい通知」
3. 通知タイトルと本文を入力
4. ターゲットを選択（全ユーザー、トピック、特定デバイスなど）
5. 送信

---

## アナリティクス（Analytics）

### イベント記録

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // カスタムイベント記録
  Future<void> logEvent(String name, Map<String, dynamic>? parameters) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  // 画面表示イベント
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  // ログインイベント
  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  // サインアップイベント
  Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  // 購入イベント
  Future<void> logPurchase(double value, String currency) async {
    await _analytics.logPurchase(
      value: value,
      currency: currency,
    );
  }

  // ユーザープロパティ設定
  Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }
}
```

**使用例**:
```dart
class ProductScreen extends StatelessWidget {
  final AnalyticsService _analytics = AnalyticsService();

  @override
  Widget build(BuildContext context) {
    // 画面表示を記録
    _analytics.logScreenView('product_screen');

    return Scaffold(
      appBar: AppBar(title: Text('商品詳細')),
      body: Column(
        children: [
          // ...商品情報
          ElevatedButton(
            onPressed: () async {
              // 購入ボタンタップイベント
              await _analytics.logEvent('add_to_cart', {
                'item_id': 'product_123',
                'item_name': 'サンプル商品',
                'price': 1000,
              });

              // 購入処理...
            },
            child: Text('カートに追加'),
          ),
        ],
      ),
    );
  }
}
```

---

## 料金プラン

### Spark（無料プラン）

| サービス | 無料枠 |
|---------|--------|
| **Authentication** | 無制限 |
| **Firestore** | 1GB ストレージ、50,000 読み取り/日、20,000 書き込み/日 |
| **Storage** | 5GB、1GB/日 ダウンロード |
| **Hosting** | 10GB/月 |
| **Cloud Functions** | 125,000回/月 実行、40,000GB秒/月 |
| **Cloud Messaging** | 無制限 |
| **Analytics** | 無制限 |

**推奨**: 個人プロジェクト、プロトタイプ、小規模アプリ

### Blaze（従量課金プラン）

**無料枠を超えた分のみ課金**:

| サービス | 料金 |
|---------|------|
| **Firestore** | 読み取り: $0.06/10万、書き込み: $0.18/10万、削除: $0.02/10万 |
| **Storage** | $0.026/GB（ストレージ）、$0.12/GB（ダウンロード） |
| **Cloud Functions** | $0.40/100万回、$0.0000025/GB秒 |

**料金例（月間1万アクティブユーザー想定）**:
- Firestore: 約$5-20
- Storage: 約$2-10
- Cloud Functions: 約$5-15
- **合計**: 月$10-50程度（使用量による）

**予算アラート設定**:
1. Google Cloud Console
2. 請求 > 予算とアラート
3. 予算額を設定してアラートメール受信

---

## メリット・デメリット

### メリット

#### 1. 開発スピード
- サーバー構築不要
- バックエンドコード不要
- 認証・DB・ストレージが統合

#### 2. スケーラビリティ
- Googleのインフラで自動スケーリング
- 突然のアクセス増にも対応

#### 3. リアルタイム機能
- データ変更が即座に全クライアントに反映
- チャット、コラボレーションアプリに最適

#### 4. オフライン対応
- Firestoreは自動でローカルキャッシュ
- オフラインでも読み書き可能

#### 5. セキュリティ
- セキュリティルールで細かく制御
- Firebase側で検証

#### 6. 無料枠が充実
- 小規模アプリなら無料で運用可能

### デメリット

#### 1. ベンダーロックイン
- Firebase依存が強い
- 他サービスへの移行が困難

#### 2. 複雑なクエリが苦手
- SQLのような複雑なJOINは不可
- 集計処理は別途Cloud Functionsが必要

#### 3. コスト予測が難しい
- 従量課金で予期せぬ高額請求の可能性
- トラフィック増加時の注意が必要

#### 4. データ構造の制限
- NoSQLのため、リレーショナルなデータには向かない
- データの非正規化が必要

#### 5. デバッグが難しい
- サーバーサイドコードがない分、問題の切り分けが複雑
- Cloud Functionsのローカルデバッグが面倒

#### 6. バックアップが有料
- Firestoreの自動バックアップは追加料金

---

## 代替サービス

### Supabase

**特徴**:
- オープンソース
- **PostgreSQL**（リレーショナルDB）
- リアルタイム同期
- 認証、ストレージ、Edge Functions

**Firebaseとの違い**:
- SQLが使える
- セルフホスト可能
- 料金体系が明確

**向いている人**: SQL好き、オープンソース志向

### AWS Amplify

**特徴**:
- AWS統合
- GraphQL API（AppSync）
- 認証（Cognito）
- ストレージ（S3）

**Firebaseとの違い**:
- AWS他サービスとの連携が強力
- GraphQL標準

**向いている人**: AWS利用者、GraphQL使用者

### Appwrite

**特徴**:
- オープンソース
- セルフホスト
- Docker対応
- REST / GraphQL API

**Firebaseとの違い**:
- 完全にセルフホスト可能
- データ所有権100%

**向いている人**: セルフホスト希望、プライバシー重視

### Parse（Back4App）

**特徴**:
- オープンソース
- シンプルなAPI
- ダッシュボードが使いやすい

**Firebaseとの違い**:
- より従来的なBaaS
- マイグレーションが容易

**向いている人**: シンプルさ重視

---

## まとめ

### Firebaseが向いているケース

✅ **MVP・プロトタイプ開発**
✅ **小〜中規模アプリ**
✅ **リアルタイム機能が必要**（チャット、ライブ更新）
✅ **モバイルファースト**
✅ **素早くリリースしたい**
✅ **サーバー管理したくない**

### Firebaseが向いていないケース

❌ **大規模エンタープライズ**（コスト・制御の観点）
❌ **複雑なSQLクエリが必要**
❌ **ベンダーロックインを避けたい**
❌ **完全なデータ所有権が必要**
❌ **オンプレミス要件**

### 学習リソース

- [Firebase公式ドキュメント](https://firebase.google.com/docs)
- [FlutterFire公式ドキュメント](https://firebase.flutter.dev/)
- [Firebase YouTube チャンネル](https://www.youtube.com/firebase)
- [Firestore データモデリングベストプラクティス](https://firebase.google.com/docs/firestore/manage-data/structure-data)

---

## 次のステップ

1. **Firebaseプロジェクト作成**して実際に触ってみる
2. **認証機能**を実装してログイン画面を作る
3. **Firestore**で簡単なCRUDアプリを作る
4. **Storage**で画像アップロード機能を追加
5. **セキュリティルール**を学んで本番環境に備える
