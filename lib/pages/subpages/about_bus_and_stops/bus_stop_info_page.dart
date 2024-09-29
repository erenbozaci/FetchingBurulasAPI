import 'dart:async';

import 'package:fetchingburulasapi/classes/duration_plus.dart';
import 'package:fetchingburulasapi/fetch/burulas_api.dart';
import 'package:fetchingburulasapi/models/bus_stop_data.dart';
import 'package:fetchingburulasapi/models/search/search_durak.dart';
import 'package:fetchingburulasapi/pages/widgets/components/errors/otobus_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class BusStopInfoPage extends StatefulWidget {
  final SearchDurak durak;

  const BusStopInfoPage({super.key, required this.durak});

  @override
  BusStopInfoPageState createState() => BusStopInfoPageState();
}

class BusStopInfoPageState extends State<BusStopInfoPage> {
  late MapController _mapController;
  late Timer _timer;

  final StreamController<BusStopDataList> _streamController =
      StreamController.broadcast();

  @override
  void initState() {
    _mapController = MapController();
    _getBusStopDataPeriodicly(secs: 60);
    super.initState();
  }
  @override
  void dispose() {
    _mapController.dispose();
    _streamController.close();
    _timer.cancel();
    super.dispose();
  }

  void _getBusStopDataPeriodicly({required int secs}) {
    _timer = periodicTimer(Duration(seconds: secs), (timer) {
      _streamController.addStream(Stream.fromFuture(
          BurulasApi.getBusStopData(widget.durak.stationId.toString())));
    }, onStart: true);
  }

  Timer periodicTimer(Duration duration, void Function(Timer timer) callback,
      {bool onStart = false}) {
    var result = Timer.periodic(duration, callback);
    if (onStart) {
      Timer(Duration.zero, () {
        if (result.isActive) callback(result);
      });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final durak = widget.durak;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Durak Bilgisi"),
        actions: [
          IconButton(
              onPressed: () {
                _streamController.addStream(Stream.fromFuture(
                    BurulasApi.getBusStopData(widget.durak.stationId.toString())));
              },
              icon: const Icon(Icons.refresh_rounded))
        ],
      ),
      body: Column(children: [
        //Başlık
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  durak.stationName,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  "Durak Id: ${durak.stationId}",
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
        const Divider(),
        // Otobüsler
        _buildListView(durak.stationId.toString())
      ]),
    );
  }

  Widget _buildListView(String durakId) {
    return StreamBuilder(
        stream: _streamController.stream.distinct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return OtobusErrorWidget(errorText: "Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.toString().isEmpty) {
            return OtobusErrorWidget(
                errorText: "Durak bilgisi alınırken hata oluştu.");
          } else if ((snapshot.data! as List).isEmpty) {
            return OtobusErrorWidget(
                errorText: "Bu duraktan geçecek olan otobüs bulunamadı.");
          } else {
            final busStopDatas = snapshot.data!;

            return Expanded(
              flex: 1,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: busStopDatas.length,
                  itemBuilder: (context, index) {
                    final busStopData = busStopDatas[index];
                    return _buildListTile(busStopData);
                  },
                ));
          }
        });
  }

  Widget _buildListTile(BusStopData busStopData) {
    return ListTile(
      title: Text(busStopData.routeCode),
      subtitle: Text(busStopData.routeTitle),
      trailing: Text(
        "${DurationPlus.parseDuration(busStopData.passTime).inMinutes}dk",
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        //Otobüs Bilgisi
      },
    );
  }
}
