import 'package:flutter/material.dart';
import 'chapter_page.dart';
import 'quiz_page.dart';
import 'practice_page.dart';

class StudyDashboard extends StatelessWidget {
  final String subject;
  final String selectedClass;
  final String language;

  const StudyDashboard({
    super.key,
    required this.subject,
    this.selectedClass = 'Class 6',
    this.language = 'English',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$selectedClass • $subject'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.school,
            size: 80,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          Text(
            '$subject Study Dashboard',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            selectedClass,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(height: 24),

          _menuButton(
            context,
            '📖 Read Notes',
            Icons.menu_book,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChapterPage(
                    selectedClass: selectedClass,
                    subject: subject,
                  ),
                ),
              );
            },
          ),

          _menuButton(
            context,
            '🎥 Watch Videos',
            Icons.play_circle_fill,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LearningResourcesPage(
                    subject: subject,
                    title: 'Video Lessons',
                    icon: Icons.play_circle_fill,
                  ),
                ),
              );
            },
          ),

          _menuButton(
            context,
            '📝 Practice Questions',
            Icons.quiz,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PracticePage(
                    subject: subject,
                    chapter: 'General Practice',
                  ),
                ),
              );
            },
          ),

          _menuButton(
            context,
            '📄 Previous Year Papers',
            Icons.description,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LearningResourcesPage(
                    subject: subject,
                    title: 'Previous Year Papers',
                    icon: Icons.description,
                  ),
                ),
              );
            },
          ),

          _menuButton(
            context,
            '🧠 Take Quiz',
            Icons.school,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizPage(
                    selectedClass: selectedClass,
                    subject: subject,
                    chapter: 'General Quiz',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _menuButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class LearningResourcesPage extends StatelessWidget {
  final String subject;
  final String title;
  final IconData icon;

  const LearningResourcesPage({
    super.key,
    required this.subject,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                subject,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                'Learning resources will appear here when they are added to the app.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}