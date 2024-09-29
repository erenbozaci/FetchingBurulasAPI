import 'package:fetchingburulasapi/bloc/fav_bloc/fav_bloc.dart';
import 'package:fetchingburulasapi/classes/map_components.dart';
import 'package:fetchingburulasapi/pages/main_page.dart';
import 'package:fetchingburulasapi/storage/favorites_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MapComponents.init();

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
    return BlocProvider(
        create: (_) => FavBloc(favDB: FavoritesDB()),
      child: MaterialApp(
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
        home: const MainPage(title: title)));
  }
}
