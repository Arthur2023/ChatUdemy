import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessage);

  final Function({String text, File imgFile}) sendMessage;

  @override
  _TextComposeState createState() => _TextComposeState();
}

class _TextComposeState extends State<TextComposer> {
  final TextEditingController _controller = TextEditingController();

  bool _isComposing = false;

  void _reset() {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  _showPhoto() async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 60),
                child: Text(
                  "Escolha a fonte da Imagem",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 5, 25),
                      child: FlatButton(
                          child: Icon(
                            Icons.camera,
                            color: Colors.blue,
                            size: 50,
                          ),
                          onPressed: () async {
                            final File imgFile = await ImagePicker.pickImage(source: ImageSource.camera);
                            widget.sendMessage(imgFile: imgFile);
                            if(imgFile == null) return ;
                            Navigator.pop(context);
                          })),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 10, 25),
                    child: FlatButton(
                      child:
                          Icon(Icons.save, color: Colors.blue, size: 50),
                      onPressed: () async {
                        final File imgFile = await ImagePicker.pickImage(source: ImageSource.gallery);
                        widget.sendMessage(imgFile: imgFile);
                        if(imgFile == null) return ;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )
            ],
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () {
                _showPhoto();
              }),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration:
                  InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                widget.sendMessage(text: text);
                _reset();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing
                ? () {
                    widget.sendMessage(text: _controller.text);
                    _reset();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
