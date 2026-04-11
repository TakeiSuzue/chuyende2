import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:emotion_diary_app/models/diary_model.dart';
import 'package:emotion_diary_app/services/database_helper.dart';
import 'package:emotion_diary_app/services/location_service.dart';

class AddDiaryScreen extends StatefulWidget {
  @override
  _AddDiaryScreenState createState() => _AddDiaryScreenState();
}

class _AddDiaryScreenState extends State<AddDiaryScreen> {
  final _contentController = TextEditingController();
  File? _image;
  String _locationStr = "Chưa lấy vị trí";
  String _selectedEmotion = "😊 Vui vẻ";

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  Future<void> _getLocation() async {
    setState(() => _locationStr = "Đang lấy vị trí...");
    String res = await LocationService.getCurrentLocation();
    setState(() => _locationStr = res);
  }

  void _saveDiary() async {
    if (_contentController.text.isEmpty) return;
    await DatabaseHelper.instance.insert(Diary(
      date: DateTime.now().toIso8601String(),
      emotion: _selectedEmotion,
      score: emotionScores[_selectedEmotion] ?? 5,
      content: _contentController.text,
      imagePath: _image?.path,
      location: _locationStr,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Viết Nhật Ký"), actions: [
        IconButton(icon: Icon(Icons.check), onPressed: _saveDiary)
      ]),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedEmotion,
              decoration: InputDecoration(labelText: "Cảm xúc hôm nay"),
              items: emotionScores.keys.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _selectedEmotion = val!),
            ),
            SizedBox(height: 20),
            TextField(controller: _contentController, maxLines: 5, decoration: InputDecoration(hintText: "Ghi lại suy nghĩ...", border: OutlineInputBorder())),
            SizedBox(height: 20),
            if (_image != null) Image.file(_image!, height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(onPressed: _pickImage, icon: Icon(Icons.camera), label: Text("Ảnh")),
                TextButton.icon(onPressed: _getLocation, icon: Icon(Icons.location_on), label: Text("Vị trí")),
              ],
            ),
            Text(_locationStr, style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}