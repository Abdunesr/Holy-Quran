// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quran/providers/bookmark_provider.dart';
import 'package:quran/providers/settings_provider.dart';
import 'package:quran/providers/surah_provider.dart';
import 'package:quran/screen/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print('✅ .env file loaded successfully');
  } catch (e) {
    print('⚠️ Error loading .env file: $e');
    print('⚠️ Continuing without .env file');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.teal[700],
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => SurahProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'Holy Quran',
            theme: ThemeData(
              primarySwatch: Colors.teal,
              hintColor: Colors.amber,
              fontFamily: 'Poppins',
              textTheme: TextTheme(
                headlineMedium: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                bodyLarge: TextStyle(fontSize: 16.0, height: 1.5),
                bodyMedium: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
              ),
              appBarTheme: AppBarTheme(
                color: Colors.teal[700],
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.teal[700],
                unselectedItemColor: Colors.grey[600],
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: Colors.teal[800],
              colorScheme: ThemeData.dark().colorScheme.copyWith(
                secondary: Colors.amber[600],
              ),
              appBarTheme: AppBarTheme(color: Colors.teal[800], elevation: 0),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Colors.grey[900],
                selectedItemColor: Colors.teal[300],
                unselectedItemColor: Colors.grey[500],
              ),
            ),
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: WelcomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
