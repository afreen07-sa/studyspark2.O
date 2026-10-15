import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'login_page.dart';
import 'category_page.dart';
import 'syllabus_page.dart';
import 'class_page.dart';
import 'group_page.dart';
import 'chapter_page.dart';
import 'notes_page.dart';
import 'practice_page.dart';
import 'quiz_page.dart';
import 'models/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudySparkApp());
}

class StudySparkApp extends StatelessWidget {
  const StudySparkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudySpark - Tamil Nadu State Board (Classes 6-12)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          primary: Colors.indigo.shade800,
          secondary: Colors.amber.shade700,
          surface: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo.shade800,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: const CardThemeData(
          elevation: 1.5,
          color: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const WelcomePage(),
        '/login': (_) => const LoginPage(),
        '/dashboard': (_) => const CategoryPage(),
        '/categories': (_) => const CategoryPage(),
        '/syllabus': (_) => const SyllabusPage(),
        '/class': (_) => const ClassPage(),
        '/classes': (_) => const ClassPage(),
        '/group': (_) => GroupPage(selectedClass: AppState.instance.selectedClass),
        '/groups': (_) => GroupPage(selectedClass: AppState.instance.selectedClass),
      },
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '/');
        final path = uri.path;

        if (path == '/chapters' || path == '/chapter') {
          final subject = uri.queryParameters['subject'] ?? 'Mathematics';
          final cls = uri.queryParameters['class'] ?? AppState.instance.selectedClass;
          return MaterialPageRoute(
            builder: (_) => ChapterPage(selectedClass: cls, subject: subject),
          );
        } else if (path == '/notes') {
          final subject = uri.queryParameters['subject'] ?? 'Mathematics';
          final chapter = uri.queryParameters['chapter'] ?? 'General';
          final cls = uri.queryParameters['class'] ?? AppState.instance.selectedClass;
          return MaterialPageRoute(
            builder: (_) => NotesPage(selectedClass: cls, subject: subject, chapter: chapter),
          );
        } else if (path == '/practice') {
          final subject = uri.queryParameters['subject'] ?? 'Mathematics';
          final chapter = uri.queryParameters['chapter'] ?? 'General';
          final cls = uri.queryParameters['class'] ?? AppState.instance.selectedClass;
          return MaterialPageRoute(
            builder: (_) => PracticePage(selectedClass: cls, subject: subject, chapter: chapter),
          );
        } else if (path == '/quiz') {
          final subject = uri.queryParameters['subject'] ?? 'Mathematics';
          final chapter = uri.queryParameters['chapter'] ?? 'General';
          final cls = uri.queryParameters['class'] ?? AppState.instance.selectedClass;
          return MaterialPageRoute(
            builder: (_) => QuizPage(selectedClass: cls, subject: subject, chapter: chapter),
          );
        }

        // Fallback for any unknown web URL
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      },
    );
  }
}