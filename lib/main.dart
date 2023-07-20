import 'dart:io';
import 'package:camera_utility/camera_app.dart';
import 'package:camera_utility/widgets/editors/editor_params.dart';
import 'package:camera_utility/widgets/editors/image_edit.dart';
import 'package:camera_utility/widgets/editors/image_sticker.dart';
import 'package:camera_utility/widgets/picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'configs/image_picker_configs.dart';

import 'models/image_object.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return ErrorWidget(details.exception);
  };
  runApp(const HomeScreen());
}

//Flutter Camera Utility Demo app.
class MyApp extends StatelessWidget {

  const MyApp({final Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Setup image picker configs
    final configs = ImagePickerConfigs();
    configs.appBarTextColor = Colors.white;
    configs.appBarBackgroundColor = Colors.green;
    configs.translateFunc = (name, value) => Intl.message(value, name: name);
    // Disable edit function, then add other edit control instead
    configs.adjustFeatureEnabled = false;
    configs.externalImageEditors['Image Editing1'] = EditorParams(
        title: 'Image Editing',
        icon: Icons.edit_rounded,
        onEditorEvent: (
            {required BuildContext context,
              required File file,
              required String title,
              int maxWidth = 1080,
              int maxHeight = 1920,
              int compressQuality = 90,
              ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageEdit(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));
 /*   configs.externalImageEditors['external_image_editor_2'] = EditorParams(
        title: 'Image Editing',
        icon: Icons.edit_attributes,
        onEditorEvent: (
            {required BuildContext context,
              required File file,
              required String title,
              int maxWidth = 1080,
              int maxHeight = 1920,
              int compressQuality = 90,
              ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageSticker(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));*/

    // Example about label detection & OCR extraction feature.
    // You can use Google ML Kit or TensorflowLite for this purpose
    configs.labelDetectFunc = (String path) async {
      return <DetectObject>[
       /* DetectObject(label: 'dummy1', confidence: 0.75),
        DetectObject(label: 'dummy2', confidence: 0.75),
        DetectObject(label: 'dummy3', confidence: 0.75)*/
      ];
    };
    /*configs.ocrExtractFunc =
        (String path, {bool? isCloudService = false}) async {
      if (isCloudService!) {
        return '';
      } else {
        return '';
      }
    };*/

    // Example about custom stickers
    configs.customStickerOnly = true;
    configs.customStickers = [
      'assets/icon/cus1.png',
      'assets/icon/cus2.png',
      'assets/icon/cus3.png',
      'assets/icon/cus4.png',
      'assets/icon/cus5.png'
    ];

    return MaterialApp(
      title: 'Flutter Camera Utility Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Camera Demo'),
    );
  }
}




class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ImageObject> _imgObjs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            GridView.builder(
                shrinkWrap: true,
                itemCount: _imgObjs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, mainAxisSpacing: 2, crossAxisSpacing: 2),
                itemBuilder: (BuildContext context, int index) {
                  final image = _imgObjs[index];
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: Image.file(File(image.modifiedPath),
                        height: 80, fit: BoxFit.cover),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Get max 5 images
          final List<ImageObject>? objects = await Navigator.of(context)
              .push(PageRouteBuilder(pageBuilder: (context, animation, __) {
            return const ImagePicker(maxCount: 5);
          }));

          if ((objects?.length ?? 0) > 0) {
            setState(() {
              _imgObjs = objects!;
            });
          }
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}