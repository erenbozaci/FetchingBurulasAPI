import 'package:fetchingburulasapi/pages/subpages/about_settings/map_options_page.dart';
import 'package:flutter/material.dart';

class AyarlarPage extends StatefulWidget {
  const AyarlarPage({super.key});

  @override
  State<AyarlarPage> createState() => AyarlarPageState();
}

class AyarlarPageState extends State<AyarlarPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlar"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            children: [
              drawSettingsButton(
                title: "Harita Ayarları",
                subTitle: "Latitude, Longitude",
                leading: const Icon(Icons.map_rounded),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MapOptionsPage()));
                },
              )
            ],
          ),
        )
    );
  }

  Widget drawSettingsButton({
    required String title,
    required String subTitle,
    required void Function() onTap,
    required Icon leading
}) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
      onTap: onTap,
      leading: leading,
      trailing: const Icon(Icons.chevron_right),
      tileColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0), // if you need this
      ),
    );
  }
}
