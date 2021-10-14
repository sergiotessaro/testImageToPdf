import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    // FlutterGeniusScan.scanWithConfiguration({
    //   'source': 'camera',
    //   'multiPage': false,
    // }).then((result) {
    //   print(result);
    //   String pdfUrl = result['pdfUrl'];
    //   OpenFile.open(pdfUrl.replaceAll("file://", '')).then(
    //       (result) => debugPrint(result.message),
    //       onError: (error) => displayError(context, error));
    // }, onError: (error) => displayError(context, error));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await getImagesGallery();
              },
              icon: Icon(Icons.camera))
        ],
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

// void displayError(BuildContext context, PlatformException error) {
//   ScaffoldMessenger.of(context)
//       .showSnackBar(SnackBar(content: Text(error.message!)));
// }

Future getImagesGallery() async {
  var image = await ImagePicker()
      .pickImage(source: ImageSource.camera, imageQuality: 40);
  // final PdfDocument document = PdfDocument();
  Directory tempDir = await getTemporaryDirectory();
  String output = tempDir.path;
  if (image != null) {
    // OpenFile.open(image.path);
    final imageData = pw.MemoryImage(File(image.path).readAsBytesSync());
    // final PdfBitmap imagem = PdfBitmap(imageData);
    final pdf = pw.Document();

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Image(imageData),
      ); // Center
    }));

    // document.pages
    //     .add()
    //     .graphics
    //     .drawImage(imagem, const Rect.fromLTWH(0, 0, 500, 800));

    var doc =
        await File('$output/ImageToPDF.pdf').writeAsBytes(await pdf.save());

    OpenFile.open(doc.path);
  }
}
