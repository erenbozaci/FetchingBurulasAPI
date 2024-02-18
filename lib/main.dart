import 'package:fetchingburulasapi/pages/main_page.dart';
import 'package:fetchingburulasapi/storage/ayarlar_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AyarlarStorage.init();

  runApp(const FetchingBurulasApi());
}

class FetchingBurulasApi extends StatefulWidget {
  const FetchingBurulasApi({super.key});

  @override
  FetchingBurulasApiState createState() => FetchingBurulasApiState();
}

class FetchingBurulasApiState extends State<FetchingBurulasApi> {
  @override
  Widget build(BuildContext context) {
    const title = 'Fetching Burulaş API';

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.dark,
        title: title,
        home: const MainPage(title: title));
  }
}
