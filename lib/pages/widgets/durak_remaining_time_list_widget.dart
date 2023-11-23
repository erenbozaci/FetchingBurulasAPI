import 'dart:async';

import 'package:fetchingburulasapi/fetch/burulas_api.dart';
import 'package:fetchingburulasapi/listeners/bus_search_notifier.dart';
import 'package:fetchingburulasapi/listeners/durak_click_notifier.dart';
import 'package:fetchingburulasapi/models/durak_data.dart';
import 'package:fetchingburulasapi/models/search/search_otobus.dart';
import 'package:fetchingburulasapi/pages/widgets/components/errors/otobus_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DurakRemainingTimeWidget extends StatefulWidget {
  final ScrollController scrollController;
  final PanelController panelController;

  const DurakRemainingTimeWidget(
      {super.key,
      required this.scrollController,
      required this.panelController});

  @override
  State<StatefulWidget> createState() => DurakRemainingTimeWidgetState();
}

class DurakRemainingTimeWidgetState extends State<DurakRemainingTimeWidget> {
  List<DurakData> _durakDatas = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void startFetchingData(String durakId) {
  //   DurakTimer.setTimer(Timer.periodic(const Duration(seconds: 30), (timer) {
  //     fetchData(durakId).then((busLocationData) {
  //       if (busLocationData.isEmpty) return timer.cancel();
  //       _durakDatas.clear();
  //       setState(() {
  //         _durakDatas = busLocationData;
  //       });
  //     }).catchError((error) {
  //       timer.cancel();
  //       throw Exception('Error fetching data: $error');
  //     });
  //   }));
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<DurakClickNotifier>(
        builder: (ctx, durakClickNotifier, child) {
      final durak = durakClickNotifier.durak;
      _durakDatas = durakClickNotifier.durakDatas;

      if (durak == null) {
        return const OtobusErrorWidget(errorText: "Durak Bulunamadı!");
      }

      return Expanded(
          child: Column(
        children: [
          Column(
            children: [
              Text(
                durak.stopName,
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                "Durak Id: ${durak.stopId}",
                style: const TextStyle(color: Colors.grey),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  durakClickNotifier.setDurak(durak);
                  !widget.panelController.isPanelOpen
                      ? widget.panelController.open()
                      : null;
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text(
                    'Yenile',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  durakClickNotifier.setIsOpened(false);
                  widget.panelController.isPanelOpen
                      ? widget.panelController.close()
                      : null;
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    side: const BorderSide(
                      color: Colors.red,
                    )),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text(
                    'Kapat',
                  ),
                ),
              ),
            ],
          ),
          buildListView(durak.stopId.toString())
        ],
      ));
    });
  }

  Widget buildListView(String durakId) {
    return FutureBuilder<List<DurakData>>(
      future: fetchData(durakId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');

            _durakDatas = snapshot.data ?? [];

            if (_durakDatas.isEmpty) {
              return const OtobusErrorWidget(
                  errorText: "Bu duraktan geçecek olan otobüs bulunamadı.");
            }

            return Expanded(
                flex: 1,
                child: ListView.builder(
                  controller: widget.scrollController,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _durakDatas.length,
                  itemBuilder: (context, index) {
                    final durakData = _durakDatas[index];
                    return buildListTile(durakData);
                  },
                ));
        }
      },
    );
  }

  Future<List<DurakData>> fetchData(String durakId) async {
    return BurulasApi.getDurakData(durakId);
  }

  Widget buildListTile(DurakData durakData) {
    return ListTile(
      title: Text(durakData.routeCode),
      subtitle: Text(durakData.routeTitle),
      trailing: Text(
        "${parseDuration(durakData.passTime).inMinutes}dk",
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        Provider.of<BusSearchNotifier>(context, listen: false)
            .setSearch(SearchOtobus.getBusFromDurakData(durakData));
        widget.panelController.close();
      },
    );
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }
}
