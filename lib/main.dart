import 'package:flutter/material.dart';
import 'package:flutter_capstone_6/screen/login/login_view_model.dart';
import 'package:flutter_capstone_6/screen/main/home/notification_view_model.dart';
import 'package:flutter_capstone_6/screen/main/profile/edit_profile/image_view_model.dart';
import 'package:flutter_capstone_6/screen/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'component/global_data.dart';
import 'component/init_page.dart';

int? initScreen;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GlobalData(
      child: Builder(builder: (BuildContext context) {
        GlobalData.of(context)?.refreshData();

        return const MyApp();
      }),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme(textTheme)),
      debugShowCheckedModeBanner: false,
      title: 'Capstone Kelompok 5',
      initialRoute: "/init",
      routes: {
        "/init": (BuildContext context) => const InitPage(),
      },
    );
  }
}
