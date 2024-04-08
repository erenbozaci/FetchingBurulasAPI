import 'package:fetchingburulasapi/pages/widgets/components/future_builder_modified.dart';
import 'package:fetchingburulasapi/storage/ayarlar_db.dart';
import 'package:flutter/material.dart';

class MapOptionsPage extends StatefulWidget {
  const MapOptionsPage({super.key});

  @override
  State<StatefulWidget> createState() => MapOptionsPageState();
}

class MapOptionsPageState extends State<MapOptionsPage> {
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    latController.dispose();
    longController.dispose();
    super.dispose();
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Başarıyla Kaydedildi!", style: TextStyle(color: Colors.white))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Harita Ayarları"),
        ),
        body: Container(
            padding: const EdgeInsets.all(15.0),
            child: FutureBuilderModified(
                future: HaritaAyarlar().getOptions(),
                errorTxt: "Hata",
                outputFunc: (data) {
                  latController.text = data?["mainLat"] ?? "";
                  longController.text = data?["mainLong"] ?? "";

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        child: const Text("Harita Odağı",
                            style: TextStyle(fontSize: 20)),
                      ),
                      const Divider(),
                      Expanded(
                          child: Form(
                        key: _formKey,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: latController,
                                  decoration: const InputDecoration(
                                      hintText: 'Latitude',
                                      labelText: 'Latitude',
                                      border: OutlineInputBorder()),
                                  validator: coordsControl,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  controller: longController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                      hintText: 'Longitude',
                                      labelText: 'Longitude',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      border: OutlineInputBorder()),
                                  validator: coordsControl,
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FilledButton(
                              onPressed: () {
                                if(_formKey.currentState!.validate()) {
                                  HaritaAyarlar().updateOptions({
                                    "mainLat": latController.text,
                                    "mainLong": longController.text
                                  });
                                  showSnackbar(context);
                                }
                              },
                              child: const Text("Kaydet")),
                          OutlinedButton(
                              onPressed: () {
                                latController.text = "40.188215";
                                longController.text = "29.060828";
                              },
                              child: const Text("Reset"))
                        ],
                      )
                    ],
                  );
                })));
  }
}
