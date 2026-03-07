import 'package:flutter/material.dart';
import 'package:ssce_prep_pro/src/features/quiz/screens/question_model.dart';

class TheoryScreen extends StatefulWidget {
  final String subject;
  final Color color;
  final List<TheoryQuestion> questions;

  const TheoryScreen({
    super.key,
    required this.subject,
    required this.color,
    required this.questions,
  });

  @override
  State<TheoryScreen> createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen> {
  final Set<int> _revealedAnswers = {};

  void _toggleAnswer(int index) {
    setState(() {
      if (_revealedAnswers.contains(index)) {
        _revealedAnswers.remove(index);
      } else {
        _revealedAnswers.add(index);
      }
    });
  }

  void _revealAll() => setState(() {
        for (int i = 0; i < widget.questions.length; i++) {
          _revealedAnswers.add(i);
        }
      });

  void _hideAll() => setState(() => _revealedAnswers.clear());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.subject),
            const Text('Theory Questions',
                style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
            onSelected: (value) {
              if (value == 'reveal') _revealAll();
              if (value == 'hide') _hideAll();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: 'reveal', child: Text('Reveal All Answers')),
              const PopupMenuItem(
                  value: 'hide', child: Text('Hide All Answers')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: widget.color,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline_rounded,
                      color: Colors.white, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Attempt each question in your notebook first, then tap "Show Answer" to check.',
                      style: TextStyle(
                          fontSize: 12, color: Colors.white, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: widget.questions.length,
              itemBuilder: (context, index) {
                final question = widget.questions[index];
                final isRevealed = _revealedAnswers.contains(index);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                    color: widget.color.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                    child: Text('${index + 1}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: widget.color))),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  question.question,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A2E),
                                      height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey.shade100),
                        InkWell(
                          onTap: () => _toggleAnswer(index),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Icon(
                                    isRevealed
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    color: widget.color,
                                    size: 18),
                                const SizedBox(width: 8),
                                Text(isRevealed ? 'Hide Answer' : 'Show Answer',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: widget.color)),
                                const Spacer(),
                                Icon(
                                    isRevealed
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    color: widget.color,
                                    size: 20),
                              ],
                            ),
                          ),
                        ),
                        if (isRevealed)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: widget.color.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: widget.color.withOpacity(0.2)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Icon(Icons.check_circle_rounded,
                                      color: widget.color, size: 16),
                                  const SizedBox(width: 6),
                                  Text('Model Answer',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: widget.color)),
                                ]),
                                const SizedBox(height: 10),
                                Text(question.answer,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF1A1A2E),
                                        height: 1.6)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
