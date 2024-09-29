import 'package:fetchingburulasapi/pages/widgets/components/form_components.dart';
import 'package:fetchingburulasapi/pages/widgets/components/future_builder_extended.dart';
import 'package:fetchingburulasapi/storage/ayarlar_db.dart';
import 'package:flutter/material.dart';

class MapOptionsPage extends StatefulWidget {
  const MapOptionsPage({super.key});

  @override
  State<StatefulWidget> createState() => MapOptionsPageState();
}

class MapOptionsPageState extends State<MapOptionsPage> {
  List dropdownList = [
    "DEFAULT",
    "DARK",
  ];

  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController dropdownController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    latController.dispose();
    longController.dispose();
    dropdownController.dispose();
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
        content: Text("Başarıyla Kaydedildi!",
            style: TextStyle(color: Colors.white))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Harita Ayarları"),
        ),
        body: Container(
            padding: const EdgeInsets.all(15.0),
            child: FutureBuilderExtended(
                future: HaritaAyarlar().getOptions(),
                errors: FutureBuilderErrors(
                    hasDataError: "Hata: Ayar Bulunamadı!",
                    isEmptyError: "Hata: Ayar Bulunamadı!"),
                outputFunc: (data) {
                  latController.text = data?["mainLat"] ?? "";
                  longController.text = data?["mainLong"] ?? "";
                  dropdownController.text = data?["mapType"] ?? "";

                  return Column(children: [
                    Expanded(
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                FormComponents.formGroupTitle("Harita Odağı"),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: FormComponents.formTextInput(
                                            label: "Latitude",
                                            controller: latController,
                                            validator: coordsControl)),
                                    Expanded(
                                      child: FormComponents.formTextInput(
                                          label: "Longitude",
                                          controller: longController,
                                          validator: coordsControl),
                                    )
                                  ],
                                ),
                                const Divider(),
                                FormComponents.formGroupTitle("Harita Tipi"),
                                FormComponents.formDropdown(
                                  label: "Harita Tipi",
                                  list: dropdownList,
                                  controller: dropdownController,
                                  dropDownMenuItemChild: (e) => Text(e),
                                )
                              ],
                            ))),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FilledButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  HaritaAyarlar().updateOptions({
                                    "mainLat": latController.text,
                                    "mainLong": longController.text,
                                    "mapType": dropdownController.text
                                  });
                                  showSnackbar(context);
                                }
                              },
                              child: const Text("Kaydet")),
                          OutlinedButton(
                              onPressed: () {
                                latController.text = "40.188215";
                                longController.text = "29.060828";
                                dropdownController.text = "DEFAULT";
                              },
                              child: const Text("Reset"))
                        ])
                  ]);
                })));
  }
}
