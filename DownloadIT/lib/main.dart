import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:reddit_video_downloader/effects/effects.dart';
import 'package:reddit_video_downloader/models/app_state.dart';
import 'package:reddit_video_downloader/reduers/app_state_reducer.dart';
import 'package:reddit_video_downloader/screens/home/home.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

var _epicMiddleware = new EpicMiddleware(epic);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await FlutterDownloader.initialize(debug: true // optional: set false to disable printing logs to console
  );
  final store = new Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [_epicMiddleware],
  );
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store store;

  MyApp({this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DownloadIt',
        theme: ThemeData(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            primaryColor: Colors.white,
            textTheme: TextTheme(
              headline5: TextStyle(fontSize: 21),
            ),
            buttonTheme: ButtonThemeData(
                buttonColor: Colors.white,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(color: Colors.blueAccent)
                ),
            ),
            appBarTheme: AppBarTheme(
              color: Colors.white,
            )),
        home:Home()
      ),
    );
  }
}
