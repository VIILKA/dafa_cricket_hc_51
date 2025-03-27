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

  final List<AffirmationCard> _cards = [
    AffirmationCard(
      text: "I deserve the space to grow and learn to become my best self",
      backgroundColor: const Color(0xFFB05441),
      textColor: const Color(0xFFFBF7EE),
    ),
    AffirmationCard(
      text: "I am perfect, whole, and complete",
      backgroundColor: const Color(0xFF1F351B),
      textColor: const Color(0xFFB6F42C),
    ),
    AffirmationCard(
      text: "I am allowed to ask for what I need",
      backgroundColor: const Color(0xFFFEDB25),
      textColor: Colors.black,
    ),
    AffirmationCard(
      text: "My net worth is not my self-worth",
      backgroundColor: const Color(0xFFF3EFE6),
      textColor: const Color(0xFFC10219),
    ),
    AffirmationCard(
      text: "I am capable and competent in my job",
      backgroundColor: const Color(0xFFDBDC84),
      textColor: const Color(0xFF132718),
    ),
    AffirmationCard(
      text: "Together, we can overcome any challenge",
      backgroundColor: const Color(0xFF252423),
      textColor: const Color(0xFFF3EFE6),
    ),
    AffirmationCard(
      text: "I am lucky in love, work, and all areas of my life",
      backgroundColor: const Color(0xFF8F69FC),
      textColor: const Color(0xFFDAFC6C),
    ),
    AffirmationCard(
      text: "I am achieving my career goals",
      backgroundColor: const Color(0xFFC5192C),
      textColor: const Color(0xFFF2FD71),
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
      // Добавляем начальные аффирмации
      await _affirmationsBox.addAll([
        AffirmationRecord(
          id: '1',
          text: 'I deserve the space to grow and learn to become my best self',
        ),
        AffirmationRecord(id: '2', text: 'I am perfect, whole, and complete'),
        // Добавьте остальные аффирмации
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
    final affirmations = _affirmationService.getAllAffirmations();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7E0),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Affirmations',
              style: TextStyle(fontSize: 24, color: Color(0xFF16151A)),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 33),
              child: Text(
                'Repeat affirmations every day to improve your mental state and boost your confidence',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: Color(0xFF16151A)),
              ),
            ),
            const SizedBox(height: 20),
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
                    padding: const EdgeInsets.all(20),
                    child: _buildAffirmationCard(_cards[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Affirmations - the key to a good mood',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, color: Color(0xFF16151A)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(_cards.length, (int index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF16151A), width: 1),
            color:
                _currentPage == index
                    ? const Color(0xFFC84D4D)
                    : Colors.transparent,
          ),
        );
      }),
    );
  }

  Widget _buildAffirmationCard(AffirmationCard card) {
    return Container(
      decoration: BoxDecoration(
        color: card.backgroundColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            card.text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, color: card.textColor, height: 1.2),
          ),
        ),
      ),
    );
  }
}

class AffirmationCard {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  AffirmationCard({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });
}
