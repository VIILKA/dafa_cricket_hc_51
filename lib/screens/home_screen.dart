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

  // Получаем цвет для эмоции
  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Angry':
        return const Color(0xFFEE7700); // оранжевый (злость)
      case 'Happy':
        return const Color(0xFFFBD751); // желтый (счастье)
      case 'Sadness':
        return const Color(0xFF8EAF3C); // зеленый (грусть)
      case 'Worry':
        return const Color(0xFF548BA5); // синий (беспокойство)
      default:
        return const Color(0xFFFDF7E0); // дефолтный цвет фона
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
    // Обновим внешний вид дней в соответствии с эмоциями
    _updateDayPropsColors();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7E0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Профиль пользователя
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(_avatarPath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Good morning!\n$_firstName',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xFF16151A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Календарь дней с кастомным отображением
                EasyDateTimeLine(
                  initialDate: _selectedDate,
                  onDateChange: (selectedDate) {
                    setState(() {
                      _selectedDate = selectedDate;
                      _loadDayEmotion();
                    });
                  },
                  headerProps: const EasyHeaderProps(showHeader: false),
                  activeColor: const Color(0xFF9A0104),
                  dayProps: EasyDayProps(
                    width: 43,
                    height: 66,
                    dayStructure: DayStructure.dayNumDayStr,
                    activeDayStyle: DayStyle(
                      dayNumStyle: const TextStyle(
                        color: Color(0xFF16151A),
                        fontSize: 17,
                      ),
                      dayStrStyle: const TextStyle(
                        color: Color(0xFF16151A),
                        fontSize: 17,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF9A0104)),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    inactiveDayStyle: DayStyle(
                      dayNumStyle: const TextStyle(
                        color: Color(0xFF16151A),
                        fontSize: 17,
                      ),
                      dayStrStyle: const TextStyle(
                        color: Color(0xFF16151A),
                        fontSize: 17,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF7E0),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Если на выбранную дату есть запись эмоции
                if (_dayEmotion != null)
                  _buildMoodDisplay()
                // Иначе отображаем выбор настроения
                else
                  _buildMoodSelection(),

                const SizedBox(height: 20),

                // Контейнер со списком триггеров
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9A0104),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'My list of triggers',
                            style: TextStyle(
                              color: Color(0xFFFDF7E0),
                              fontSize: 17,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const ListOfTriggersScreen(),
                                ),
                              ).then((_) {
                                setState(() {});
                              });
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Color(0xFFFDF7E0),
                            ),
                          ),
                        ],
                      ),
                      _triggerService.hasAnyTriggerLists()
                          ? Column(
                            children:
                                _triggerService.getAllTriggerLists().map((
                                  list,
                                ) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 9,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFDF7E0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list.name,
                                          style: const TextStyle(
                                            color: Color(0xFF16151A),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Wrap(
                                          spacing: 4,
                                          runSpacing: 4,
                                          children:
                                              list.triggers.map((trigger) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 5,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFEEE9D0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    trigger,
                                                    style: const TextStyle(
                                                      color: Color(0xFF16151A),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          )
                          : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF7E0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'You don\'t have any list of triggers. Let\'s create it!',
                              style: TextStyle(
                                color: Color(0xFF16151A),
                                fontSize: 14,
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Виджет для отображения выбора настроения
  Widget _buildMoodSelection() {
    String? selectedMood;

    return StatefulBuilder(
      builder:
          (context, setState) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today, I am',
                style: TextStyle(fontSize: 24, color: Color(0xFF16151A)),
              ),
              const SizedBox(height: 15),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
                children: [
                  _buildMoodCard(
                    'Sadness',
                    const Color(0xFF8EAF3C),
                    '😔',
                    isSelected: selectedMood == 'Sadness',
                    onTap: () {
                      setState(() {
                        selectedMood = 'Sadness';
                      });
                    },
                  ),
                  _buildMoodCard(
                    'Happy',
                    const Color(0xFFFBD751),
                    '😊',
                    isSelected: selectedMood == 'Happy',
                    onTap: () {
                      setState(() {
                        selectedMood = 'Happy';
                      });
                    },
                  ),
                  _buildMoodCard(
                    'Worry',
                    const Color(0xFF548BA5),
                    '😟',
                    isSelected: selectedMood == 'Worry',
                    onTap: () {
                      setState(() {
                        selectedMood = 'Worry';
                      });
                    },
                  ),
                  _buildMoodCard(
                    'Angry',
                    const Color(0xFFEE7700),
                    '😠',
                    isSelected: selectedMood == 'Angry',
                    onTap: () {
                      setState(() {
                        selectedMood = 'Angry';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    selectedMood == null
                        ? null
                        : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => AddMoodScreen(
                                    initialMood: selectedMood!,
                                    selectedDate: _selectedDate,
                                  ),
                            ),
                          ).then((_) {
                            _loadDayEmotion();
                          });
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9A0104),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Color(0xFFFDF7E0), fontSize: 17),
                ),
              ),
            ],
          ),
    );
  }

  // Виджет для отображения уже выбранного настроения
  Widget _buildMoodDisplay() {
    Color moodColor;
    String moodEmoji;

    // Определяем цвет и эмодзи в зависимости от эмоции
    switch (_dayEmotion!.emotion) {
      case 'Sadness':
        moodColor = const Color(0xFF8EAF3C);
        moodEmoji = '😔';
        break;
      case 'Happy':
        moodColor = const Color(0xFFFBD751);
        moodEmoji = '😊';
        break;
      case 'Worry':
        moodColor = const Color(0xFF548BA5);
        moodEmoji = '😟';
        break;
      case 'Angry':
        moodColor = const Color(0xFFEE7700);
        moodEmoji = '😠';
        break;
      default:
        moodColor = const Color(0xFFEE7700);
        moodEmoji = '😐';
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF16151A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'My mood for today:',
              style: TextStyle(color: Color(0xFFFDF7E0), fontSize: 17),
            ),
            const SizedBox(height: 1),

            // Карточка настроения
            Container(
              width: 87,
              height: 90,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: moodColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(moodEmoji, style: const TextStyle(fontSize: 37)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _dayEmotion!.emotion,
                        style: const TextStyle(
                          color: Color(0xFF16151A),
                          fontSize: 14,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_up,
                        size: 14,
                        color: Color(0xFF16151A),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Раздел "Потому что"
            const Text(
              'Because:',
              style: TextStyle(color: Color(0xFFFDF7E0), fontSize: 17),
            ),
            const SizedBox(height: 8),

            if (_dayEmotion!.reasons != null &&
                _dayEmotion!.reasons!.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF7E0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children:
                      _dayEmotion!.reasons!.map((reason) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16151A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                reason,
                                style: const TextStyle(
                                  color: Color(0xFFFDF7E0),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF7E0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'No reasons specified',
                  style: TextStyle(color: Color(0xFF16151A), fontSize: 14),
                ),
              ),

            const SizedBox(height: 8),

            // Раздел комментария
            if (_dayEmotion!.comment != null &&
                _dayEmotion!.comment!.isNotEmpty) ...[
              const Text(
                'My comment:',
                style: TextStyle(color: Color(0xFFFDF7E0), fontSize: 17),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF7E0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _dayEmotion!.comment!,
                  style: const TextStyle(
                    color: Color(0xFF16151A),
                    fontSize: 14,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 10),

            // Кнопка редактирования
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
                backgroundColor: const Color(0xFF9A0104),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Edit Mood',
                style: TextStyle(color: Color(0xFFFDF7E0), fontSize: 17),
              ),
            ),
          ],
        ),
      ),
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
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border:
              isSelected
                  ? Border.all(color: const Color(0xFF9A0104), width: 2)
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 50)),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF16151A),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Вспомогательный метод для получения эмодзи эмоции
  Widget _buildEmotionEmoji(String emotion) {
    switch (emotion) {
      case 'Sadness':
        return const Text('😔', style: TextStyle(fontSize: 16));
      case 'Happy':
        return const Text('😊', style: TextStyle(fontSize: 16));
      case 'Worry':
        return const Text('😟', style: TextStyle(fontSize: 16));
      case 'Angry':
        return const Text('😠', style: TextStyle(fontSize: 16));
      default:
        return const Text('😐', style: TextStyle(fontSize: 16));
    }
  }

  // Вспомогательный метод для динамического обновления цветов дней
  void _updateDayPropsColors() {
    // Окрашиваем дни календаря перед рендером
    for (final entry in _dateEmotionsCache.entries) {
      // Получаем инстанс эмоции
      final emotion = entry.value;
      // Получаем цвет для данной эмоции
      final color = _getMoodColor(emotion.emotion);

      // Здесь можно было бы программно установить цвет дня в календаре,
      // но текущая версия библиотеки не поддерживает эту возможность.
      // В будущих версиях можно будет использовать API для программного
      // изменения цвета каждого дня.
    }
  }
}
