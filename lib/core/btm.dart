import 'package:flutter/material.dart';

class TamplateDownBar extends StatelessWidget {
  const TamplateDownBar({
    super.key,
    this.index = 0,
    required this.itemBuilder,
    required this.tamplatePages,
    this.onPageChanged,
  });

  final int index;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final List<PageModel> tamplatePages;
  final void Function(int index)? onPageChanged;

  // Цветовая схема
  static const Color _primaryBlue = Color(0xFF1E3D59);
  static const Color _secondaryBlue = Color(0xFF17C3B2);
  static const Color _goldLight = Color(0xFFFFD700);
  static const Color _goldDark = Color(0xFFDAA520);
  static const Color _surfaceColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
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
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(tamplatePages.length, (i) {
            final isSelected = (i == index);
            final item = tamplatePages[i];

            return GestureDetector(
              onTap: () => onPageChanged?.call(i),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? _goldLight.withOpacity(0.2)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      isSelected
                          ? Border.all(color: _goldLight.withOpacity(0.3))
                          : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.iconPath != null)
                      Image.asset(
                        item.iconPath!,
                        width: 24,
                        height: 24,
                        color:
                            isSelected
                                ? _goldLight
                                : Colors.white.withOpacity(0.7),
                      )
                    else
                      itemBuilder(context, i),
                    const SizedBox(height: 4),
                    if (item.title != null)
                      Text(
                        item.title!,
                        style: TextStyle(
                          color:
                              isSelected
                                  ? _goldLight
                                  : Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class PageModel {
  final String? iconPath;
  final String? title;
  final Widget page;

  PageModel({this.iconPath, this.title, required this.page});
}
