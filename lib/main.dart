import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interactive_learn/core/providers/auth_provider.dart';
import 'package:interactive_learn/core/singleton.dart';
import 'package:interactive_learn/screens/auth/login.dart';
import 'package:interactive_learn/screens/tab_widget_tree.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colors = ColorScheme.fromSeed(
      seedColor: Colors.lightBlueAccent,
    );
    final ColorScheme darkColors = ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 56, 10, 129),
      brightness: Brightness.dark
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nexus',
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: colors.primary.withAlpha(150),
          foregroundColor: Colors.white,
        ),
        colorScheme: colors,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: colors.primary.withAlpha(200),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: darkColors,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // deep dark blue-gray

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        cardColor: const Color(0xFF1E293B),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF6C63FF),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 2,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E293B),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Colors.white54),
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),

        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      themeMode: ThemeMode.light,
      home: const AuthGate(),
    );
  }
}

/// Listens to [authStateProvider] and routes to the correct screen.
/// Checks the synchronous session during loading to avoid a flicker.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);
    return authAsync.when(
      data: (state) {
        if (state.session != null) return const TabWidgetTree();
        return const LoginPage();
      },
      loading: () {
        // Use synchronous session to avoid a white flash on re-launch
        if (supabase.auth.currentSession != null) return const TabWidgetTree();
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      error: (_, _) => const LoginPage(),
    );
  }
}
