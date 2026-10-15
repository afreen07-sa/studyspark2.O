import 'package:flutter/material.dart';
import 'data/syllabus_data.dart';
import 'models/app_state.dart';
import 'notes_page.dart';
import 'practice_page.dart';
import 'quiz_page.dart';

class SyllabusPage extends StatefulWidget {
  final String? initialClass;

  const SyllabusPage({super.key, this.initialClass});

  @override
  State<SyllabusPage> createState() => _SyllabusPageState();
}

class _SyllabusPageState extends State<SyllabusPage> {
  late String _currentClass;
  late String _currentGroup;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _currentClass = widget.initialClass ?? AppState.instance.selectedClass;
    _currentGroup = AppState.instance.selectedGroup;
  }

  @override
  Widget build(BuildContext context) {
    final isHigherSec = _currentClass == 'Class 11' || _currentClass == 'Class 12';
    final subjects = SyllabusData.getSubjects(_currentClass, group: _currentGroup);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('TN State Board Syllabus Explorer'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1050),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.indigo.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.menu_book, color: Colors.indigo, size: 28),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Tamil Nadu Samacheer Kalvi Curriculum',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Classes 6 – 12',
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Department of School Education, Government of Tamil Nadu. Classes 11 & 12 categorized with Higher Secondary academic streams.',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // CLASS SELECTOR CHIPS
                const Text(
                  'Select Class to Load Syllabus:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: SyllabusData.classes.map((cls) {
                      final isSelected = cls == _currentClass;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cls),
                          selected: isSelected,
                          selectedColor: Colors.indigo,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _currentClass = cls;
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                // GROUP SELECTOR (FOR 11TH & 12TH)
                if (isHigherSec) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.category, color: Colors.amber.shade900, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              '$_currentClass Academic Streams / Groups',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: SyllabusData.groups.keys.map((grp) {
                            final isGrpSelected = grp == _currentGroup;
                            return ChoiceChip(
                              label: Text(grp),
                              selected: isGrpSelected,
                              selectedColor: Colors.indigo.shade800,
                              labelStyle: TextStyle(
                                color: isGrpSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              onSelected: (sel) {
                                if (sel) {
                                  setState(() {
                                    _currentGroup = grp;
                                  });
                                }
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          SyllabusData.groupDescriptions[_currentGroup] ?? '',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey.shade800,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // SEARCH BAR
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search chapters or topics in $_currentClass...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim().toLowerCase();
                    });
                  },
                ),

                const SizedBox(height: 24),

                // SUBJECT ACCORDIONS & CHAPTERS
                ...subjects.map((subject) {
                  final allChapters = SyllabusData.getChapters(_currentClass, subject);
                  final filteredChapters = _searchQuery.isEmpty
                      ? allChapters
                      : allChapters
                          .where((c) => c.toLowerCase().contains(_searchQuery))
                          .toList();

                  if (_searchQuery.isNotEmpty && filteredChapters.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 1.5,
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.book, color: Colors.indigo),
                      ),
                      title: Text(
                        subject,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${filteredChapters.length} Chapters • Tamil Nadu State Board Syllabus',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                      children: [
                        const Divider(height: 1),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredChapters.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, cIdx) {
                            final chapter = filteredChapters[cIdx];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                              leading: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.indigo.shade50,
                                child: Text(
                                  '${cIdx + 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                              title: Text(
                                chapter,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              trailing: Wrap(
                                spacing: 6,
                                children: [
                                  IconButton(
                                    tooltip: 'Read Notes',
                                    icon: const Icon(Icons.menu_book, color: Colors.teal, size: 20),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => NotesPage(
                                            selectedClass: _currentClass,
                                            subject: subject,
                                            chapter: chapter,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    tooltip: 'Practice Questions',
                                    icon: const Icon(Icons.edit_note, color: Colors.orange, size: 20),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PracticePage(
                                            selectedClass: _currentClass,
                                            subject: subject,
                                            chapter: chapter,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    tooltip: 'Take Quiz',
                                    icon: const Icon(Icons.timer, color: Colors.purple, size: 20),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => QuizPage(
                                            selectedClass: _currentClass,
                                            subject: subject,
                                            chapter: chapter,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
