import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intent/flag.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final statuses = [
        Permission.storage,
    ].request();
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final PageController _controller = PageController(
    initialPage: 0,
  );

  Widget build(BuildContext context) {
    final pages = PageView(
      controller: _controller,
      children: [
        HomeWidget(),
        PhotosWidget(),
      ],
    );
    return pages;
  }
}

class HomeWidget extends StatelessWidget {

  Widget build(BuildContext context) {
    final children = new Scaffold(
      body: new Image.asset(
        "images/home1.png",
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
    return new GestureDetector(
      onTapDown: _onTapDown,
      child: children,
    );
  }

  _onTapDown(TapDownDetails details) {

    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    // or user the local position method to get the offset
    print(details.localPosition);

    int dx = (x / 80).floor();
    int dy = ((y - 180) / 100).floor();
    int posicao = dy * 5 + dx;
    print("results: x=$x y=$y $dx $dy $posicao");
    _save(posicao);
  }

  _save(int posicao) async {
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/efeito-$posicao.jpg";
    print(savePath);
    await Dio().download(
        "https://github.com/guilhermesilveira/flutter-magic/raw/main/efeito-$posicao.jpg",
        savePath);
    print("saved!");
    final result = await ImageGallerySaver.saveFile(savePath);
    print(result);
  }
}

class PhotosWidget extends StatelessWidget {
  // https://stackoverflow.com/questions/16928727/open-gallery-app-from-android-intent
  Widget build(BuildContext context) {
    final children = new Scaffold(
      body: new Image.asset(
        "images/home2.png",
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        // alignment: Alignment.center,
      ),
    );
    return new GestureDetector(
      onTap: openGallery,
      child: children,
    );
  }

  void openGallery() {
    print("opening");
    android_intent.Intent()
      ..setAction(android_action.Action.ACTION_VIEW)
      ..setType("image/*")
      ..addFlag(Flag.FLAG_ACTIVITY_NEW_TASK)
      ..startActivity().catchError((e) => print(e));
  }
}



// TODO opcional:
// refatorar widget
// colocar imagem de background fixa
// dynamic screen dimensions
