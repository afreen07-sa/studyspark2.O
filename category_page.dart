import 'package:flutter/material.dart';
import 'data/syllabus_data.dart';
import 'models/app_state.dart';
import 'class_page.dart';
import 'group_page.dart';
import 'chapter_page.dart';
import 'syllabus_page.dart';
import 'practice_page.dart';
import 'quiz_page.dart';
import 'notes_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  void _changeClass() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ClassPage()),
    );
    setState(() {});
  }

  void _changeGroup() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GroupPage(selectedClass: AppState.instance.selectedClass),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final app = AppState.instance;
    final isHigherSec = app.selectedClass == 'Class 11' || app.selectedClass == 'Class 12';
    final subjects = SyllabusData.getSubjects(app.selectedClass, group: app.selectedGroup);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Category of Learning'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Syllabus Explorer',
            icon: const Icon(Icons.menu_book),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SyllabusPage()),
              );
            },
          ),
          IconButton(
            tooltip: 'Change Class',
            icon: const Icon(Icons.switch_account),
            onPressed: _changeClass,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1050),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // STUDENT WELCOME & ACTIVE CLASS BANNER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade700, Colors.blue.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.shade200.withAlpha(120),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(
                          app.studentName.isNotEmpty ? app.studentName[0].toUpperCase() : 'S',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'வணக்கம், ${app.studentName}!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(40),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    app.selectedClass,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                if (isHigherSec)
                                  InkWell(
                                    onTap: _changeGroup,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade400,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Group: ${app.selectedGroup}',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.edit, size: 13, color: Colors.black87),
                                        ],
                                      ),
                                    ),
                                  ),
                                Text(
                                  '• ${app.selectedLanguage} Medium',
                                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.indigo.shade800,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.swap_horiz, size: 18),
                        label: const Text('Switch Class', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: _changeClass,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // SECTION TITLE: CATEGORY OF LEARNING
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category of Learning',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Select your mode of study for the Tamil Nadu State Board curriculum',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.indigo.shade200),
                      ),
                      child: Text(
                        'Total Subjects: ${subjects.length}',
                        style: TextStyle(
                          color: Colors.indigo.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 4 CATEGORIES GRID
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 700;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: isDesktop ? 4 : 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: isDesktop ? 1.3 : 1.1,
                      children: [
                        _categoryBox(
                          title: 'Syllabus',
                          subtitle: 'Classes 6-12 & Groups',
                          icon: Icons.menu_book,
                          color: Colors.indigo,
                          tag: 'Official TN Board',
                          isSelected: app.selectedCategory == 'Syllabus',
                          onTap: () {
                            setState(() {
                              AppState.instance.selectedCategory = 'Syllabus';
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SyllabusPage(initialClass: app.selectedClass),
                              ),
                            );
                          },
                        ),
                        _categoryBox(
                          title: 'Chapter Notes',
                          subtitle: 'Formulas & Concepts',
                          icon: Icons.auto_stories,
                          color: Colors.teal,
                          tag: 'High-Yield Points',
                          isSelected: app.selectedCategory == 'Notes',
                          onTap: () {
                            setState(() {
                              AppState.instance.selectedCategory = 'Notes';
                            });
                          },
                        ),
                        _categoryBox(
                          title: 'Practice Questions',
                          subtitle: 'Hints & Solutions',
                          icon: Icons.edit_note,
                          color: Colors.orange,
                          tag: 'Book Back & Inside',
                          isSelected: app.selectedCategory == 'Practice',
                          onTap: () {
                            setState(() {
                              AppState.instance.selectedCategory = 'Practice';
                            });
                          },
                        ),
                        _categoryBox(
                          title: 'Interactive Quiz',
                          subtitle: 'Timed Tests & Scores',
                          icon: Icons.quiz,
                          color: Colors.purple,
                          tag: 'Vice Versa for Quiz',
                          isSelected: app.selectedCategory == 'Quiz',
                          onTap: () {
                            setState(() {
                              AppState.instance.selectedCategory = 'Quiz';
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 32),

                // SUBJECT LIST FOR THE CURRENT CLASS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subjects for ${app.selectedClass} ${isHigherSec ? "(${app.selectedGroup})" : ""}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SyllabusPage(initialClass: app.selectedClass),
                          ),
                        );
                      },
                      icon: const Icon(Icons.assignment, size: 18),
                      label: const Text('View Full Syllabus Table'),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // SUBJECT CARDS
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    final chapters = SyllabusData.getChapters(app.selectedClass, subject);
                    final color = _getSubjectColor(subject);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 1.5,
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChapterPage(
                                selectedClass: app.selectedClass,
                                subject: subject,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: color.withAlpha(25),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(_getSubjectIcon(subject), color: color, size: 26),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          subject,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${chapters.length} Official TN Board Chapters • Complete Study Material',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(height: 1),
                              const SizedBox(height: 12),

                              // 4 DIRECT ACTIONS PER SUBJECT
                              Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: [
                                  OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.indigo,
                                      side: BorderSide(color: Colors.indigo.shade200),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    ),
                                    icon: const Icon(Icons.format_list_bulleted, size: 16),
                                    label: Text('Chapters (${chapters.length})', style: const TextStyle(fontSize: 13)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ChapterPage(
                                            selectedClass: app.selectedClass,
                                            subject: subject,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal.shade700,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    ),
                                    icon: const Icon(Icons.menu_book, size: 16),
                                    label: const Text('Read Notes', style: TextStyle(fontSize: 13)),
                                    onPressed: () {
                                      final firstChapter = chapters.isNotEmpty ? chapters[0] : 'General';
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => NotesPage(
                                            selectedClass: app.selectedClass,
                                            subject: subject,
                                            chapter: firstChapter,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange.shade800,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    ),
                                    icon: const Icon(Icons.edit_note, size: 16),
                                    label: const Text('Practice Questions', style: TextStyle(fontSize: 13)),
                                    onPressed: () {
                                      final firstChapter = chapters.isNotEmpty ? chapters[0] : 'General';
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PracticePage(
                                            selectedClass: app.selectedClass,
                                            subject: subject,
                                            chapter: firstChapter,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple.shade700,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    ),
                                    icon: const Icon(Icons.timer, size: 16),
                                    label: const Text('Take Quiz', style: TextStyle(fontSize: 13)),
                                    onPressed: () {
                                      final firstChapter = chapters.isNotEmpty ? chapters[0] : 'General';
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => QuizPage(
                                            selectedClass: app.selectedClass,
                                            subject: subject,
                                            chapter: firstChapter,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryBox({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String tag,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? color : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'Tamil':
        return Colors.deepOrange;
      case 'English':
        return Colors.indigo;
      case 'Mathematics':
      case 'Business Mathematics':
        return Colors.blue;
      case 'Science':
      case 'Physics':
        return Colors.purple;
      case 'Chemistry':
        return Colors.teal;
      case 'Biology':
      case 'Botany':
      case 'Zoology':
        return Colors.green;
      case 'Social Science':
      case 'History':
        return Colors.brown;
      case 'Geography':
        return Colors.teal.shade800;
      case 'Computer Science':
      case 'Computer Applications':
        return Colors.cyan.shade800;
      case 'Accountancy':
        return Colors.amber.shade900;
      case 'Commerce':
        return Colors.pink.shade700;
      case 'Economics':
        return Colors.indigo.shade900;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'Tamil':
        return Icons.auto_stories;
      case 'English':
        return Icons.translate;
      case 'Mathematics':
      case 'Business Mathematics':
        return Icons.calculate;
      case 'Science':
      case 'Physics':
        return Icons.science;
      case 'Chemistry':
        return Icons.biotech;
      case 'Biology':
      case 'Botany':
      case 'Zoology':
        return Icons.eco;
      case 'Social Science':
      case 'History':
        return Icons.public;
      case 'Geography':
        return Icons.terrain;
      case 'Computer Science':
      case 'Computer Applications':
        return Icons.computer;
      case 'Accountancy':
        return Icons.account_balance;
      case 'Commerce':
        return Icons.storefront;
      case 'Economics':
        return Icons.trending_up;
      default:
        return Icons.book;
    }
  }
}
