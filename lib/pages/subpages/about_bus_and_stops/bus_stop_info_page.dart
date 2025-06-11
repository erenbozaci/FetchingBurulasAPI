import 'dart:async';

import 'package:fetchingburulasapi/pages/components/custom_tab_bar.dart';
import 'package:fetchingburulasapi/pages/components/errors/otobus_error_component.dart';
import 'package:fetchingburulasapi/pages/components/future_builder_extended.dart';
import 'package:fetchingburulasapi/utils/duration_plus.dart';
import 'package:fetchingburulasapi/api/burulas_api.dart';
import 'package:fetchingburulasapi/models/bus_stop_data.dart';
import 'package:fetchingburulasapi/models/route_by_stop.dart';
import 'package:fetchingburulasapi/models/search/bus_stop_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class BusStopInfoPage extends StatefulWidget {
  final BusStopSearch durak;

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
                if(_streamController.isPaused) {
                  _streamController.addStream(Stream.fromFuture(
                    BurulasApi.getBusStopData(
                        widget.durak.stationId.toString())));
                }
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  durak.stationName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  "Durak Id: ${durak.stationId}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
        const Divider(),
        // Otobüsler
        _buildTabBar(durak.stationId.toString())
      ]),
    );
  }

  Widget _buildTabBar(String durakId) {
    return Expanded(
        child: CustomTabBar(
      tabs: [
        Text("Yaklaşan Otobüsler"),
        Text("Tüm otobüsler"),
      ],
      views: [
        _buildComingBusesListView(durakId),
        _buildAllBusesListView(durakId),
      ],
      onViewLoad: (i) {
        if(i == 0) {
          if (!_streamController.isClosed) _streamController.addStream(Stream.fromFuture(BurulasApi.getBusStopData(durakId)));
        }
      },
    ));
  }

  Widget _buildComingBusesListView(String durakId) {
    return StreamBuilder(
        stream: _streamController.stream.distinct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return OtobusErrorComponent(errorText: "Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.toString().isEmpty) {
            return Column(children: [
              OtobusErrorComponent(errorText: "Durak bilgisi alınırken hata oluştu.")],
            );
          } else if ((snapshot.data! as List).isEmpty) {
            return Column(
              children: [
                OtobusErrorComponent(
                    errorText: "Bu duraktan geçecek olan otobüs bulunamadı.")
              ],
            );
          } else {
            final busStopDatas = snapshot.data!;

            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: busStopDatas.length,
              itemBuilder: (context, index) {
                final busStopData = busStopDatas[index];
                return _buildComingBusesListTile(busStopData);
              },
            );
          }
        });
  }

  Widget _buildComingBusesListTile(BusStopData busStopData) {
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

  Widget _buildAllBusesListView(String durakId) {
    return FutureBuilderExtended(
        future: BurulasApi.getBusesPassingByTheStop(durakId),
        errors: FutureBuilderErrors(
            hasDataError: "Otobüsler alınırken hata oluştu.",
            isEmptyError: "Burdan geçen bir otobüs yok."),
        outputFunc: (routeByStopData) {
          final a = routeByStopData!;
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: a.length,
            itemBuilder: (context, index) {
              final routeByStop = a[index];
              return _buildAllBusesListTile(routeByStop);
            },
          );
        });
  }

  Widget _buildAllBusesListTile(RouteByStop routeByStop) {
    return ListTile(
      title: Text(routeByStop.routeCode),
      leading: Icon(Icons.directions_bus_filled_rounded),
    );
  }
}
