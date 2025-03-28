import 'package:dafa_cricket/services/affirmation_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dafa_cricket/core/models/affirmation_model.dart';

class AffirmationsScreen extends StatefulWidget {
  const AffirmationsScreen({super.key});

  @override
  State<AffirmationsScreen> createState() => _AffirmationsScreenState();
}

class _AffirmationsScreenState extends State<AffirmationsScreen> {
  late Box<AffirmationRecord> _affirmationsBox;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final AffirmationService _affirmationService = AffirmationService();

  // Обновленная цветовая схема
  static const Color _primaryBlue = Color(0xFF1E3D59);
  static const Color _secondaryBlue = Color(0xFF17C3B2);
  static const Color _goldLight = Color(0xFFFFD700);
  static const Color _goldDark = Color(0xFFDAA520);
  static const Color _surfaceColor = Colors.white;

  final List<AffirmationCard> _cards = [
    AffirmationCard(
      text: "I deserve the space to grow and learn to become my best self",
      gradient: const LinearGradient(
        colors: [Color(0xFF6C5CE7), Color(0xFFA8A4E6)],
      ),
    ),
    AffirmationCard(
      text: "I am perfect, whole, and complete",
      gradient: const LinearGradient(
        colors: [Color(0xFF00B894), Color(0xFF00CEC9)],
      ),
    ),
    AffirmationCard(
      text: "I am allowed to ask for what I need",
      gradient: const LinearGradient(
        colors: [Color(0xFFFDCB6E), Color(0xFFFFE5A0)],
      ),
    ),
    AffirmationCard(
      text: "My net worth is not my self-worth",
      gradient: const LinearGradient(
        colors: [Color(0xFFFF7675), Color(0xFFFFA8A8)],
      ),
    ),
    AffirmationCard(
      text: "I am capable and competent in my job",
      gradient: const LinearGradient(
        colors: [Color(0xFF74B9FF), Color(0xFFA8E6FF)],
      ),
    ),
    AffirmationCard(
      text: "Together, we can overcome any challenge",
      gradient: const LinearGradient(
        colors: [Color(0xFF6C5CE7), Color(0xFFA8A4E6)],
      ),
    ),
    AffirmationCard(
      text: "I am lucky in love, work, and all areas of my life",
      gradient: const LinearGradient(
        colors: [Color(0xFF00B894), Color(0xFF00CEC9)],
      ),
    ),
    AffirmationCard(
      text: "I am achieving my career goals",
      gradient: const LinearGradient(
        colors: [Color(0xFFFDCB6E), Color(0xFFFFE5A0)],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _affirmationsBox = Hive.box('affirmations');
    _initializeAffirmations();
  }

  Future<void> _initializeAffirmations() async {
    if (_affirmationsBox.isEmpty) {
      await _affirmationsBox.addAll([
        AffirmationRecord(
          id: '1',
          text: 'I deserve the space to grow and learn to become my best self',
        ),
        AffirmationRecord(id: '2', text: 'I am perfect, whole, and complete'),
      ]);
    }
  }

  Future<void> _markAsFavorite(String id) async {
    final index = _affirmationsBox.values.toList().indexWhere(
      (a) => a.id == id,
    );
    if (index != -1) {
      final affirmation = _affirmationsBox.getAt(index);
      await _affirmationsBox.putAt(
        index,
        AffirmationRecord(
          id: affirmation!.id,
          text: affirmation.text,
          isFavorite: !affirmation.isFavorite,
          completionDates: affirmation.completionDates,
        ),
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
              Column(
                children: [
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
                    child: Column(
                      children: [
                        Text(
                          'Daily Affirmations',
                          style: TextStyle(
                            color: _primaryBlue,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Repeat affirmations every day to improve your mental state and boost your confidence',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildPageIndicator(),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _cards.length,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildAffirmationCard(_cards[index]),
                        );
                      },
                    ),
                  ),
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
                    child: Text(
                      'Affirmations - the key to a good mood',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _primaryBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(_cards.length, (int index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  _currentPage == index
                      ? _secondaryBlue
                      : Colors.white.withOpacity(0.3),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAffirmationCard(AffirmationCard card) {
    return Container(
      decoration: BoxDecoration(
        gradient: card.gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: card.gradient.colors.first.withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Декоративный элемент
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.2), Colors.transparent],
                ),
              ),
            ),
          ),
          // Контент
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  card.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Добавить функционал для отметки аффирмации
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: card.gradient.colors.first,
                    minimumSize: const Size(120, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Mark as Done',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AffirmationCard {
  final String text;
  final LinearGradient gradient;

  AffirmationCard({required this.text, required this.gradient});
}
