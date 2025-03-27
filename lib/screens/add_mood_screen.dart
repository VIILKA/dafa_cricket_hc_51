import 'package:dafa_cricket/core/models/emotion_model.dart';
import 'package:dafa_cricket/services/emotion_service.dart';
import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:intl/intl.dart';
import 'package:dafa_cricket/core/models/trigger_model.dart';
import 'package:dafa_cricket/services/trigger_service.dart';

class AddMoodScreen extends StatefulWidget {
  final String initialMood;
  final DateTime selectedDate;
  final List<String>? initialReasons;
  final String? initialComment;
  final String? selectedTriggerListId;

  const AddMoodScreen({
    required this.initialMood,
    required this.selectedDate,
    this.initialReasons,
    this.initialComment,
    this.selectedTriggerListId,
    super.key,
  });

  @override
  State<AddMoodScreen> createState() => _AddMoodScreenState();
}

class _AddMoodScreenState extends State<AddMoodScreen> {
  late DateTime _selectedDate;
  late String? _selectedMood;
  final List<String> _reasons = [];
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final EmotionService _emotionService = EmotionService();
  TriggerList? _selectedTriggerList;
  final TriggerService _triggerService = TriggerService();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _selectedMood = widget.initialMood;

    // Инициализируем причины, если они переданы
    if (widget.initialReasons != null) {
      _reasons.addAll(widget.initialReasons!);
    }

    // Инициализируем комментарий, если он передан
    if (widget.initialComment != null) {
      _commentController.text = widget.initialComment!;
    }

    // Инициализируем выбранный список триггеров, если он передан
    if (widget.selectedTriggerListId != null) {
      _selectedTriggerList = _triggerService.getTriggerListById(
        widget.selectedTriggerListId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      DateFormat('EEEE, d MMMM').format(_selectedDate),
                      style: const TextStyle(
                        fontSize: 24,
                        color: Color(0xFF16151A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16151A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'My mood for today:',
                        style: TextStyle(
                          color: Color(0xFFFDF7E0),
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          final RenderBox button =
                              context.findRenderObject() as RenderBox;
                          final Offset buttonPosition = button.localToGlobal(
                            Offset.zero,
                          );
                          final Size buttonSize = button.size;

                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              buttonPosition.dx,
                              buttonPosition.dy + buttonSize.height + 5,
                              buttonPosition.dx + buttonSize.width,
                              buttonPosition.dy + buttonSize.height + 200,
                            ),
                            items: [
                              PopupMenuItem(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEE7700),
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'Angry',
                                        style: TextStyle(
                                          color: Color(0xFF16151A),
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedMood = 'Angry';
                                  });
                                },
                              ),
                              PopupMenuItem(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFBD751),
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'Happy',
                                        style: TextStyle(
                                          color: Color(0xFF16151A),
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedMood = 'Happy';
                                  });
                                },
                              ),
                              PopupMenuItem(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF8EAF3C),
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'Sadness',
                                        style: TextStyle(
                                          color: Color(0xFF16151A),
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedMood = 'Sadness';
                                  });
                                },
                              ),
                              PopupMenuItem(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF548BA5),
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'Worry',
                                        style: TextStyle(
                                          color: Color(0xFF16151A),
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedMood = 'Worry';
                                  });
                                },
                              ),
                            ],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: const Color(0xFFFDF7E0),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _getMoodColor(_selectedMood ?? 'Angry'),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _getMoodIcon(_selectedMood ?? 'Angry'),
                                size: 37,
                                color: const Color(0xFF16151A),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _selectedMood ?? 'Angry',
                                    style: const TextStyle(
                                      color: Color(0xFF16151A),
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_upward,
                                    size: 18,
                                    color: Color(0xFF16151A),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Because:',
                        style: TextStyle(
                          color: Color(0xFFFDF7E0),
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF7E0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _reasonController,
                                decoration: const InputDecoration(
                                  hintText:
                                      'Start typing reasons why your mood is so...',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_reasonController.text.isNotEmpty) {
                                  setState(() {
                                    _reasons.add(_reasonController.text);
                                    _reasonController.clear();
                                  });
                                }
                              },
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF16151A),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Color(0xFFFDF7E0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_reasons.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children:
                              _reasons.map((reason) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFDF7E0),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        reason,
                                        style: const TextStyle(
                                          color: Color(0xFF16151A),
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _reasons.remove(reason);
                                          });
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Color(0xFF16151A),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16151A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My comment:',
                        style: TextStyle(
                          color: Color(0xFFFDF7E0),
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF7E0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _commentController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Start typing...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16151A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose list of triggers:',
                        style: TextStyle(
                          color: Color(0xFFFDF7E0),
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF7E0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            _triggerService.hasAnyTriggerLists()
                                ? DropdownButtonHideUnderline(
                                  child: DropdownButton<TriggerList>(
                                    value: _selectedTriggerList,
                                    hint: const Text(
                                      'Select a trigger list',
                                      style: TextStyle(
                                        color: Color(0xFF16151A),
                                        fontSize: 14,
                                      ),
                                    ),
                                    isExpanded: true,
                                    items:
                                        _triggerService
                                            .getAllTriggerLists()
                                            .map((list) {
                                              return DropdownMenuItem<
                                                TriggerList
                                              >(
                                                value: list,
                                                child: Text(
                                                  list.name,
                                                  style: const TextStyle(
                                                    color: Color(0xFF16151A),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            })
                                            .toList(),
                                    onChanged: (list) {
                                      setState(() {
                                        _selectedTriggerList = list;
                                      });
                                    },
                                  ),
                                )
                                : const Text(
                                  'You don\'t have any list triggers. You can create it on the main page',
                                  style: TextStyle(
                                    color: Color(0xFF16151A),
                                    fontSize: 14,
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_selectedMood != null) {
                      final emotion = EmotionRecord(
                        emotion: _selectedMood!,
                        date: _selectedDate,
                        reasons: _reasons,
                        comment:
                            _commentController.text.isEmpty
                                ? null
                                : _commentController.text,
                        triggerList: _selectedTriggerList?.id,
                      );

                      await _emotionService.addEmotion(emotion);
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9A0104),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Add Mood',
                    style: TextStyle(color: Color(0xFFFDF7E0), fontSize: 17),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Angry':
        return const Color(0xFFEE7700);
      case 'Happy':
        return const Color(0xFFFBD751);
      case 'Sadness':
        return const Color(0xFF8EAF3C);
      case 'Worry':
        return const Color(0xFF548BA5);
      default:
        return const Color(0xFFEE7700);
    }
  }

  IconData _getMoodIcon(String mood) {
    switch (mood) {
      case 'Angry':
        return Icons.mood_bad;
      case 'Happy':
        return Icons.mood;
      case 'Sadness':
        return Icons.sentiment_dissatisfied;
      case 'Worry':
        return Icons.sentiment_neutral;
      default:
        return Icons.mood_bad;
    }
  }
}
