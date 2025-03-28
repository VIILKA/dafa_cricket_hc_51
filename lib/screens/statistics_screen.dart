import 'package:dafa_cricket/services/emotion_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final EmotionService _emotionService = EmotionService();
  String _selectedPeriod = 'Week';

  // Обновленная цветовая схема
  static const Color _primaryBlue = Color(0xFF1E3D59);
  static const Color _secondaryBlue = Color(0xFF17C3B2);
  static const Color _goldLight = Color(0xFFFFD700);
  static const Color _goldDark = Color(0xFFDAA520);
  static const Color _surfaceColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _primaryBlue,
              _primaryBlue.withOpacity(0.8),
              _secondaryBlue.withOpacity(0.3),
                        ],
                      ),
                    ),
        child: SafeArea(
          child: Stack(
                      children: [
              // Декоративные элементы
              Positioned(
                top: -50,
                right: -30,
                            child: Container(
                  width: 200,
                  height: 200,
                              decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _goldLight.withOpacity(0.2),
                        _goldDark.withOpacity(0.1),
                      ],
                                  ),
                                ),
                              ),
                            ),
              Positioned(
                bottom: 100,
                left: -50,
                            child: Container(
                  width: 150,
                  height: 150,
                              decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _secondaryBlue.withOpacity(0.2),
                        _primaryBlue.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
              // Основной контент
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Statistics',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildPeriodSelector(),
                      const SizedBox(height: 24),
                      _buildMoodDistribution(),
                      const SizedBox(height: 24),
                      _buildMoodTrend(),
                      const SizedBox(height: 24),
                      _buildMostCommonMoods(),
                      const SizedBox(height: 24),
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

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surfaceColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _goldLight.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: _goldLight.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time Period',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [_buildPeriodButton('Week', Icons.calendar_today)]),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period, IconData icon) {
    final isSelected = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = period;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? _secondaryBlue : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? _secondaryBlue : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : _primaryBlue,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                period,
                style: TextStyle(
                  color: isSelected ? Colors.white : _primaryBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodDistribution() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surfaceColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _goldLight.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: _goldLight.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Distribution',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 40,
                    title: '40%',
                    color: const Color(0xFFFF7675),
                    radius: 100,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 30,
                    title: '30%',
                    color: const Color(0xFF00B894),
                    radius: 100,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 20,
                    title: '20%',
                    color: const Color(0xFF6C5CE7),
                    radius: 100,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 10,
                    title: '10%',
                    color: const Color(0xFFFDCB6E),
                    radius: 100,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('Happy', const Color(0xFF00B894)),
              _buildLegendItem('Sad', const Color(0xFF6C5CE7)),
              _buildLegendItem('Angry', const Color(0xFFFF7675)),
              _buildLegendItem('Worry', const Color(0xFFFDCB6E)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: _primaryBlue, fontSize: 12)),
      ],
    );
  }

  Widget _buildMoodTrend() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surfaceColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _goldLight.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: _goldLight.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Trend',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 4),
                      const FlSpot(2, 2),
                      const FlSpot(3, 5),
                      const FlSpot(4, 3),
                      const FlSpot(5, 4),
                    ],
                    isCurved: true,
                    color: _secondaryBlue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: _secondaryBlue.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMostCommonMoods() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surfaceColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _goldLight.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: _goldLight.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Most Common Moods',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildMoodItem('Happy', 40, const Color(0xFF00B894)),
          const SizedBox(height: 12),
          _buildMoodItem('Sad', 30, const Color(0xFF6C5CE7)),
          const SizedBox(height: 12),
          _buildMoodItem('Angry', 20, const Color(0xFFFF7675)),
          const SizedBox(height: 12),
          _buildMoodItem('Worry', 10, const Color(0xFFFDCB6E)),
        ],
      ),
    );
  }

  Widget _buildMoodItem(String mood, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              mood,
              style: TextStyle(
                color: _primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                color: _primaryBlue.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
