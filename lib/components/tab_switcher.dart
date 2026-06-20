import 'package:flutter/material.dart';

class TabSwitcher extends StatelessWidget {
  const TabSwitcher({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    this.tabs = const ["Login", "Sign Up"],
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    final int count = tabs.length;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double slotWidth = constraints.maxWidth / count;

          return Stack(
            children: [
              // Sliding pill behind the active tab.
              AnimatedAlign(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                alignment: Alignment(
                  count == 1 ? 0 : (-1 + (2 * selectedIndex) / (count - 1)),
                  0,
                ),
                child: Container(
                  width: slotWidth,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              // Tap targets + labels on top.
              Row(
                children: List.generate(count, (index) {
                  final bool isSelected = index == selectedIndex;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(index),
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        height: 40,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: isSelected ? Colors.black : Colors.black54,
                            ),
                            child: Text(tabs[index]),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
