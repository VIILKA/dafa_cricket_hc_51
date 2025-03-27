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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF9A0104),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.45),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(tamplatePages.length, (i) {
            final isSelected = (i == index);
            final item = tamplatePages[i];

            return InkWell(
              onTap: () => onPageChanged?.call(i),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.iconPath != null)
                    Image.asset(
                      item.iconPath!,
                      width: 29,
                      height: 29,
                      color:
                          isSelected
                              ? const Color(0xFFFDF7E0)
                              : const Color(0xFF16151A).withOpacity(0.15),
                    )
                  else
                    itemBuilder(context, i),
                  const SizedBox(height: 8),
                  if (item.title != null)
                    Text(
                      item.title!,
                      style: TextStyle(
                        color:
                            isSelected
                                ? const Color(0xFFFDF7E0)
                                : const Color(0xFF16151A),
                        fontSize: 17,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                ],
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
