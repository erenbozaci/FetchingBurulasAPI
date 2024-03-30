import 'package:fetchingburulasapi/pages/ayarlar_page.dart';
import 'package:fetchingburulasapi/pages/burulasapi_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MenuPage {
  final String menuItemText;
  final Widget targetWidget;
  final Icon? icon;

  int _index = 0;

  MenuPage({required this.menuItemText, required this.targetWidget, this.icon}) {
    _index = staticIndex;
    staticIndex++;
  }

  int getIndex() {
    return _index;
  }

  static int staticIndex = 0;

}

class MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<MenuPage> pages = [
    //MenuPage(menuItemText: "Otobüs ve Güzergahlar - PetekAPI", targetWidget: const PetekAPIPage(), icon: const Icon(Icons.route_rounded)),
    MenuPage(menuItemText: "Otobüs ve Duraklar - BurulaşAPI", targetWidget: const BurulasAPIPage(), icon: const Icon(Icons.map_rounded))
  ];

  List<Widget> drawPageNavs() {
    return pages.map((page) => ListTile(
      title: Text(page.menuItemText),
      selected: _currentIndex == page.getIndex(),
      onTap: () {
        _onItemTapped(page.getIndex());
        Navigator.pop(context);
      },
      leading: page.icon,
    )).toList();
  }

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
      ),
      body: pages[_currentIndex].targetWidget,
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(child: null),
            Expanded(
              child: ListView(
                children: drawPageNavs()
              ),
            ),
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
