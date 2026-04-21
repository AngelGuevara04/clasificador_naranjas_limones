// lib/viewmodels/classifier_view_model.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

// 1. IMPORTA TU NUEVO MODELO KNN
import '../models/knn_classifier.dart';
import '../models/classification_result.dart';

class ClassifierViewModel extends ChangeNotifier {

  // 2. CAMBIA LA INSTANCIA DE KMeansClassifier A KNNClassifier
  final KNNClassifier _classifier = KNNClassifier();

  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  String _classificationLabel = "Selecciona o toma una foto";
  String get classificationLabel => _classificationLabel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> pickImageAndClassify(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(source: source);

      if (pickedFile != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Recorta la Fruta',
              toolbarColor: Colors.orange,
              toolbarWidgetColor: Colors.white,
              statusBarColor: Colors.orange.shade900,
              activeControlsWidgetColor: Colors.orange,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Recorta la Fruta',
            ),
          ],
        );

        if (croppedFile != null) {
          _selectedImage = File(croppedFile.path);
          _isLoading = true;
          _classificationLabel = "Buscando vecinos cercanos (KNN)..."; // Mensaje actualizado
          notifyListeners();

          // Ejecutamos la clasificación con el modelo KNN
          final ClassificationResult result = await _classifier.classifyImage(_selectedImage!);

          _classificationLabel = result.label;
          _isLoading = false;
          notifyListeners();
        }
      }
    } catch (e) {
      _isLoading = false;
      _classificationLabel = "Error al procesar la imagen";
      notifyListeners();
    }
  }
}