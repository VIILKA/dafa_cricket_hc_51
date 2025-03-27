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
      backgroundColor: const Color(0xFFFDF7E0),
      body: Stack(
        children: [
          // Skip button
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 54, right: 20),
              child: Container(
                width: 68,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFF9A0104),
                  borderRadius: BorderRadius.circular(14),
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
                      color: Color(0xFFFDF7E0),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Page View
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: Text(
                  'Monitor your mood and improve your quality of life with our app',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
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
                              ? const Color(0xFFC84D4D)
                              : Colors.black.withOpacity(0.1),
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
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9A0104),
                    borderRadius: BorderRadius.circular(14),
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
                        color: Color(0xFFFDF7E0),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.03)
          ..style = PaintingStyle.fill;

    // Рисуем точки
    for (var i = 0; i < size.width; i += 30) {
      for (var j = 0; j < size.height; j += 30) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 1, paint);
      }
    }

    // Рисуем волны внизу
    final wavePaint =
        Paint()
          ..color = const Color(0xFF1A5F7A).withOpacity(0.2)
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
