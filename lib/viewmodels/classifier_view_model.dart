import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/k_means_classifier.dart';
import '../models/classification_result.dart';

class ClassifierViewModel extends ChangeNotifier {
  final KMeansClassifier _classifier = KMeansClassifier();
  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  String _classificationLabel = "Toma una foto del cítrico";
  String get classificationLabel => _classificationLabel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> pickImageAndClassify() async {
    try {
      // Abre la cámara del dispositivo
      final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        _isLoading = true;
        _classificationLabel = "Analizando con K-Means...";
        notifyListeners();

        // Enviamos la imagen al modelo lógico
        final ClassificationResult result = await _classifier.classifyImage(_selectedImage!);

        _classificationLabel = result.label;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _classificationLabel = "Ocurrió un error con la cámara";
      notifyListeners();
    }
  }
}