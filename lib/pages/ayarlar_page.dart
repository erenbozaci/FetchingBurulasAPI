import 'package:fetchingburulasapi/models/ayarlar.dart';
import 'package:fetchingburulasapi/storage/AyarlarStorage.dart';
import 'package:flutter/material.dart';

class AyarlarPage extends StatefulWidget {
  const AyarlarPage({super.key});

  @override
  State<AyarlarPage> createState() => AyarlarPageState();
}

class AyarlarPageState extends State<AyarlarPage> {

  late Ayarlar ayarlar;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getAyarlar();
  }

  void getAyarlar() async {
    loading = true;
    AyarlarStorage.getAyarlar().then((ayarlarData) {
      loading = false;
      setState(() {
        ayarlar = ayarlarData;
        print(ayarlarData.mainLong);
      });
    });
  }

  void setAyarlar() async {
    AyarlarStorage.writeAyarlar(ayarlar);
  }

  @override
  Widget build(BuildContext context) {
    if(loading) return const Center(child: CircularProgressIndicator(),);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlar"),
      ),
      body: Container (
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          const ListTile(
            title: Text("Harita"),
            subtitle: Divider(),
          ),
          TextFormField(
            initialValue: ayarlar.mainLat.toString(),
            maxLength: 20,
            decoration: const InputDecoration(
              labelText: 'Latitude',
              contentPadding: EdgeInsets.all(5.0)
            ),
            onChanged: (value) {
              ayarlar.setMainLat(double.parse(value));
            },
          ),
          TextFormField(
            initialValue: ayarlar.mainLong.toString(),
            maxLength: 20,
            decoration: const InputDecoration(
                labelText: 'Longitude',
                contentPadding: EdgeInsets.all(5.0)
            ),
            onChanged: (value) {
              ayarlar.setMainLong(double.parse(value));
            },
          ),
          ElevatedButton(onPressed: () {
            setAyarlar();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Başarıyla Kaydedildi!")));
          }, child: const Text("Kaydet"))
        ]),
      ),
    );
  }
}
