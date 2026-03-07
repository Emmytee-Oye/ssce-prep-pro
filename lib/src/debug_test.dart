import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

// ── Temporary Debug Screen ────────────────────────────────────────────────────
// Add this as the home screen temporarily to test JSON loading.
// Replace your home with this, run the app, and tell me what you see.

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  String _result = 'Tap the button to test JSON loading...';
  bool _loading  = false;

  Future<void> _testLoad() async {
    setState(() {
      _loading = true;
      _result  = 'Testing...';
    });

    final tests = <String>[];

    // Test 1: Try loading mathematics.json
    try {
      final raw = await rootBundle.loadString('assets/questions/mathematics.json');
      final data = json.decode(raw);
      final count = (data['questions'] as List).length;
      tests.add('✅ mathematics.json loaded! ($count questions)');
    } catch (e) {
      tests.add('❌ mathematics.json FAILED: $e');
    }

    // Test 2: Try loading mathematics_theory.json
    try {
      final raw = await rootBundle.loadString('assets/questions/mathematics_theory.json');
      final data = json.decode(raw);
      final count = (data['questions'] as List).length;
      tests.add('✅ mathematics_theory.json loaded! ($count questions)');
    } catch (e) {
      tests.add('❌ mathematics_theory.json FAILED: $e');
    }

    // Test 3: Try a wrong path to confirm error message
    try {
      await rootBundle.loadString('assets/questions/wrongfile.json');
      tests.add('❌ wrongfile.json should have failed but did not!');
    } catch (e) {
      tests.add('✅ Wrong path correctly fails (expected)');
    }

    setState(() {
      _loading = false;
      _result  = tests.join('\n\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Debug Test'),
        backgroundColor: const Color(0xFF2D4A8A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This screen tests if your JSON files are loading correctly.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _loading ? null : _testLoad,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D4A8A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Run JSON Test', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2D4A8A).withOpacity(0.2)),
              ),
              child: Text(
                _result,
                style: const TextStyle(fontSize: 14, height: 1.6, fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}