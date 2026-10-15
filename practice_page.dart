import 'package:flutter/material.dart';
import 'data/practice_data.dart';
import 'quiz_page.dart';

class PracticePage extends StatefulWidget {
  final String selectedClass;
  final String subject;
  final String chapter;

  const PracticePage({
    super.key,
    this.selectedClass = 'Class 10',
    required this.subject,
    required this.chapter,
  });

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  late List<PracticeQuestion> _questions;
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _checked = false;
  int _score = 0;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    _questions = PracticeData.getQuestions(
      widget.selectedClass,
      widget.subject,
      chapter: widget.chapter,
    );
  }

  void _checkAnswer() {
    if (_selectedAnswer == null || _checked) return;
    setState(() {
      _checked = true;
      if (_selectedAnswer == _questions[_currentIndex].answer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex++;
      _selectedAnswer = null;
      _checked = false;
      _showHint = false;
    });
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _selectedAnswer = null;
      _checked = false;
      _score = 0;
      _showHint = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final finished = _currentIndex >= _questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Practice Questions'),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: finished ? _buildResults() : _buildQuestion(),
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    final q = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        // CHAPTER INFO
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${widget.selectedClass} • ${widget.subject}',
                style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: q.difficulty == 'Easy'
                    ? Colors.green.shade50
                    : q.difficulty == 'Medium'
                        ? Colors.amber.shade50
                        : Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Difficulty: ${q.difficulty}',
                style: TextStyle(
                  color: q.difficulty == 'Easy'
                      ? Colors.green.shade800
                      : q.difficulty == 'Medium'
                          ? Colors.amber.shade900
                          : Colors.red.shade800,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          widget.chapter,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 16),

        // PROGRESS
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade700),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Question ${_currentIndex + 1} of ${_questions.length}',
          style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 20),

        // QUESTION CARD
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Text(
              q.question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.5,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // OPTIONS
        ...List.generate(q.options.length, (idx) {
          final isSelected = _selectedAnswer == idx;
          Color borderColor = Colors.grey.shade300;
          Color bgColor = Colors.white;

          if (_checked) {
            if (idx == q.answer) {
              borderColor = Colors.green;
              bgColor = Colors.green.shade50;
            } else if (isSelected) {
              borderColor = Colors.red;
              bgColor = Colors.red.shade50;
            }
          } else if (isSelected) {
            borderColor = Colors.orange.shade700;
            bgColor = Colors.orange.shade50;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _checked
                  ? null
                  : () {
                      setState(() {
                        _selectedAnswer = idx;
                      });
                    },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: isSelected
                          ? (_checked && idx == q.answer
                              ? Colors.green
                              : _checked
                                  ? Colors.red
                                  : Colors.orange.shade700)
                          : Colors.grey.shade200,
                      child: Text(
                        String.fromCharCode(65 + idx),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        q.options[idx],
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                    if (_checked && idx == q.answer)
                      const Icon(Icons.check_circle, color: Colors.green, size: 22)
                    else if (_checked && isSelected)
                      const Icon(Icons.cancel, color: Colors.red, size: 22),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 12),

        // HINT BUTTON
        if (q.hint.isNotEmpty && !_checked) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: Icon(
                _showHint ? Icons.lightbulb : Icons.lightbulb_outline,
                color: Colors.amber.shade800,
                size: 18,
              ),
              label: Text(
                _showHint ? 'Hide Hint' : 'Show Hint',
                style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                setState(() {
                  _showHint = !_showHint;
                });
              },
            ),
          ),
          if (_showHint)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, size: 18, color: Colors.amber.shade900),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      q.hint,
                      style: TextStyle(fontSize: 13, color: Colors.amber.shade900),
                    ),
                  ),
                ],
              ),
            ),
        ],

        // EXPLANATION
        if (_checked) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _selectedAnswer == q.answer ? Colors.green.shade50 : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _selectedAnswer == q.answer ? Colors.green.shade200 : Colors.blue.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _selectedAnswer == q.answer ? Icons.check_circle : Icons.info,
                      color: _selectedAnswer == q.answer ? Colors.green : Colors.blue.shade800,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _selectedAnswer == q.answer ? 'Correct Answer!' : 'Explanation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _selectedAnswer == q.answer ? Colors.green.shade900 : Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  q.explanation,
                  style: const TextStyle(fontSize: 14.5, height: 1.5, color: Color(0xFF1E293B)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
        ],

        // ACTION BUTTON
        SizedBox(
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _checked ? Colors.indigo.shade700 : Colors.orange.shade800,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            onPressed: _checked
                ? _nextQuestion
                : _selectedAnswer == null
                    ? null
                    : _checkAnswer,
            child: Text(
              _checked
                  ? (_currentIndex == _questions.length - 1 ? 'View Results' : 'Next Question')
                  : 'Check Answer',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final pct = (_score / _questions.length * 100).round();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor: Colors.amber.shade100,
            child: const Icon(Icons.emoji_events, size: 54, color: Colors.amber),
          ),
          const SizedBox(height: 20),
          const Text(
            'Practice Completed!',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.selectedClass} • ${widget.subject}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '$_score / ${_questions.length}',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                    const Text('Questions Correct', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                Column(
                  children: [
                    Text(
                      '$pct%',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: pct >= 60 ? Colors.green : Colors.red,
                      ),
                    ),
                    const Text('Accuracy', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _restart,
                  child: const Text('Try Again', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  icon: const Icon(Icons.timer, size: 18),
                  label: const Text('Take Quiz Now', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizPage(
                          selectedClass: widget.selectedClass,
                          subject: widget.subject,
                          chapter: widget.chapter,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Chapters'),
          ),
        ],
      ),
    );
  }
}