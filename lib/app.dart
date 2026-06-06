import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/services/api_football_service.dart';
import 'providers/leagues_provider.dart';
import 'providers/matches_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

class TakortApp extends StatelessWidget {
  const TakortApp({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ApiFootballService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MatchesProvider(service)),
        ChangeNotifierProvider(create: (_) => LeaguesProvider(service)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          title: 'Akour Nwasa',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.themeMode,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
