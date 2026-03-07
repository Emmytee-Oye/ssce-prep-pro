import 'dart:async';
import 'package:flutter/material.dart';
import 'question_model.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String subject;
  final Color color;
  final List<Question> questions;

  const QuizScreen({
    super.key,
    required this.subject,
    required this.color,
    required this.questions,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex   = 0;
  int _selectedOption = -1;
  int _timeLeft       = 30;
  int _totalTime      = 900; // 15 minutes
  late Timer _timer;
  late Timer _totalTimer;
  final List<int> _userAnswers = [];

  late AnimationController _timerController;
  late Animation<double> _timerAnimation;

  // ── Guard: if questions empty, show error and pop ─────────────────────
  bool get _hasQuestions => widget.questions.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _timerAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _timerController, curve: Curves.linear),
    );

    // Only start timers if we have questions
    if (_hasQuestions) {
      _startQuestionTimer();
      _startTotalTimer();
    } else {
      // Pop back after frame is built and show error
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No questions found for ${widget.subject}. '
                'Make sure the JSON file is in assets/questions/.',
              ),
              backgroundColor: const Color(0xFFE53E3E),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  void dispose() {
    if (_hasQuestions) {
      _timer.cancel();
      _totalTimer.cancel();
    }
    _timerController.dispose();
    super.dispose();
  }

  // ── Per question 30s timer ────────────────────────────────────────────
  void _startQuestionTimer() {
    _timeLeft = 30;
    _timerController.reset();
    _timerController.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft == 0) {
        t.cancel();
        _userAnswers.add(-1);
        _advance();
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  // ── Total 15 minute timer ─────────────────────────────────────────────
  void _startTotalTimer() {
    _totalTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_totalTime == 0) {
        t.cancel();
        _timer.cancel();
        while (_userAnswers.length < widget.questions.length) {
          _userAnswers.add(-1);
        }
        _goToResults();
      } else {
        setState(() => _totalTime--);
      }
    });
  }

  void _selectOption(int index) {
    if (_selectedOption != -1) return;
    setState(() => _selectedOption = index);
  }

  void _next() {
    if (_selectedOption == -1) return;
    _timer.cancel();
    _userAnswers.add(_selectedOption);
    _advance();
  }

  void _advance() {
    if (_currentIndex + 1 >= widget.questions.length) {
      _goToResults();
    } else {
      setState(() {
        _currentIndex++;
        _selectedOption = -1;
      });
      _startQuestionTimer();
    }
  }

  void _goToResults() {
    _timer.cancel();
    _totalTimer.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          subject:     widget.subject,
          color:       widget.color,
          questions:   widget.questions,
          userAnswers: _userAnswers,
        ),
      ),
    );
  }

  // ── Colors ────────────────────────────────────────────────────────────
  Color get _questionTimerColor {
    if (_timeLeft > 20) return const Color(0xFF38A169);
    if (_timeLeft > 10) return const Color(0xFFF5A623);
    return const Color(0xFFE53E3E);
  }

  Color get _totalTimerColor {
    if (_totalTime > 300) return Colors.white;
    if (_totalTime > 120) return const Color(0xFFF5A623);
    return const Color(0xFFE53E3E);
  }

  String get _totalTimeDisplay {
    final m = _totalTime ~/ 60;
    final s = _totalTime % 60;
    if (s == 0) return m == 1 ? '1 minute left' : '$m minutes left';
    return '$m:${s.toString().padLeft(2, '0')} left';
  }

  @override
  Widget build(BuildContext context) {
    // Safety net — show loading while post-frame callback fires
    if (!_hasQuestions) {
      return Scaffold(
        backgroundColor: const Color(0xFFF0F4FF),
        appBar: AppBar(
          backgroundColor: widget.color,
          foregroundColor: Colors.white,
          title: Text('${widget.subject} • Quiz'),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded,
                  size: 64, color: const Color(0xFF9AA5B4)),
              const SizedBox(height: 16),
              const Text(
                'No questions found',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E)),
              ),
              const SizedBox(height: 8),
              Text(
                'Could not load questions for\n${widget.subject}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF9AA5B4), height: 1.5),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Go Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final question = widget.questions[_currentIndex];
    final progress = (_currentIndex + 1) / widget.questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: _showQuitDialog,
        ),
        title: Text(
          '${widget.subject} • Quiz',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_currentIndex + 1}/${widget.questions.length}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Top section: total timer + progress bar ───────
          Container(
            color: widget.color,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: _totalTimerColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: _totalTimerColor.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer_rounded,
                          color: _totalTimerColor, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _totalTimeDisplay,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _totalTimerColor,
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),

          // ── Questions + options ───────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentIndex + 1}',
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9AA5B4),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 52,
                        height: 52,
                        child: Stack(
                          children: [
                            AnimatedBuilder(
                              animation: _timerAnimation,
                              builder: (_, __) => CircularProgressIndicator(
                                value: _timerAnimation.value,
                                strokeWidth: 4,
                                backgroundColor:
                                    const Color(0xFF9AA5B4).withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    _questionTimerColor),
                              ),
                            ),
                            Center(
                              child: Text(
                                '$_timeLeft',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: _questionTimerColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Question card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              color: widget.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Text(
                              '${_currentIndex + 1}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: widget.color),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          question.question,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A2E),
                              height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Options
                  ...List.generate(
                    question.options.length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _OptionTile(
                        label: ['A', 'B', 'C', 'D'][i],
                        text: question.options[i],
                        isSelected: _selectedOption == i,
                        isDisabled:
                            _selectedOption != -1 && _selectedOption != i,
                        color: widget.color,
                        onTap: () => _selectOption(i),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Next / Submit button ──────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _selectedOption != -1 ? _next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  disabledBackgroundColor:
                      const Color(0xFF9AA5B4).withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  _currentIndex + 1 == widget.questions.length
                      ? 'Submit Quiz'
                      : 'Next Question',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuitDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Quit Quiz?',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Your progress will be lost if you quit now.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53E3E)),
            child: const Text('Quit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Option tile ───────────────────────────────────────────────────────────────
class _OptionTile extends StatelessWidget {
  final String label;
  final String text;
  final bool isSelected;
  final bool isDisabled;
  final Color color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.text,
    required this.isSelected,
    required this.isDisabled,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color
                : const Color(0xFF9AA5B4).withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? color : const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color:
                        isSelected ? Colors.white : const Color(0xFF4A5568),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color:
                      isSelected ? color : const Color(0xFF1A1A2E),
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: color, size: 22),
          ],
        ),
      ),
    );
  }
}