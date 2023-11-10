import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlideUpPanelHeader extends StatelessWidget {
  final ScrollController scrollController;
  final PanelController panelController;

  const SlideUpPanelHeader(
      {super.key,
      required this.scrollController,
      required this.panelController});

  void togglePanel() => panelController.isPanelOpen
      ? panelController.close()
      : panelController.open();

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          Column(
            children: [
              const SizedBox(height: 12),
              GestureDetector(
                child: Center(
                  child: Container(
                    width: 30,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                onTap: () => togglePanel(),
              ),
              const SizedBox(height: 12),
            ],
          )
        ]);
  }
}
