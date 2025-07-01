import 'dart:io';

import 'package:flutter/material.dart';
import 'package:agroconecta/external/services/image_service.dart';

typedef ImagePickedCallback = void Function(File image);

class AddPhotoButton extends StatefulWidget {
  final ImagePickedCallback onImagePicked;

  const AddPhotoButton({Key? key, required this.onImagePicked})
    : super(key: key);

  @override
  State<AddPhotoButton> createState() => _AddPhotoButtonState();
}

class _AddPhotoButtonState extends State<AddPhotoButton> {
  final ImageService _imageService = ImageService();

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Escolher da Galeria'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final File? image = await _imageService
                      .pickImageFromGallery();
                  if (image != null) {
                    widget.onImagePicked(image);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tirar Foto com a Câmera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final File? image = await _imageService.getImageFromCamera();
                  if (image != null) {
                    widget.onImagePicked(image);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _pickImage,
      child: const Text('Adicionar Foto'),
    );
  }
}
