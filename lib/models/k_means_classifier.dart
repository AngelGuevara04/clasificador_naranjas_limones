import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:math';
import 'classification_result.dart';

class KMeansClassifier {
  // NOTA: Estos son los centroides RGB aproximados.
  // Tras aplicar K-Means a tu dataset en Python/R, reemplaza estos valores
  // por los centroides exactos que obtuviste.

  // Limones: Tienden al verde/amarillo claro
  final List<double> centroidLemon = [130.1, 136.0, 69.0];

  // Naranjas: Tienden al rojo/naranja
  final List<double> centroidOrange = [160.0, 128.4, 59.9];

  // Umbral máximo de distancia Euclidiana para descartar coincidencias
  final double distanceThreshold = 120.0;

  Future<ClassificationResult> classifyImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    // Decodificamos la imagen para acceder a sus píxeles
    final img.Image? decodedImage = img.decodeImage(bytes);

    if (decodedImage == null) {
      return ClassificationResult(label: "Error al procesar la imagen", isMatch: false);
    }

    // 1. Extracción de características (Feature Extraction)
    List<double> averageRgb = _calculateAverageRgb(decodedImage);

    // 2. Lógica de K-Means (Distancia a los centroides precalculados)
    double distanceToLemon = _calculateEuclideanDistance(averageRgb, centroidLemon);
    double distanceToOrange = _calculateEuclideanDistance(averageRgb, centroidOrange);

    // 3. Reglas de decisión
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

    // Recorremos la imagen para sacar un promedio de color.
    // Para mayor rendimiento en imágenes de alta resolución, podrías
    // muestrear píxeles saltando de 10 en 10 (ej. x += 10).
    for (int y = 0; y < image.height; y += 5) {
      for (int x = 0; x < image.width; x += 5) {
        final pixel = image.getPixel(x, y);
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