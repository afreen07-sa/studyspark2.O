import 'package:flutter/material.dart';
import 'data/syllabus_data.dart';
import 'models/app_state.dart';
import 'group_page.dart';
import 'category_page.dart';

class ClassPage extends StatelessWidget {
  final String? initialClass;

  const ClassPage({super.key, this.initialClass});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Choose Class / Grade'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.indigo.shade100),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.indigo),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tamil Nadu State Board (Samacheer Kalvi) syllabus covers Classes 6 through 12. Classes 11 & 12 feature specific Higher Secondary Groups.',
                        style: TextStyle(fontSize: 14, color: Colors.indigo),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ...SyllabusData.classes.map((cls) {
                final isHigherSec = cls == 'Class 11' || cls == 'Class 12';
                final isSelected = cls == (initialClass ?? AppState.instance.selectedClass);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isSelected ? Colors.indigo : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  elevation: isSelected ? 3 : 1,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: isHigherSec ? Colors.indigo.shade100 : Colors.blue.shade100,
                      child: Icon(
                        isHigherSec ? Icons.account_balance : Icons.school,
                        color: isHigherSec ? Colors.indigo.shade800 : Colors.blue.shade800,
                      ),
                    ),
                    title: Text(
                      cls,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      isHigherSec
                          ? 'Higher Secondary • 5 Specialized Groups (Bio-Maths, CS, Commerce, etc.)'
                          : 'General Secondary • Core Subjects (Tamil, English, Maths, Science, Social)',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isHigherSec)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade700,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Choose Group',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
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
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const CategoryPage()),
                          (route) => route.isFirst,
                        );
                      }
                    },
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
