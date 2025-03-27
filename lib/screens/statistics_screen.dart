import 'package:dafa_cricket/services/emotion_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dafa_cricket/core/models/emotion_model.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final EmotionService _emotionService = EmotionService();
  bool isWeekly = true;
  Map<String, int> _stats = {};
  int _totalEmotions = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    setState(() {
      _stats = _emotionService.getEmotionStats(isWeekly);
      _totalEmotions = _emotionService.getTotalEmotions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7E0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'Statistics',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF16151A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'March 2025',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF16151A),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Transform.rotate(
                            angle: -3.14159,
                            child: const Icon(
                              Icons.arrow_upward,
                              size: 18,
                              color: Color(0xFF16151A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isWeekly = true;
                                _loadStats();
                              });
                            },
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color:
                                    isWeekly
                                        ? const Color(0xFF9A0104)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  'Weekly',
                                  style: TextStyle(
                                    color:
                                        isWeekly
                                            ? const Color(0xFFFDF7E0)
                                            : const Color(0xFF16151A),
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isWeekly = false;
                                _loadStats();
                              });
                            },
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color:
                                    !isWeekly
                                        ? const Color(0xFF9A0104)
                                        : Colors.transparent,
                                border: Border.all(
                                  color: const Color(0xFF16151A),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  'Monthly',
                                  style: TextStyle(
                                    color:
                                        !isWeekly
                                            ? const Color(0xFFFDF7E0)
                                            : const Color(0xFF16151A),
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF16151A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const Text(
                        'My emotion statistics',
                        style: TextStyle(
                          color: Color(0xFFFDF7E0),
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 220,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: const Size(204, 204),
                              painter: EmotionPieChartPainter(stats: _stats),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _totalEmotions.toString(),
                                  style: const TextStyle(
                                    color: Color(0xFFFDF7E0),
                                    fontSize: 24,
                                  ),
                                ),
                                const Text(
                                  'Emotions noted',
                                  style: TextStyle(
                                    color: Color(0xFFFDF7E0),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 15,
                        runSpacing: 15,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 80) / 2,
                            child: _buildEmotionCard(
                              icon: Icons.sentiment_very_satisfied,
                              color: const Color(0xFFFBD751),
                              days: '${_stats['Happy'] ?? 0} days',
                              emotion: 'Happy',
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 80) / 2,
                            child: _buildEmotionCard(
                              icon: Icons.mood_bad,
                              color: const Color(0xFFEE7700),
                              days: '${_stats['Angry'] ?? 0} days',
                              emotion: 'Angry',
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 80) / 2,
                            child: _buildEmotionCard(
                              icon: Icons.sentiment_dissatisfied,
                              color: const Color(0xFF8EAF73),
                              days: '${_stats['Sadness'] ?? 0} days',
                              emotion: 'Sadness',
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 80) / 2,
                            child: _buildEmotionCard(
                              icon: Icons.psychology,
                              color: const Color(0xFF548BA5),
                              days: '${_stats['Worry'] ?? 0} days',
                              emotion: 'Worry',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionCard({
    required IconData icon,
    required Color color,
    required String days,
    required String emotion,
  }) {
    return Container(
      width: 120,
      height: 140,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF7E0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, size: 53, color: color),
          const SizedBox(height: 10),
          Column(
            children: [
              Text(days, style: TextStyle(color: color, fontSize: 17)),
              Text(
                emotion,
                style: const TextStyle(color: Color(0xFF16151A), fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EmotionPieChartPainter extends CustomPainter {
  final Map<String, int> stats;

  EmotionPieChartPainter({required this.stats});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 20.0;

    if (stats.isEmpty) {
      final paint =
          Paint()
            ..color = Colors.grey.withOpacity(0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth;

      final rect = Rect.fromCircle(
        center: center,
        radius: radius - strokeWidth / 2,
      );

      canvas.drawArc(rect, 0, 2 * 3.14159, false, paint);
      return;
    }

    final colorMap = {
      'Happy': const Color(0xFFFBD751),
      'Sadness': const Color(0xFF8EAF73),
      'Worry': const Color(0xFF548BA5),
      'Angry': const Color(0xFFEE7700),
    };

    final total = stats.values.fold(0, (sum, value) => sum + value);
    if (total == 0) {
      final paint =
          Paint()
            ..color = Colors.grey.withOpacity(0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth;

      final rect = Rect.fromCircle(
        center: center,
        radius: radius - strokeWidth / 2,
      );

      canvas.drawArc(rect, 0, 2 * 3.14159, false, paint);
      return;
    }

    double startAngle = -3.14159 / 2;

    stats.forEach((emotion, count) {
      final sweepAngle = (count / total) * 2 * 3.14159;
      final color = colorMap[emotion] ?? Colors.grey;

      final paint =
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth;

      final rect = Rect.fromCircle(
        center: center,
        radius: radius - strokeWidth / 2,
      );

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

      startAngle += sweepAngle;
    });
  }

  @override
  bool shouldRepaint(EmotionPieChartPainter oldDelegate) =>
      oldDelegate.stats != stats;
}
