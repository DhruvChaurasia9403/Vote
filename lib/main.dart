import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_idea_evaluator/presentation/screens/leaderboard_screen.dart';
import 'package:startup_idea_evaluator/presentation/screens/listing_screen.dart';
import 'package:startup_idea_evaluator/presentation/screens/profile_screen.dart';
import 'package:startup_idea_evaluator/presentation/screens/submission_screen.dart';
import 'package:startup_idea_evaluator/presentation/screens/tagged_screen.dart';
import 'package:startup_idea_evaluator/presentation/screens/upvoted_screen.dart';
import 'logic/idea_bloc/idea_bloc.dart';
import 'package:provider/provider.dart';
import 'logic/idea_bloc/idea_event.dart';
import 'logic/theme_notifier.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Light Theme: Clean, professional, and airy
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue.shade700,
      scaffoldBackgroundColor: Colors.grey.shade100,
      cardColor: Colors.white,
      fontFamily: 'SF Pro Display',
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey.shade100,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: Colors.blue.shade700,
        secondary: Colors.blue.shade500,
        surface: Colors.white,
        onSurface: Colors.black87,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );

    // Dark Theme: Sleek, modern, and futuristic
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.lightBlue.shade400,
      scaffoldBackgroundColor: const Color(0xFF000000), // Pure Black
      cardColor: const Color(0xFF1A1A1A),
      fontFamily: 'SF Pro Display',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Colors.lightBlueAccent,
        secondary: Colors.lightBlue,
        surface: Color(0xFF1A1A1A),
        onSurface: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue.shade400,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );

    return BlocProvider(
      create: (context) => IdeaBloc()..add(LoadIdeasEvent()),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'IdeaShare',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const ListingScreen(),
            routes: {
              '/listing': (context) => const ListingScreen(),
              '/submit': (context) => const SubmissionScreen(),
              '/leaderboard': (context) => const LeaderboardScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/upvoted': (context) => const UpvotedScreen(),
              '/tagged': (context) => const TaggedScreen(),
            },
          );
        },
      ),
    );
  }
}
