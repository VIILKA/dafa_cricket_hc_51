import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dafa_cricket/core/config/config.dart';
import 'package:dafa_cricket/core/parent_screen/parent_screen.dart';

class TamplateOnb extends StatefulWidget {
  const TamplateOnb({super.key});

  @override
  State<TamplateOnb> createState() => _OnbState();
}

class _OnbState extends State<TamplateOnb> {
  late PageController _tamplateOnbPageController;
  bool tamplateIsLastPage = false;

  // Color scheme
  static const Color primaryBlue = Color(0xFF1E3D59);
  static const Color secondaryBlue = Color(0xFF17C3B2);
  static const Color goldLight = Color(0xFFFFD700);
  static const Color goldDark = Color(0xFFDAA520);
  static const Color surfaceColor = Colors.white;

  @override
  void initState() {
    _tamplateOnbPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tamplateOnbPageController.dispose();
    super.dispose();
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
              primaryBlue,
              primaryBlue.withOpacity(0.8),
              secondaryBlue.withOpacity(0.3),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative elements
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
                      goldLight.withOpacity(0.2),
                      goldDark.withOpacity(0.1),
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
                      secondaryBlue.withOpacity(0.2),
                      primaryBlue.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 54, right: 20),
                child: Container(
                  width: 68,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const ParentScreen()),
                        (_) => false,
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Main content
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _tamplateOnbPageController,
                    onPageChanged: (index) {
                      setState(() => tamplateIsLastPage = index == 3);
                    },
                    children: tamplateOnbList,
                  ),
                ),
                // Description text
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Monitor your mood and improve your quality of life with our app',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 47),
                // Pagination
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => Container(
                      width:
                          _tamplateOnbPageController.hasClients &&
                                  index ==
                                      _tamplateOnbPageController.page?.round()
                              ? 20
                              : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color:
                            _tamplateOnbPageController.hasClients &&
                                    index ==
                                        _tamplateOnbPageController.page?.round()
                                ? goldLight
                                : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Next button
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Container(
                    width: 335,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [goldLight, goldDark]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: goldLight.withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 20,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (tamplateIsLastPage) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ParentScreen(),
                            ),
                            (_) => false,
                          );
                        } else {
                          _tamplateOnbPageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        tamplateIsLastPage ? 'Begin' : 'Next',
                        style: const TextStyle(
                          color: primaryBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
    );
  }
}

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.05)
          ..style = PaintingStyle.fill;

    // Draw dots
    for (var i = 0; i < size.width; i += 30) {
      for (var j = 0; j < size.height; j += 30) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 1, paint);
      }
    }

    // Draw waves at the bottom
    final wavePaint =
        Paint()
          ..color = const Color(0xFF1A5F7A).withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height * 0.8);

    for (var i = 0; i < size.width; i++) {
      path.lineTo(i.toDouble(), size.height * 0.8 + sin(i / 30) * 20);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
