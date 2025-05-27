import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:safehi_yc/main_screen.dart';
import 'package:safehi_yc/provider/nav/bottom_nav_provider.dart';
import 'package:safehi_yc/repository/visit_summary_repository.dart';
import 'package:safehi_yc/service/user_service.dart';
import 'package:safehi_yc/service/visit_summary_service.dart';
import 'package:safehi_yc/util/connectivity.dart';
import 'package:safehi_yc/view/login/login_page.dart';
import 'package:safehi_yc/view_model/stt_result_view_model.dart';
import 'package:safehi_yc/view_model/user_view_model.dart';
import 'package:safehi_yc/repository/visit_repository.dart';
import 'package:safehi_yc/service/visit_service.dart';
import 'package:safehi_yc/view_model/visit_summary_view_model.dart';
import 'package:safehi_yc/view_model/visit_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 디버그 모드일 때만 SSL 무시
  if (kDebugMode) {
    HttpOverrides.global = MyHttpOverrides();
  }

  await dotenv.load(fileName: 'assets/config/.env');

  final userVM = UserViewModel(UserService());
  await userVM.tryAutoLogin();

  runApp(
    ConnectivityWrapper(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<UserViewModel>.value(value: userVM),
          ChangeNotifierProvider(create: (_) => BottomNavProvider()),
          ChangeNotifierProvider(
            create:
                (_) => VisitUploadViewModel(
                  repository: VisitRepository(service: VisitService()),
                ),
          ),
          ChangeNotifierProvider(
            create:
                (_) => VisitSummaryViewModel(
                  repository: VisitSummaryRepository(
                    service: VisitSummaryService(),
                  ),
                ),
          ),

          ChangeNotifierProvider(
            create:
                (_) => SttResultViewModel(
                  repository: VisitRepository(service: VisitService()),
                )..fetchResults(), // ✅ 생성과 동시에 fetch 호출
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _networkChecked = false;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInitialNetwork();
  }

  Future<void> _checkInitialNetwork() async {
    final connected = await isInternetAvailable();
    if (!connected) {
      _showNetworkDialog();
    }

    setState(() {
      _hasInternet = connected;
      _networkChecked = true;
    });
  }

  void _showNetworkDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => AlertDialog(
              title: const Text('인터넷 연결 없음'),
              content: const Text('인터넷이 연결되어 있지 않습니다.\n연결 후 다시 시도해주세요.'),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _checkInitialNetwork(); // 다시 시도
                  },
                  child: const Text('다시 시도'),
                ),
              ],
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<UserViewModel>().isLoggedIn;

    if (!_networkChecked) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home:
          _hasInternet
              ? (isLoggedIn ? const MainScreen() : const LoginPage())
              : const Scaffold(),
    );
  }
}
