import 'package:dafa_cricket/screens/add_mood_screen.dart';
import 'package:dafa_cricket/screens/list_of_triggers_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:dafa_cricket/services/emotion_service.dart';
import 'package:dafa_cricket/core/models/emotion_model.dart';
import 'package:dafa_cricket/services/trigger_service.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dafa_cricket/core/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EmotionService _emotionService = EmotionService();
  final TriggerService _triggerService = TriggerService();
  DateTime _selectedDate = DateTime.now();
  late Box<UserProfile> _userBox;
  String _firstName = 'User';
  String _avatarPath = 'assets/images/avatar.png';

  // Кэш эмоций для календаря
  final Map<DateTime, EmotionRecord> _dateEmotionsCache = {};

  // Это эмоция, которая была выбрана для текущего дня (если есть)
  EmotionRecord? _dayEmotion;

  // Обновленная цветовая схема
  static const Color _primaryBlue = Color(0xFF1E3D59);
  static const Color _secondaryBlue = Color(0xFF17C3B2);
  static const Color _goldLight = Color(0xFFFFD700);
  static const Color _goldDark = Color(0xFFDAA520);
  static const Color _surfaceColor = Colors.white;

  // Обновленные цвета эмоций
  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Angry':
        return const Color(0xFFFF6B6B); // coral red
      case 'Happy':
        return const Color(0xFF4ECDC4); // turquoise
      case 'Sadness':
        return const Color(0xFF96A7CF); // dusty blue
      case 'Worry':
        return const Color(0xFFFFD93D); // warm yellow
      default:
        return const Color(0xFFF0F3F8);
    }
  }

  @override
  void initState() {
    super.initState();
    _userBox = Hive.box('user');
    _loadUserProfile();
    _loadDayEmotion();
    _preloadEmotionsForCalendar();
  }

  // Загружаем данные пользователя
  void _loadUserProfile() {
    final user = _userBox.get('current_user');
    if (user != null) {
      setState(() {
        _firstName = user.firstName.isNotEmpty ? user.firstName : 'User';
        _avatarPath =
            user.avatarPath.isNotEmpty
                ? user.avatarPath
                : 'assets/images/avatar.png';
      });
    }
  }

  // Предзагрузка эмоций для отображения в календаре
  void _preloadEmotionsForCalendar() {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 15));
    final endDate = now.add(const Duration(days: 15));

    // Очищаем кэш
    _dateEmotionsCache.clear();

    // Для каждого дня загружаем эмоции
    for (
      var date = startDate;
      date.isBefore(endDate);
      date = date.add(const Duration(days: 1))
    ) {
      final dateKey = DateTime(date.year, date.month, date.day);
      final emotions = _emotionService.getEmotionsForDate(dateKey);
      if (emotions.isNotEmpty) {
        _dateEmotionsCache[dateKey] = emotions.first;
      }
    }

    setState(() {});
  }

  void _loadDayEmotion() {
    // Получаем эмоцию на выбранную дату
    final emotions = _emotionService.getEmotionsForDate(_selectedDate);
    if (emotions.isNotEmpty) {
      setState(() {
        _dayEmotion = emotions.first;
      });
    } else {
      setState(() {
        _dayEmotion = null;
      });
    }
  }

  // Получаем объект EasyDayProps для дня календаря
  EasyDayProps _getDayProps(DateTime date) {
    // Приводим дату к формату без времени для сравнения
    final dateKey = DateTime(date.year, date.month, date.day);
    final hasEmotion = _dateEmotionsCache.containsKey(dateKey);

    // Определяем цвет фона в зависимости от наличия эмоции
    Color backgroundColor = const Color(0xFFFDF7E0); // дефолтный цвет

    // Если есть эмоция для даты - используем её цвет
    if (hasEmotion) {
      final emotion = _dateEmotionsCache[dateKey]!;
      backgroundColor = _getMoodColor(emotion.emotion);
    }

    return EasyDayProps(
      width: 43,
      height: 66,
      dayStructure: DayStructure.dayNumDayStr,
      activeDayStyle: DayStyle(
        dayNumStyle: const TextStyle(color: Color(0xFF16151A), fontSize: 17),
        dayStrStyle: const TextStyle(color: Color(0xFF16151A), fontSize: 17),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF9A0104)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
      inactiveDayStyle: DayStyle(
        dayNumStyle: const TextStyle(color: Color(0xFF16151A), fontSize: 17),
        dayStrStyle: const TextStyle(color: Color(0xFF16151A), fontSize: 17),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Создаем градиентный фон
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Верхняя панель
                Container(
                  margin: const EdgeInsets.all(16),
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
                    border: Border.all(
                      color: _goldLight.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _primaryBlue,
                              _secondaryBlue.withOpacity(0.8),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: _surfaceColor,
                          child: CircleAvatar(
                            radius: 26,
                            backgroundImage: AssetImage(_avatarPath),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _firstName,
                              style: const TextStyle(
                                color: Color(0xFF2D3142),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const ListOfTriggersScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.add_circle_outline,
                            color: _primaryBlue,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Календарь с новым дизайном
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 4),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Your Mood Calendar',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      EasyDateTimeLine(
                        initialDate: _selectedDate,
                        onDateChange: (selectedDate) {
                          setState(() {
                            _selectedDate = selectedDate;
                          });
                          _loadDayEmotion();
                        },
                        activeColor: _primaryBlue,
                        dayProps: EasyDayProps(
                          height: 68,
                          width: 56,
                          dayStructure: DayStructure.dayNumDayStr,
                          inactiveDayStyle: DayStyle(
                            borderRadius: 16,
                            dayNumStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            dayStrStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          activeDayStyle: DayStyle(
                            dayNumStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            dayStrStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [_primaryBlue, _secondaryBlue],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: _primaryBlue.withOpacity(0.3),
                                  offset: const Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Секция настроения
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 4),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child:
                      _dayEmotion == null
                          ? _buildMoodSelection()
                          : _buildMoodDetails(),
                ),

                // Секция List of triggers
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 4),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My list of triggers',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const ListOfTriggersScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.add_circle_outline,
                                color: _primaryBlue,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: Future.value(
                          _triggerService
                              .getAllTriggerLists()
                              .map(
                                (list) => {
                                  'name': list.name,
                                  'triggers': list.triggers,
                                },
                              )
                              .toList(),
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          final triggerLists = snapshot.data ?? [];
                          if (triggerLists.isEmpty) {
                            return Center(
                              child: Text(
                                'No trigger lists yet',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }

                          return Column(
                            children:
                                triggerLists.map((list) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                list['name'] ?? 'Unnamed List',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              if (list['triggers'] != null) ...[
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${(list['triggers'] as List).length} triggers',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: Colors.grey[400],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'How are you feeling?',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildMoodCard(
              'Happy',
              _getMoodColor('Happy'),
              '😊',
              isSelected: false,
              onTap: () => _navigateToAddMood('Happy'),
            ),
            _buildMoodCard(
              'Angry',
              _getMoodColor('Angry'),
              '😠',
              isSelected: false,
              onTap: () => _navigateToAddMood('Angry'),
            ),
            _buildMoodCard(
              'Sad',
              _getMoodColor('Sadness'),
              '😔',
              isSelected: false,
              onTap: () => _navigateToAddMood('Sadness'),
            ),
            _buildMoodCard(
              'Worried',
              _getMoodColor('Worry'),
              '😟',
              isSelected: false,
              onTap: () => _navigateToAddMood('Worry'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMoodCard(
    String text,
    Color color,
    String emoji, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              offset: const Offset(0, 8),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddMood(String mood) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                AddMoodScreen(initialMood: mood, selectedDate: _selectedDate),
      ),
    ).then((_) {
      _loadDayEmotion();
      _preloadEmotionsForCalendar();
    });
  }

  Widget _buildMoodDetails() {
    Color moodColor;
    String moodEmoji;

    switch (_dayEmotion!.emotion) {
      case 'Sadness':
        moodColor = const Color(0xFF6C5CE7);
        moodEmoji = '😔';
        break;
      case 'Happy':
        moodColor = const Color(0xFF00B894);
        moodEmoji = '😊';
        break;
      case 'Worry':
        moodColor = const Color(0xFFFDCB6E);
        moodEmoji = '😟';
        break;
      case 'Angry':
        moodColor = const Color(0xFFFF7675);
        moodEmoji = '😠';
        break;
      default:
        moodColor = const Color(0xFFA8A8A8);
        moodEmoji = '😐';
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [moodColor.withOpacity(0.9), moodColor.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: moodColor.withOpacity(0.3),
              offset: const Offset(0, 8),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Mood',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat('MMM d, y').format(_selectedDate),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(moodEmoji, style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 8),
                    Text(
                      _dayEmotion!.emotion,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_dayEmotion!.reasons != null &&
                _dayEmotion!.reasons!.isNotEmpty) ...[
              Text(
                'Reasons',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    _dayEmotion!.reasons!.map((reason) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          reason,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
            if (_dayEmotion!.comment != null &&
                _dayEmotion!.comment!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Comment',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _dayEmotion!.comment!,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AddMoodScreen(
                          initialMood: _dayEmotion!.emotion,
                          selectedDate: _selectedDate,
                          initialReasons: _dayEmotion!.reasons,
                          initialComment: _dayEmotion!.comment,
                          selectedTriggerListId: _dayEmotion!.triggerList,
                        ),
                  ),
                ).then((_) {
                  _loadDayEmotion();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: moodColor,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Edit Mood',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final Color goldColor;
  final Color blueColor;

  BackgroundPainter({required this.goldColor, required this.blueColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    // Рисуем золотые волнистые линии
    paint.color = goldColor.withOpacity(0.2);
    _drawWavyLine(canvas, size, 0.3, paint);
    _drawWavyLine(canvas, size, 0.7, paint);

    // Рисуем синие волнистые линии
    paint.color = blueColor.withOpacity(0.2);
    _drawWavyLine(canvas, size, 0.4, paint);
    _drawWavyLine(canvas, size, 0.8, paint);
  }

  void _drawWavyLine(
    Canvas canvas,
    Size size,
    double heightFactor,
    Paint paint,
  ) {
    final path = Path();
    final height = size.height * heightFactor;
    path.moveTo(0, height);

    for (double i = 0; i < size.width; i += 30) {
      path.quadraticBezierTo(i + 15, height - 20, i + 30, height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
