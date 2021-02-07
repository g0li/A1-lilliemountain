import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class FilePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickedFunction;
  final String imgUrl;

  FilePicker({
    this.imagePickedFunction,
    this.imgUrl,
  });

  @override
  _FilePickerState createState() => _FilePickerState();
}

class _FilePickerState extends State<FilePicker> {
  File _pickedImage;

  void pickImage() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            actionsPadding: EdgeInsets.all(0),
            title: Text(
              'Source',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            actions: [
              FlatButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                icon: Icon(
                  Icons.perm_media,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text('Gallery'),
              ),
              FlatButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                icon: Icon(
                  Icons.camera,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text('Camera'),
              ),
            ],
          );
        }).then((value) async {
      if (value == null) return;
      final picker = ImagePicker();
      final pickedImage = await picker.getImage(
        source: value ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 80,
      );
      final pickedImageFile = File(pickedImage.path);
      setState(() {
        _pickedImage = pickedImageFile;
      });
      widget.imagePickedFunction(_pickedImage);
    }).catchError((err) {
      print(err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.imgUrl);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: GestureDetector(
            onTap: pickImage,
            child: Container(
              alignment: Alignment.center,
              height: 200,
              child: (_pickedImage == null && widget.imgUrl == null)
                  ? FaIcon(
                      FontAwesomeIcons.camera,
                      color: Colors.grey,
                      size: 50,
                    )
                  : Container(),
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image: DecorationImage(
                  image: (_pickedImage == null && widget.imgUrl == null)
                      ? CachedNetworkImageProvider(
                          'https://via.placeholder.com/500.png',
                        )
                      : _pickedImage == null
                          ? CachedNetworkImageProvider(widget.imgUrl)
                          : FileImage(_pickedImage),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
