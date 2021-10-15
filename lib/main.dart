import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Color(0xff39496B)),
      home: MyHomePage(title: 'Teste PDF'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff39496B),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange)),
              child: Text(
                'lib pdf',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await getImagesPdf();
              },
            ),
            Padding(padding: EdgeInsets.all(10)),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange)),
              child:
                  Text('lib syncfusion', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await getImagesSync();
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future getImagesPdf() async {
  var image = await ImagePicker()
      .pickImage(source: ImageSource.camera, imageQuality: 40);
  Directory tempDir = await getTemporaryDirectory();
  String output = tempDir.path;
  if (image != null) {
    final imageData = pw.MemoryImage(File(image.path).readAsBytesSync());
    final pdf = pw.Document();

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Image(imageData),
      );
    }));

    var doc = await File('$output/libpdf.pdf').writeAsBytes(await pdf.save());

    OpenFile.open(doc.path);
  }
}

Future getImagesSync() async {
  var image = await ImagePicker()
      .pickImage(source: ImageSource.camera, imageQuality: 40);
  final PdfDocument document = PdfDocument();
  Directory tempDir = await getTemporaryDirectory();
  String output = tempDir.path;
  if (image != null) {
    final Uint8List imageData = File(image.path).readAsBytesSync();
    final PdfBitmap imagem = PdfBitmap(imageData);

    document.pages
        .add()
        .graphics
        .drawImage(imagem, const Rect.fromLTWH(0, 0, 500, 800));

    var doc = await File('$output/libsync.pdf').writeAsBytes(document.save());

    OpenFile.open(doc.path);
  }
}
