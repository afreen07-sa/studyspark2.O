import 'dart:async';
import 'package:flutter/material.dart';
import 'data/quiz_data.dart';
import 'models/app_state.dart';

class QuizPage extends StatefulWidget {
  final String selectedClass;
  final String subject;
  final String chapter;

  const QuizPage({
    super.key,
    this.selectedClass = 'Class 10',
    required this.subject,
    required this.chapter,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _submitted = false;
  int _score = 0;
  final List<int?> _userAnswers = [];

  // Timer
  Timer? _timer;
  int _timeLeft = 30;

  @override
  void initState() {
    super.initState();
    _questions = QuizData.getQuestions(
      widget.selectedClass,
      widget.subject,
      chapter: widget.chapter,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    if (_currentIndex < _questions.length) {
      _timeLeft = _questions[_currentIndex].timeLimitSeconds;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        if (_timeLeft > 0 && !_submitted) {
          setState(() {
            _timeLeft--;
          });
        } else if (_timeLeft <= 0 && !_submitted) {
          _submitQuestion(autoTimeOut: true);
        }
      });
    }
  }

  void _submitQuestion({bool autoTimeOut = false}) {
    _timer?.cancel();
    setState(() {
      _submitted = true;
      _userAnswers.add(_selectedAnswer);
      if (_selectedAnswer != null &&
          _selectedAnswer == _questions[_currentIndex].answer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex++;
      _selectedAnswer = null;
      _submitted = false;
    });

    if (_currentIndex < _questions.length) {
      _startTimer();
    } else {
      AppState.instance.recordQuizResult(_score, _questions.length);
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _selectedAnswer = null;
      _submitted = false;
      _score = 0;
      _userAnswers.clear();
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFinished = _currentIndex >= _questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('${widget.subject} • Timed Quiz'),
        backgroundColor: Colors.purple.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: isFinished ? _buildResults() : _buildQuestion(),
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
        // HEADER ROW WITH TIMER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.selectedClass} • ${widget.subject}',
                  style: TextStyle(
                    color: Colors.purple.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  widget.chapter,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _timeLeft <= 5 ? Colors.red.shade100 : Colors.purple.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _timeLeft <= 5 ? Colors.red : Colors.purple.shade200,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 18,
                    color: _timeLeft <= 5 ? Colors.red : Colors.purple.shade800,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$_timeLeft s',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: _timeLeft <= 5 ? Colors.red : Colors.purple.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // PROGRESS
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple.shade700),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${_currentIndex + 1} of ${_questions.length}',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              'Current Score: $_score',
              style: TextStyle(color: Colors.purple.shade800, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // QUESTION TEXT
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

          if (_submitted) {
            if (idx == q.answer) {
              borderColor = Colors.green;
              bgColor = Colors.green.shade50;
            } else if (isSelected) {
              borderColor = Colors.red;
              bgColor = Colors.red.shade50;
            }
          } else if (isSelected) {
            borderColor = Colors.purple.shade700;
            bgColor = Colors.purple.shade50;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _submitted
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
                          ? (_submitted && idx == q.answer
                              ? Colors.green
                              : _submitted
                                  ? Colors.red
                                  : Colors.purple.shade700)
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
                    if (_submitted && idx == q.answer)
                      const Icon(Icons.check_circle, color: Colors.green, size: 22)
                    else if (_submitted && isSelected)
                      const Icon(Icons.cancel, color: Colors.red, size: 22),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 14),

        // EXPLANATION ON SUBMIT
        if (_submitted) ...[
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
                Text(
                  _selectedAnswer == q.answer
                      ? '✓ Excellent! Correct Answer'
                      : '✕ Incorrect! Correct is: ${q.options[q.answer]}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _selectedAnswer == q.answer ? Colors.green.shade900 : Colors.red.shade900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  q.explanation,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // SUBMIT / NEXT BUTTON
        SizedBox(
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade800,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            onPressed: _submitted
                ? _nextQuestion
                : _selectedAnswer == null
                    ? null
                    : () => _submitQuestion(),
            child: Text(
              _submitted
                  ? (_currentIndex == _questions.length - 1 ? 'View Final Results' : 'Next Question')
                  : 'Submit Answer',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final pct = (_score / _questions.length * 100).round();
    final isPassed = pct >= 60;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: isPassed ? Colors.green.shade100 : Colors.orange.shade100,
            child: Icon(
              isPassed ? Icons.emoji_events : Icons.refresh,
              size: 56,
              color: isPassed ? Colors.green.shade700 : Colors.orange.shade800,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            isPassed ? 'Congratulations! Quiz Passed 🏆' : 'Quiz Completed!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            '${widget.selectedClass} • ${widget.subject} • ${widget.chapter}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // SCORE BOX
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(6),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '$_score / ${_questions.length}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade800,
                      ),
                    ),
                    const Text('Total Score', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                Column(
                  children: [
                    Text(
                      '$pct%',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isPassed ? Colors.green : Colors.red,
                      ),
                    ),
                    const Text('Accuracy', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                Column(
                  children: [
                    Text(
                      isPassed ? 'PASSED' : 'REVISE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isPassed ? Colors.green.shade800 : Colors.orange.shade800,
                      ),
                    ),
                    const Text('Status', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // REVIEW ALL ANSWERS
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Detailed Question Review:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_questions.length, (idx) {
            final q = _questions[idx];
            final userAns = idx < _userAnswers.length ? _userAnswers[idx] : null;
            final isCorrect = userAns == q.answer;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.cancel,
                          color: isCorrect ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Q${idx + 1}: ${q.question}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Answer: ${userAns != null ? q.options[userAns] : "Not answered"}',
                      style: TextStyle(
                        color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (!isCorrect)
                      Text(
                        'Correct Answer: ${q.options[q.answer]}',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      'Explanation: ${q.explanation}',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _restartQuiz,
                  child: const Text('Retake Quiz', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to Chapter', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
