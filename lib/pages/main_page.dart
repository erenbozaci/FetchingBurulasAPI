import 'package:fetchingburulasapi/pages/ayarlar_page.dart';
import 'package:fetchingburulasapi/pages/guzergahlar_page.dart';
import 'package:fetchingburulasapi/pages/map_page.dart';
import 'package:fetchingburulasapi/pages/widgets/bus_search_widget.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MapPage(),
    const GuzergahlarPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_currentIndex == 0)
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: BusSearchComponent());
                },
                icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: _pages[_currentIndex],
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(child: null),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: const Text('Harita'),
                    selected: _currentIndex == 0,
                    onTap: () {
                      _onItemTapped(0);
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.map_rounded),
                  ),
                  ListTile(
                    title: const Text('Otobüsler ve Güzergahlar'),
                    selected: _currentIndex == 1,
                    onTap: () {
                      _onItemTapped(1);
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.route_rounded),
                  ),
                ],
              ),
            ),
            // Footer buttons
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Ayarlar'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AyarlarPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.close),
                    title: const Text('Menüyü Kapat'),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Center(child: Text("by Eren Bozaci")),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
