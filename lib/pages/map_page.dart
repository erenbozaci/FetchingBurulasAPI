import 'package:fetchingburulasapi/listeners/durak_click_notifier.dart';
import 'package:fetchingburulasapi/pages/widgets/components/map_component.dart';
import 'package:fetchingburulasapi/pages/widgets/durak_remaining_time_list_widget.dart';
import 'package:fetchingburulasapi/pages/widgets/slideup_panel_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  MapController mapController = MapController();
  PanelController panelController = PanelController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    bool isOpened = Provider.of<DurakClickNotifier>(context).isPanelEnabled;

    final panelHeightOpen = MediaQuery.of(context).size.height * 0.7;
    final panelHeightClosed = isOpened ? MediaQuery.of(context).size.height * 0.1 : 0.0;

    if(panelController.isAttached && isOpened) panelController.open();

    return Container(
        constraints: const BoxConstraints.expand(),
        child: SlidingUpPanel(
          controller: panelController,
          defaultPanelState: PanelState.CLOSED,
          maxHeight: panelHeightOpen,
          minHeight: panelHeightClosed,
          parallaxEnabled: true,
          parallaxOffset: 0.5,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          body: const MapComponent(),
          color: Theme.of(context).primaryColor,
          panel: Column(
            children: [
              SlideUpPanelHeader(scrollController: scrollController, panelController: panelController),
              DurakRemainingTimeWidget(scrollController: scrollController, panelController: panelController)
            ],
          ),
        ));
  }
}
