import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MediaService {
  static MediaService instance = MediaService();
  late File _image;
  final picker = ImagePicker();

  Future<File?> getImageFromLibrary() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null) return File(pickedFile.path); else return null;
  }
}
