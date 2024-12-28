import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PhotoCard extends StatefulWidget {
  final String levelText;
  final ValueChanged<Uint8List?> onImagePicked;

  const PhotoCard(
      {super.key, required this.levelText, required this.onImagePicked});

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  Uint8List? imageBytes;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if ( (result != null && result.files.isNotEmpty)) {
      Uint8List fileBytes = result.files.first.bytes!;
      setState(() {
        imageBytes = fileBytes;
      });
      widget.onImagePicked(imageBytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: _pickImage,
        child: Card(
          child: Container(
            height: 130,
            width: 130,
            decoration: BoxDecoration(
                color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
            child: imageBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:  Image.memory(
                            imageBytes!,
                            fit: BoxFit.cover,
                          )
                  )
                :

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: Colors.grey[500],
                ),
                Text(
                  widget.levelText,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
