import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class ColorPickerWidget extends StatefulWidget {
  final LinearGradient? selectedGradient;
  final Function(LinearGradient?) onGradientSelected;

  const ColorPickerWidget({
    Key? key,
    required this.selectedGradient,
    required this.onGradientSelected,
  }) : super(key: key);

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  bool showMoreColors = false;

  final List<LinearGradient> gradients = const [
    LinearGradient(
      colors: [Color(0xFFABDCFF), Color(0xFF0396FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),

    LinearGradient(
      colors: [Color(0xFFEE0979), Color(0xFFFF6A00)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFFE985), Color(0xFFFA742B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),

    LinearGradient(
      colors: [Color(0xFFFEB692), Color(0xFFEA5455)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFCE9FFC), Color(0xFF7367F0)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),

    LinearGradient(
      colors: [Color(0xFF81FBB8), Color(0xFF28C76F)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF90F7EC), Color(0xFF32CCBC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),

    LinearGradient(
      colors: [Color(0xFFF857A6), Color(0xFFFF5858)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),

    LinearGradient(
      colors: [Color(0xFFFDEB71), Color(0xFFF8D800)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),

    LinearGradient(
      colors: [Color(0xFF43CBFF), Color(0xFF9708CC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF5EFCE8), Color(0xFF736EFE)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFF6D365), Color(0xFFFDA085)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF84FAB0), Color(0xFF8FD3F4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFCCB90), Color(0xFFD57EEB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF00DBDE), Color(0xFFFC00FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF16A085), Color(0xFFF4D03F)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select color',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 1,
                padding: EdgeInsets.zero,
                children: [
                  for (final g in gradients.take(6))
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          widget.onGradientSelected(g);
                        },
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: g,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: identical(widget.selectedGradient, g)
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.2),
                              width: identical(widget.selectedGradient, g) ? 4 : 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  setState(() {
                    showMoreColors = !showMoreColors;
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.white.withOpacity(0.15), height: 1),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      showMoreColors ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      showMoreColors ? 'Less Colors' : 'More Colors',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        letterSpacing: 1.2,
                        color: Colors.white.withOpacity(0.75),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Divider(color: Colors.white.withOpacity(0.15), height: 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.vertical,
                    axisAlignment: -1.0,
                    child: child,
                  );
                },
                child: showMoreColors
                    ? GridView.builder(
                        key: const ValueKey('more_colors'),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 0,
                          childAspectRatio: 1,
                        ),
                        itemCount: gradients.length - 6,
                        itemBuilder: (context, index) {
                          final g = gradients[index + 6];
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                widget.onGradientSelected(g);
                              },
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: g,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: identical(widget.selectedGradient, g)
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.2),
                                    width: identical(widget.selectedGradient, g) ? 2 : 1,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

