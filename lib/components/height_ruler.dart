import 'dart:math';

import 'package:flutter/material.dart';

class HeightRuler extends StatefulWidget {
  /// Height stored internally in centimeters.
  final double heightCm;

  /// Minimum selectable height.
  final int minHeight;

  /// Maximum selectable height.
  final int maxHeight;

  /// Called whenever the selected height changes.
  final ValueChanged<double> onChanged;

  const HeightRuler({
    super.key,
    required this.heightCm,
    required this.onChanged,
    this.minHeight = 100,
    this.maxHeight = 220,
  });

  @override
  State<HeightRuler> createState() => _HeightRulerState();
}

class _HeightRulerState extends State<HeightRuler> {
  //--------------------------------------------------------
  // Constants
  //--------------------------------------------------------

  static const double _itemWidth = 14.0;

  static const double _viewportFraction = .12;

  //--------------------------------------------------------
  // Controller
  //--------------------------------------------------------

  late final FixedExtentScrollController _scrollController;

  //--------------------------------------------------------
  // Current selected height
  //--------------------------------------------------------

  late int _selectedHeight;

  //--------------------------------------------------------
  // Getters
  //--------------------------------------------------------

  int get _totalItems =>
      widget.maxHeight - widget.minHeight + 1;

  int get _initialIndex =>
      widget.heightCm.round() - widget.minHeight;

  //--------------------------------------------------------
  // Lifecycle
  //--------------------------------------------------------

  @override
  void initState() {
    super.initState();

    _selectedHeight = widget.heightCm.round();

    _scrollController = FixedExtentScrollController(
      initialItem: _initialIndex,
    );
  }

  @override
  void didUpdateWidget(covariant HeightRuler oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Parent updated the height.
    if (oldWidget.heightCm != widget.heightCm) {
      _selectedHeight = widget.heightCm.round();

      final index =
          _selectedHeight - widget.minHeight;

      if (_scrollController.hasClients) {
        _scrollController.animateToItem(
          index,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //--------------------------------------------------------
  // Public Helpers
  //--------------------------------------------------------

  int indexToHeight(int index) {
    return widget.minHeight + index;
  }

  int heightToIndex(double height) {
    return height.round() - widget.minHeight;
  }

  //--------------------------------------------------------
  // Selection
  //--------------------------------------------------------

  void _onSelectedItemChanged(int index) {
    final value = indexToHeight(index);

    if (value == _selectedHeight) return;

    setState(() {
      _selectedHeight = value;
    });

    widget.onChanged(value.toDouble());
  }

  //--------------------------------------------------------
  // Build
  //--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [

          /// Wheel
          ListWheelScrollView.useDelegate(
            controller: _scrollController,
            itemExtent: _itemWidth,
            diameterRatio: 100,
            perspective: 0.001,
            physics: const FixedExtentScrollPhysics(),
            squeeze: 1.0,
            onSelectedItemChanged:
            _onSelectedItemChanged,

            childDelegate: ListWheelChildBuilderDelegate(
              childCount: _totalItems,

              builder: (context, index) {

                /// Part-2
                /// We'll build the ruler tick here.
                return const SizedBox.shrink();
              },
            ),
          ),

          /// Center indicator
          IgnorePointer(
            child: Container(
              width: 3,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xff5A7F38),
                borderRadius:
                BorderRadius.circular(100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}