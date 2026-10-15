import 'package:flutter/material.dart';
import 'data/syllabus_data.dart';
import 'models/app_state.dart';
import 'category_page.dart';

class GroupPage extends StatelessWidget {
  final String selectedClass;

  const GroupPage({
    super.key,
    required this.selectedClass,
  });

  @override
  Widget build(BuildContext context) {
    final groups = SyllabusData.groups.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('$selectedClass • Choose Higher Secondary Group'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.indigo.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tamil Nadu State Board $selectedClass Stream Classification',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Select your academic stream to load the exact syllabus, core subjects, chapter notes, and practice question sets for your Higher Secondary board exams.',
                      style: TextStyle(fontSize: 13.5, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ...groups.map((group) {
                final subjects = SyllabusData.groups[group] ?? [];
                final desc = SyllabusData.groupDescriptions[group] ?? '';
                final isSelected = group == AppState.instance.selectedGroup;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected ? Colors.indigo : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.school, color: Colors.indigo, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    group,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '$selectedClass Stream',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected ? Colors.green.shade700 : Colors.indigo.shade700,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                AppState.instance.updateStudent(
                                  className: selectedClass,
                                  group: group,
                                );
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => const CategoryPage()),
                                  (route) => route.isFirst,
                                );
                              },
                              child: Text(isSelected ? 'Selected ✓' : 'Select Group'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          desc,
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.4),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Subjects Included:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: subjects.map((subj) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                subj,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}