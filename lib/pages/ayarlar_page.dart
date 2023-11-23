import 'package:fetchingburulasapi/models/ayarlar.dart';
import 'package:fetchingburulasapi/storage/ayarlar_storage.dart';
import 'package:flutter/material.dart';

class AyarlarPage extends StatefulWidget {
  const AyarlarPage({super.key});

  @override
  State<AyarlarPage> createState() => AyarlarPageState();
}

class AyarlarPageState extends State<AyarlarPage> {
  late Ayarlar ayarlar;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    ayarlar = AyarlarStorage.ayarlar;
  }

  Future<void> setAyarlar() async {
    await AyarlarStorage.writeAyarlar(ayarlar);
  }

  String? coordsControl(value) {
      if (value == null || value.isEmpty) {
        return 'Boş Bırakmayınız!';
      } else if (double.tryParse(value) == null) {
        return 'Lütfen Double değeri giriniz';
      }
      return null;
  }

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: const Text("Başarıyla Kaydedildi!", style: TextStyle(color: Colors.white),)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlar"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Harita Ayarları", style: TextStyle(fontSize: 25),),
              const Divider(),
              TextFormField(
                initialValue: ayarlar.mainLat.toString(),
                maxLength: 20,
                validator: coordsControl,
                decoration: const InputDecoration(
                    labelText: 'Latitude', contentPadding: EdgeInsets.all(5.0)),
                onChanged: (value) {
                  ayarlar.setMainLat(double.parse(value));
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                initialValue: ayarlar.mainLong.toString(),
                maxLength: 20,
                validator: coordsControl,
                decoration: const InputDecoration(
                    labelText: 'Longitude',
                    contentPadding: EdgeInsets.all(5.0)),
                onChanged: (value) {
                  ayarlar.setMainLong(double.parse(value));
                },
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                  onPressed: () {
                    if(_isButtonDisabled) return;

                    if (_formKey.currentState!.validate()) {
                      setAyarlar().then((value) {
                        showSnackbar(context);
                      });
                    }
                  },
                  child: const Text("Kaydet"))
            ],
          ),
        ),
      ),
    );
  }
}
