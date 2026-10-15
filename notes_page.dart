import 'package:flutter/material.dart';
import 'data/study_content.dart';
import 'data/syllabus_data.dart';
import 'practice_page.dart';
import 'quiz_page.dart';

class NotesPage extends StatefulWidget {
  final String selectedClass;
  final String subject;
  final String chapter;

  const NotesPage({
    super.key,
    this.selectedClass = 'Class 10',
    required this.subject,
    required this.chapter,
  });

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late String _currentChapter;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentChapter = widget.chapter;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _switchChapter(String newChapter) {
    setState(() {
      _currentChapter = newChapter;
    });
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notes = StudyContent.getNotes(
      widget.subject,
      _currentChapter,
      selectedClass: widget.selectedClass,
    );

    final allChapters = SyllabusData.getChapters(widget.selectedClass, widget.subject);
    final chapterList = allChapters.isNotEmpty ? allChapters : [_currentChapter];
    final currentIndex = chapterList.indexOf(_currentChapter);
    final hasPrev = currentIndex > 0;
    final hasNext = currentIndex >= 0 && currentIndex < chapterList.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Chapter Study Notes'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
        actions: [
          if (chapterList.length > 1)
            PopupMenuButton<String>(
              tooltip: 'Switch Chapter',
              icon: const Icon(Icons.list_alt, color: Colors.white),
              onSelected: _switchChapter,
              itemBuilder: (context) {
                return chapterList.map((ch) {
                  final isCurrent = ch == _currentChapter;
                  return PopupMenuItem<String>(
                    value: ch,
                    child: Row(
                      children: [
                        if (isCurrent)
                          const Icon(Icons.check, size: 18, color: Colors.indigo)
                        else
                          const SizedBox(width: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ch,
                            style: TextStyle(
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                              color: isCurrent ? Colors.indigo.shade900 : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          IconButton(
            tooltip: 'Practice Questions',
            icon: const Icon(Icons.edit_note),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PracticePage(
                    selectedClass: widget.selectedClass,
                    subject: widget.subject,
                    chapter: _currentChapter,
                  ),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Take Quiz',
            icon: const Icon(Icons.timer),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizPage(
                    selectedClass: widget.selectedClass,
                    subject: widget.subject,
                    chapter: _currentChapter,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CHAPTER HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${widget.selectedClass} • ${widget.subject}',
                              style: TextStyle(
                                color: Colors.indigo.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'Tamil Nadu Samacheer Kalvi',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _currentChapter,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // NOTES CARD
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SelectableText(
                      notes,
                      style: const TextStyle(
                        fontSize: 15.5,
                        height: 1.7,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // CHAPTER NAVIGATION (PREVIOUS / NEXT)
                if (chapterList.length > 1) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (hasPrev)
                        OutlinedButton.icon(
                          onPressed: () => _switchChapter(chapterList[currentIndex - 1]),
                          icon: const Icon(Icons.arrow_back, size: 16),
                          label: const Text('Previous Chapter'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      if (hasNext)
                        ElevatedButton.icon(
                          onPressed: () => _switchChapter(chapterList[currentIndex + 1]),
                          icon: const Icon(Icons.arrow_forward, size: 16),
                          label: const Text('Next Chapter'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo.shade800,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                // NEXT ACTION BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade800,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.edit_note, size: 20),
                        label: const Text(
                          'Practice Questions',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PracticePage(
                                selectedClass: widget.selectedClass,
                                subject: widget.subject,
                                chapter: _currentChapter,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.timer, size: 20),
                        label: const Text(
                          'Take Scored Quiz',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizPage(
                                selectedClass: widget.selectedClass,
                                subject: widget.subject,
                                chapter: _currentChapter,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}