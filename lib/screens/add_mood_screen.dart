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

  // Обновленная цветовая схема
  static const Color _primaryBlue = Color(0xFF1E3D59);
  static const Color _secondaryBlue = Color(0xFF17C3B2);
  static const Color _goldLight = Color(0xFFFFD700);
  static const Color _goldDark = Color(0xFFDAA520);
  static const Color _surfaceColor = Colors.white;

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
                          Text(
                            DateFormat('EEEE, d MMMM').format(_selectedDate),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildMoodSection(),
                      const SizedBox(height: 24),
                      _buildReasonsSection(),
                      const SizedBox(height: 24),
                      _buildCommentSection(),
                      const SizedBox(height: 24),
                      _buildTriggersSection(),
                      const SizedBox(height: 24),
                      _buildSaveButton(),
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

  Widget _buildMoodSection() {
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
            'How are you feeling?',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final Offset buttonPosition = button.localToGlobal(Offset.zero);
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
                  _buildMoodMenuItem('Angry', const Color(0xFFFF7675), '😠'),
                  _buildMoodMenuItem('Happy', const Color(0xFF00B894), '😊'),
                  _buildMoodMenuItem('Sadness', const Color(0xFF6C5CE7), '😔'),
                  _buildMoodMenuItem('Worry', const Color(0xFFFDCB6E), '😟'),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: _surfaceColor,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getMoodColor(_selectedMood ?? 'Angry').withOpacity(0.8),
                    _getMoodColor(_selectedMood ?? 'Angry').withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _getMoodColor(
                      _selectedMood ?? 'Angry',
                    ).withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getMoodEmoji(_selectedMood ?? 'Angry'),
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _selectedMood ?? 'Angry',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
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

  PopupMenuItem _buildMoodMenuItem(String mood, Color color, String emoji) {
    return PopupMenuItem(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              mood,
              style: TextStyle(
                color: _primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          _selectedMood = mood;
        });
      },
    );
  }

  Widget _buildReasonsSection() {
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
            'Why do you feel this way?',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _reasonController,
                    decoration: InputDecoration(
                      hintText: 'Add a reason...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[600]),
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _secondaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          if (_reasons.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _reasons.map((reason) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _secondaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            reason,
                            style: TextStyle(color: _primaryBlue, fontSize: 14),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _reasons.remove(reason);
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: _primaryBlue.withOpacity(0.6),
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
    );
  }

  Widget _buildCommentSection() {
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
            'Additional thoughts',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write your thoughts here...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggersSection() {
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
            'Select triggers',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child:
                _triggerService.hasAnyTriggerLists()
                    ? DropdownButtonHideUnderline(
                      child: DropdownButton<TriggerList>(
                        value: _selectedTriggerList,
                        hint: Text(
                          'Choose a trigger list',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        isExpanded: true,
                        items:
                            _triggerService.getAllTriggerLists().map((list) {
                              return DropdownMenuItem<TriggerList>(
                                value: list,
                                child: Text(
                                  list.name,
                                  style: TextStyle(
                                    color: _primaryBlue,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (list) {
                          setState(() {
                            _selectedTriggerList = list;
                          });
                        },
                      ),
                    )
                    : Text(
                      'No trigger lists available. Create one on the main page.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
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
        backgroundColor: _secondaryBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: const Text(
        'Save Mood',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
        return const Color(0xFFFF7675);
      case 'Happy':
        return const Color(0xFF00B894);
      case 'Sadness':
        return const Color(0xFF6C5CE7);
      case 'Worry':
        return const Color(0xFFFDCB6E);
      default:
        return const Color(0xFFFF7675);
    }
  }

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'Angry':
        return '😠';
      case 'Happy':
        return '😊';
      case 'Sadness':
        return '😔';
      case 'Worry':
        return '😟';
      default:
        return '😠';
    }
  }
}
