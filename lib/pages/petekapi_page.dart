import 'package:fetchingburulasapi/fetch/fetch_burulas_data.dart';
import 'package:fetchingburulasapi/models/otobus_guzergah.dart';
import 'package:fetchingburulasapi/pages/subpages/bus_info_page.dart';
import 'package:flutter/material.dart';

class PetekAPIPage extends StatefulWidget {
  const PetekAPIPage({super.key});

  @override
  State<PetekAPIPage> createState() => PetekAPIPageState();
}

class PetekAPIPageState extends State<PetekAPIPage> {
  List<OtobusGuzergah> items = [];
  List<OtobusGuzergah> filteredItems = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  void loadItems() {
    fetchAllBuses().then((list) {
      setState(() {
        items = list;
        filteredItems = list;
      });
    });
  }

  void _filterItems(String searchText) {
    setState(() {
      filteredItems = items
          .where((item) =>
              item.hatAdi
                  .toLowerCase()
                  .replaceAll(RegExp(r"[\-\/]+"), "")
                  .contains(searchText.toLowerCase()) ||
              item.guzergahBilgisi
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: const InputDecoration(
                labelText: 'Otobüs veya güzergah ara...',
                prefixIcon: Icon(Icons.search),
                fillColor: Colors.grey),
            onChanged: (searchText) {
              _filterItems(searchText);
            },
          ),
        ),
        drawItemList()
      ],
    );
  }

  Widget drawItemList() {
    return Expanded(
        child: ListView.separated(
          itemCount: filteredItems.length,
          itemBuilder: (ctx, index) {
            final item = filteredItems[index];
            return ListTile(
              title: Text(item.hatAdi),
              subtitle: Text(item.guzergahBilgisi),
              leading: const Icon(Icons.directions_bus_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BusInfoPage(otobus: item)),
                );
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
    ));
  }

  Future<List<OtobusGuzergah>> fetchData() async {
    items = await fetchAllBuses();
    return items;
  }
}
