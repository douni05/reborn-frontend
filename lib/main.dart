import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'screens/Splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(nativeAppKey: 'a06fce5e5d684837dbcd8b9dd22e69d5');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Re:Born',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'RebornFont',
      ),
      home: const SplashScreen(),
    );
  }
}
