import 'dart:async';

import 'package:fetchingburulasapi/classes/duration_plus.dart';
import 'package:fetchingburulasapi/fetch/burulas_api.dart';
import 'package:fetchingburulasapi/models/durak_data.dart';
import 'package:fetchingburulasapi/models/search/search_durak.dart';
import 'package:fetchingburulasapi/pages/widgets/components/errors/otobus_error_widget.dart';
import 'package:flutter/material.dart';

class DurakInfoPage extends StatefulWidget {
  final SearchDurak durak;

  const DurakInfoPage({super.key, required this.durak});

  @override
  DurakInfoPageState createState() => DurakInfoPageState();
}

class DurakInfoPageState extends State<DurakInfoPage> {
  @override
  Widget build(BuildContext context) {
    final durak = widget.durak;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Durak Bilgisi"),
        actions: [
          IconButton(onPressed: () {
            setState(() {});
          }, icon: const Icon(Icons.refresh_rounded))
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
        buildListView(durak.stationId.toString())
      ]),
    );
  }

  Widget buildListView(String durakId) {
    return StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 30)),
        builder: (context, snapshot) {
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

                  final durakDatas = snapshot.data ?? [];

                  if (durakDatas.isEmpty) {
                    return const OtobusErrorWidget(errorText: "Bu duraktan geçecek olan otobüs bulunamadı.");
                  }

                  return Expanded(
                      child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: durakDatas.length,
                    itemBuilder: (context, index) {
                      final durakData = durakDatas[index];
                      return buildListTile(durakData);
                    },
                  ));
              }
            },
          );
        });
  }

  Widget buildListTile(DurakData durakData) {
    return ListTile(
      title: Text(durakData.routeCode),
      subtitle: Text(durakData.routeTitle),
      trailing: Text(
        "${DurationPlus.parseDuration(durakData.passTime).inMinutes}dk",
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        //Otobüs Bilgisi
      },
    );
  }

  Future<List<DurakData>> fetchData(String durakId) async {
    return await BurulasApi.getDurakData(durakId);
  }
}
