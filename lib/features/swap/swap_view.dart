import 'package:flutter/material.dart';

class SwapView extends StatelessWidget {
  const SwapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: HtmlElementView(
        viewType: 'swapIFrame',
        key: UniqueKey(),
      ),
    );
  }
}
