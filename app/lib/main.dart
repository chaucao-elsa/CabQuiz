import 'package:cabquiz/firebase_options.dart';
import 'package:cabquiz/resources/app_colors.dart';
import 'package:cabquiz/resources/fonts.gen.dart';
import 'package:cabquiz/routes/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  final AppRouter router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router.config(),
      title: 'Cab Quiz',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Initialize EasyLoading
        child = EasyLoading.init()(context, child);

        // Apply max width constraint for web/larger screens
        return Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480), // Mobile width
            child: child,
          ),
        );
      },
      theme: ThemeData(
        fontFamily: FontFamily.nunito,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.greyScale900,
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.greyScale900,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.greyScale500,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: AppColors.greyScale900,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
            foregroundColor: AppColors.greyScale900,
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
        ),
        useMaterial3: false,
      ),
    );
  }
}
