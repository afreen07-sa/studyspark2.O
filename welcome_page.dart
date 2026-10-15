import 'package:flutter/material.dart';
import 'data/syllabus_data.dart';
import 'login_page.dart';
import 'category_page.dart';
import 'group_page.dart';
import 'syllabus_page.dart';
import 'models/app_state.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school, size: 26),
            SizedBox(width: 8),
            Text(
              'StudySpark',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = MediaQuery.of(context).size.width;
              final isCompact = screenWidth < 600;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCompact)
                    IconButton(
                      icon: const Icon(Icons.menu_book, color: Colors.white),
                      tooltip: 'View Syllabus',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SyllabusPage()),
                        );
                      },
                    )
                  else
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SyllabusPage()),
                        );
                      },
                      icon: const Icon(Icons.menu_book, color: Colors.white),
                      label: const Text(
                        'View Syllabus',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade600,
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 12 : 16,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      child: Text(
                        isCompact ? 'Login' : 'Login / Sign Up',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HERO SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade800, Colors.indigo.shade600, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          '🌟 TAMIL NADU STATE BOARD • SAMACHEER KALVI 🌟',
                          style: TextStyle(
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Complete Learning Platform\nfor Classes 6 to 12',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Access the complete Tamil Nadu State Board syllabus, comprehensive chapter notes, interactive practice questions with explanations, and scored quizzes. Tailored with specific stream groups for Classes 11 & 12.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade500,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                            ),
                            icon: const Icon(Icons.rocket_launch, size: 22),
                            label: const Text(
                              'Get Started Free',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginPage()),
                              );
                            },
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white, width: 2),
                              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.explore, size: 22),
                            label: const Text(
                              'Explore Learning Dashboard',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              AppState.instance.updateStudent(
                                name: 'Guest Student',
                                className: 'Class 10',
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CategoryPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // QUICK CLASS JUMP BAR
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Your Class to Start Studying:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: SyllabusData.classes.map((cls) {
                          final isHigherSec = cls == 'Class 11' || cls == 'Class 12';
                          return InkWell(
                            onTap: () {
                              AppState.instance.updateStudent(className: cls);
                              if (isHigherSec) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => GroupPage(selectedClass: cls),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const CategoryPage()),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                              decoration: BoxDecoration(
                                color: isHigherSec ? Colors.indigo.shade50 : Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isHigherSec ? Colors.indigo.shade200 : Colors.blue.shade200,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    size: 18,
                                    color: isHigherSec ? Colors.indigo.shade800 : Colors.blue.shade800,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    cls,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isHigherSec ? Colors.indigo.shade900 : Colors.blue.shade900,
                                    ),
                                  ),
                                  if (isHigherSec) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.indigo.shade700,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Groups',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 4 CORE PILLARS / CATEGORIES OF LEARNING
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Everything You Need For TN Board Success',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Mapped meticulously to the latest Department of School Education curriculum.',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isDesktop = constraints.maxWidth > 700;
                          return GridView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isDesktop ? 2 : 1,
                              mainAxisExtent: isDesktop ? 240 : 225,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                            ),
                            children: [
                              _featureCard(
                                context,
                                icon: Icons.menu_book,
                                color: Colors.indigo,
                                title: 'Complete Syllabus 6-12',
                                description:
                                    'Accurate Tamil Nadu State Board syllabus for all classes. Classes 11 & 12 classified by Bio-Maths, Computer Science, Commerce, and Science groups.',
                                badge: 'Classes 6 to 12',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const SyllabusPage()),
                                  );
                                },
                              ),
                              _featureCard(
                                context,
                                icon: Icons.auto_stories,
                                color: Colors.teal,
                                title: 'Chapter Notes & Summaries',
                                description:
                                    'High-yield study notes, important formulas, key definitions, and exam revision points for every chapter across all core and elective subjects.',
                                badge: 'All Subjects',
                                onTap: () {
                                  AppState.instance.selectedCategory = 'Notes';
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const CategoryPage()),
                                  );
                                },
                              ),
                              _featureCard(
                                context,
                                icon: Icons.edit_note,
                                color: Colors.orange,
                                title: 'Practice Questions with Solutions',
                                description:
                                    'Curated chapter-wise practice questions with step-by-step solutions, conceptual explanations, difficulty filters, and helpful hints.',
                                badge: 'Instant Explanations',
                                onTap: () {
                                  AppState.instance.selectedCategory = 'Practice';
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const CategoryPage()),
                                  );
                                },
                              ),
                              _featureCard(
                                context,
                                icon: Icons.timer,
                                color: Colors.purple,
                                title: 'Interactive Scored Quizzes',
                                description:
                                    'Timed mock tests and chapter quizzes with real-time score calculation, pass/fail grading, accuracy analytics, and full answer review.',
                                badge: 'Vice Versa for Quiz',
                                onTap: () {
                                  AppState.instance.selectedCategory = 'Quiz';
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const CategoryPage()),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 48),

            // FOOTER
            Container(
              width: double.infinity,
              color: const Color(0xFF0F172A),
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: const [
                          Icon(Icons.school, color: Colors.amber, size: 24),
                          Text(
                            'StudySpark Tamil Nadu State Board Learning System',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tamil Nadu Samacheer Kalvi Education • Classes 6, 7, 8, 9, 10, 11 & 12 • All Academic Streams\nDesigned for students, teachers, and self-learners across Tamil Nadu.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 13, height: 1.6),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        '© 2026 StudySpark. All Rights Reserved.',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required String badge,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.5, color: Colors.grey.shade700, height: 1.4),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Explore now',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
