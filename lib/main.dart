import 'package:deepfakedetectorfront/app/first_page.dart';
import 'package:deepfakedetectorfront/app/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Env.init();
  runApp(DevicePreview(enabled: false, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Poliedro Images',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Inter',
        ),
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        initialRoute: "/",
        routes: {
          '/': (_) => const LoadingPage(),
          '/first': (_) => const FirstPage(),
        },
      ),
    );
  }
}
