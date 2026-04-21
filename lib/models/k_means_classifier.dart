// lib/models/k_means_classifier.dart
import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:math';
import 'classification_result.dart';

class KMeansClassifier {
  // Centroides exactos de tu dataset
  final List<double> centroidLemon = [130.1, 136.0, 69.0];
  final List<double> centroidOrange = [160.0, 128.4, 59.9];

  // Umbral de rigor. Como ahora el usuario recorta perfectamente la fruta,
  // podemos tener un umbral más bajo (más estricto) sin miedo a fallar.
  final double distanceThreshold = 55.0;

  Future<ClassificationResult> classifyImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final img.Image? decodedImage = img.decodeImage(bytes);

    if (decodedImage == null) {
      return ClassificationResult(label: "Error al procesar la imagen", isMatch: false);
    }

    // Extracción de características de la imagen ya recortada
    List<double> averageRgb = _calculateAverageRgb(decodedImage);

    // Evaluamos distancias euclidianas
    double distanceToLemon = _calculateEuclideanDistance(averageRgb, centroidLemon);
    double distanceToOrange = _calculateEuclideanDistance(averageRgb, centroidOrange);

    // Reglas de decisión estrictas
    if (distanceToLemon > distanceThreshold && distanceToOrange > distanceThreshold) {
      return ClassificationResult(label: "No se encontraron coincidencias", isMatch: false);
    }

    if (distanceToLemon < distanceToOrange) {
      return ClassificationResult(label: "Limón", isMatch: true);
    } else {
      return ClassificationResult(label: "Naranja", isMatch: true);
    }
  }

  List<double> _calculateAverageRgb(img.Image image) {
    int rSum = 0;
    int gSum = 0;
    int bSum = 0;
    int pixelCount = 0;

    // Como la imagen viene recortada manualmente, extraemos el promedio
    // de TODOS los píxeles de la imagen (saltando de 2 en 2 para rendimiento)
    for (int y = 0; y < image.height; y += 2) {
      for (int x = 0; x < image.width; x += 2) {
        final pixel = image.getPixelSafe(x, y);
        rSum += pixel.r.toInt();
        gSum += pixel.g.toInt();
        bSum += pixel.b.toInt();
        pixelCount++;
      }
    }

    if(pixelCount == 0) return [0.0, 0.0, 0.0];

    return [
      rSum / pixelCount,
      gSum / pixelCount,
      bSum / pixelCount,
    ];
  }

  double _calculateEuclideanDistance(List<double> point1, List<double> point2) {
    double sum = 0.0;
    for (int i = 0; i < point1.length; i++) {
      sum += pow(point1[i] - point2[i], 2);
    }
    return sqrt(sum);
  }
}