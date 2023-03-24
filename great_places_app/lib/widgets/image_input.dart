import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    final file =
        await ImagePicker().getImage(source: ImageSource.camera, maxWidth: 600);
    if (file == null) {
      return;
    }
    final File imageFile = File(file.path);
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: <Widget>[
          Container(
            width: 400,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: Color(0xffdadada),
              ),
            ),
            child: _storedImage != null
                ? Image.file(
                    _storedImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Text('No image selected'),
            alignment: Alignment.center,
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: FlatButton.icon(
              icon: Icon(Icons.camera),
              label: Text(
                'Take picture',
              ),
              textColor: Theme.of(context).accentColor,
              onPressed: _takePicture,
            ),
          ),
        ],
      ),
    );
  }
}
