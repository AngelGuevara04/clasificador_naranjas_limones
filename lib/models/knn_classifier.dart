// lib/models/knn_classifier.dart
import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:math';
import 'classification_result.dart';

class DataPoint {
  final List<double> features;
  final String label;

  DataPoint(this.features, this.label);
}

class KNNClassifier {
  final int k = 3;
  final double distanceThreshold = 55.0;

  // --- MANTÉN AQUÍ TU DATASET REAL ---
  final List<DataPoint> knownDataset = [
    DataPoint([144.7, 175.4, 82.7], 'Limón'),
    DataPoint([156.9, 172.2, 85.9], 'Limón'),
    DataPoint([127.3, 156.4, 85.4], 'Limón'),
    DataPoint([137.2, 158.6, 88.4], 'Limón'),
    DataPoint([177.7, 167.3, 75.2], 'Limón'),
    DataPoint([147.2, 161.1, 96.9], 'Limón'),
    DataPoint([150.3, 169.6, 79.7], 'Limón'),
    DataPoint([127.8, 147.8, 84.2], 'Limón'),
    DataPoint([133.0, 160.5, 92.7], 'Limón'),
    DataPoint([156.0, 166.1, 86.7], 'Limón'),
    DataPoint([104.0, 113.4, 70.9], 'Limón'),
    DataPoint([163.9, 149.5, 86.7], 'Limón'),
    DataPoint([155.9, 145.4, 62.8], 'Limón'),
    DataPoint([173.6, 157.7, 90.3], 'Limón'),
    DataPoint([129.5, 111.3, 67.5], 'Limón'),
    DataPoint([175.0, 163.7, 86.7], 'Limón'),
    DataPoint([161.6, 141.8, 63.9], 'Limón'),
    DataPoint([111.3, 119.7, 67.3], 'Limón'),
    DataPoint([167.9, 158.2, 81.0], 'Limón'),
    DataPoint([175.8, 155.4, 64.4], 'Limón'),
    DataPoint([122.7, 148.2, 61.0], 'Limón'),
    DataPoint([169.3, 156.9, 53.7], 'Limón'),
    DataPoint([116.1, 143.6, 50.9], 'Limón'),
    DataPoint([134.4, 159.6, 49.8], 'Limón'),
    DataPoint([129.0, 151.0, 37.1], 'Limón'),
    DataPoint([133.8, 159.6, 38.8], 'Limón'),
    DataPoint([144.7, 175.6, 60.2], 'Limón'),
    DataPoint([123.6, 152.8, 55.7], 'Limón'),
    DataPoint([126.9, 152.5, 54.3], 'Limón'),
    DataPoint([113.8, 117.4, 86.1], 'Limón'),
    DataPoint([132.8, 146.3, 79.4], 'Limón'),
    DataPoint([131.4, 159.3, 80.7], 'Limón'),
    DataPoint([139.7, 143.0, 94.4], 'Limón'),
    DataPoint([129.7, 137.1, 67.3], 'Limón'),
    DataPoint([153.4, 144.0, 92.7], 'Limón'),
    DataPoint([120.3, 122.9, 88.0], 'Limón'),
    DataPoint([119.4, 128.6, 92.1], 'Limón'),
    DataPoint([125.6, 127.9, 81.8], 'Limón'),
    DataPoint([132.9, 137.4, 93.8], 'Limón'),
    DataPoint([135.2, 161.9, 88.1], 'Limón'),
    DataPoint([148.6, 164.4, 83.4], 'Limón'),
    DataPoint([118.8, 129.4, 79.6], 'Limón'),
    DataPoint([146.4, 150.1, 94.1], 'Limón'),
    DataPoint([176.7, 179.5, 102.5], 'Limón'),
    DataPoint([165.8, 163.7, 78.1], 'Limón'),
    DataPoint([156.5, 153.6, 73.1], 'Limón'),
    DataPoint([149.7, 149.7, 82.1], 'Limón'),
    DataPoint([132.0, 145.3, 80.6], 'Limón'),
    DataPoint([138.6, 158.8, 76.4], 'Limón'),
    DataPoint([133.9, 143.3, 82.3], 'Limón'),
    DataPoint([106.4, 123.8, 74.8], 'Limón'),
    DataPoint([141.3, 146.6, 79.5], 'Limón'),
    DataPoint([114.1, 131.4, 72.8], 'Limón'),
    DataPoint([119.6, 137.3, 78.0], 'Limón'),
    DataPoint([139.4, 143.9, 75.4], 'Limón'),
    DataPoint([111.3, 125.4, 82.2], 'Limón'),
    DataPoint([141.9, 148.5, 75.1], 'Limón'),
    DataPoint([120.0, 134.3, 80.2], 'Limón'),
    DataPoint([149.3, 151.3, 84.2], 'Limón'),
    DataPoint([119.2, 135.0, 59.2], 'Limón'),
    DataPoint([125.6, 139.6, 68.3], 'Limón'),
    DataPoint([119.5, 138.9, 71.4], 'Limón'),
    DataPoint([104.3, 118.9, 66.3], 'Limón'),
    DataPoint([108.4, 121.4, 64.2], 'Limón'),
    DataPoint([110.9, 131.8, 67.5], 'Limón'),
    DataPoint([116.0, 132.3, 67.0], 'Limón'),
    DataPoint([117.2, 132.3, 61.4], 'Limón'),
    DataPoint([123.1, 139.3, 67.8], 'Limón'),
    DataPoint([116.9, 123.1, 59.4], 'Limón'),
    DataPoint([145.1, 144.7, 41.0], 'Limón'),
    DataPoint([75.8, 90.5, 28.1], 'Limón'),
    DataPoint([114.0, 125.5, 39.1], 'Limón'),
    DataPoint([89.3, 113.6, 35.6], 'Limón'),
    DataPoint([136.6, 135.4, 48.1], 'Limón'),
    DataPoint([111.0, 125.3, 33.5], 'Limón'),
    DataPoint([112.6, 127.5, 35.0], 'Limón'),
    DataPoint([106.7, 126.7, 35.5], 'Limón'),
    DataPoint([131.2, 130.0, 38.0], 'Limón'),
    DataPoint([127.2, 137.1, 43.9], 'Limón'),
    DataPoint([137.0, 134.5, 91.6], 'Limón'),
    DataPoint([134.5, 136.8, 101.0], 'Limón'),
    DataPoint([139.9, 133.1, 89.1], 'Limón'),
    DataPoint([134.7, 131.9, 98.9], 'Limón'),
    DataPoint([137.1, 138.9, 93.2], 'Limón'),
    DataPoint([141.4, 141.9, 95.5], 'Limón'),
    DataPoint([137.4, 139.5, 94.8], 'Limón'),
    DataPoint([137.0, 138.1, 92.3], 'Limón'),
    DataPoint([141.9, 141.6, 93.4], 'Limón'),
    DataPoint([140.1, 138.4, 94.7], 'Limón'),
    DataPoint([181.7, 179.8, 84.6], 'Limón'),
    DataPoint([153.0, 165.1, 85.1], 'Limón'),
    DataPoint([147.8, 170.5, 87.8], 'Limón'),
    DataPoint([135.8, 162.5, 94.7], 'Limón'),
    DataPoint([161.8, 165.3, 93.8], 'Limón'),
    DataPoint([141.8, 154.8, 94.2], 'Limón'),
    DataPoint([158.4, 174.4, 86.6], 'Limón'),
    DataPoint([153.8, 167.8, 87.1], 'Limón'),
    DataPoint([163.2, 166.3, 78.4], 'Limón'),
    DataPoint([140.6, 162.9, 89.3], 'Limón'),
    DataPoint([89.8, 93.8, 64.8], 'Limón'),
    DataPoint([102.3, 115.5, 67.2], 'Limón'),
    DataPoint([94.8, 103.4, 58.3], 'Limón'),
    DataPoint([94.7, 103.7, 65.2], 'Limón'),
    DataPoint([95.3, 104.0, 66.4], 'Limón'),
    DataPoint([89.3, 96.0, 68.5], 'Limón'),
    DataPoint([121.3, 125.6, 53.0], 'Limón'),
    DataPoint([98.6, 108.4, 55.3], 'Limón'),
    DataPoint([96.2, 106.4, 55.6], 'Limón'),
    DataPoint([102.9, 111.5, 49.6], 'Limón'),
    DataPoint([81.1, 101.4, 43.9], 'Limón'),
    DataPoint([119.4, 124.7, 53.4], 'Limón'),
    DataPoint([179.5, 188.4, 102.5], 'Limón'),
    DataPoint([178.9, 186.3, 91.6], 'Limón'),
    DataPoint([153.1, 166.8, 122.6], 'Limón'),
    DataPoint([104.4, 123.4, 44.6], 'Limón'),
    DataPoint([105.0, 130.0, 44.2], 'Limón'),
    DataPoint([104.4, 129.2, 42.3], 'Limón'),
    DataPoint([79.3, 99.7, 41.2], 'Limón'),
    DataPoint([93.2, 115.8, 51.5], 'Limón'),
    DataPoint([154.9, 153.2, 58.7], 'Limón'),
    DataPoint([154.2, 159.0, 61.8], 'Limón'),
    DataPoint([155.0, 156.7, 56.9], 'Limón'),
    DataPoint([159.5, 153.0, 63.1], 'Limón'),
    DataPoint([164.2, 153.0, 51.6], 'Limón'),
    DataPoint([162.0, 154.9, 60.1], 'Limón'),
    DataPoint([164.3, 147.8, 69.0], 'Limón'),
    DataPoint([165.7, 152.3, 54.5], 'Limón'),
    DataPoint([165.2, 156.9, 66.1], 'Limón'),
    DataPoint([160.1, 156.0, 63.9], 'Limón'),
    DataPoint([90.2, 112.4, 79.4], 'Limón'),
    DataPoint([84.9, 106.5, 79.2], 'Limón'),
    DataPoint([104.1, 132.7, 88.9], 'Limón'),
    DataPoint([70.6, 81.1, 60.1], 'Limón'),
    DataPoint([88.0, 98.8, 68.3], 'Limón'),
    DataPoint([84.8, 101.7, 55.6], 'Limón'),
    DataPoint([86.4, 103.5, 71.3], 'Limón'),
    DataPoint([98.8, 109.9, 78.2], 'Limón'),
    DataPoint([83.2, 88.9, 50.4], 'Limón'),
    DataPoint([79.5, 91.3, 62.9], 'Limón'),
    DataPoint([151.5, 151.8, 87.3], 'Limón'),
    DataPoint([137.1, 141.2, 92.1], 'Limón'),
    DataPoint([169.1, 159.9, 86.6], 'Limón'),
    DataPoint([145.6, 139.2, 73.7], 'Limón'),
    DataPoint([168.8, 161.9, 87.2], 'Limón'),
    DataPoint([161.4, 152.8, 78.6], 'Limón'),
    DataPoint([141.1, 138.7, 71.4], 'Limón'),
    DataPoint([163.6, 157.1, 81.5], 'Limón'),
    DataPoint([171.3, 161.3, 82.9], 'Limón'),
    DataPoint([160.3, 153.4, 82.1], 'Limón'),
    DataPoint([129.0, 126.9, 53.2], 'Limón'),
    DataPoint([124.9, 124.3, 49.1], 'Limón'),
    DataPoint([122.2, 139.9, 38.7], 'Limón'),
    DataPoint([127.3, 134.0, 68.7], 'Limón'),
    DataPoint([111.0, 117.5, 50.1], 'Limón'),
    DataPoint([107.8, 109.1, 51.2], 'Limón'),
    DataPoint([116.8, 130.8, 69.0], 'Limón'),
    DataPoint([125.8, 100.9, 69.7], 'Limón'),
    DataPoint([105.4, 120.2, 73.0], 'Limón'),
    DataPoint([108.0, 126.5, 76.5], 'Limón'),
    DataPoint([111.3, 131.6, 70.3], 'Limón'),
    DataPoint([122.5, 131.6, 76.0], 'Limón'),
    DataPoint([111.2, 124.0, 64.1], 'Limón'),
    DataPoint([140.0, 150.2, 63.0], 'Limón'),
    DataPoint([108.8, 123.4, 57.9], 'Limón'),
    DataPoint([129.8, 137.1, 68.5], 'Limón'),
    DataPoint([117.8, 132.3, 54.5], 'Limón'),
    DataPoint([114.5, 133.3, 59.5], 'Limón'),
    DataPoint([119.9, 135.9, 50.0], 'Limón'),
    DataPoint([113.5, 132.1, 58.7], 'Limón'),
    DataPoint([118.3, 122.6, 80.1], 'Limón'),
    DataPoint([121.8, 127.7, 87.7], 'Limón'),
    DataPoint([118.0, 119.7, 78.9], 'Limón'),
    DataPoint([125.9, 127.0, 77.3], 'Limón'),
    DataPoint([114.2, 117.8, 76.4], 'Limón'),
    DataPoint([119.5, 121.4, 71.9], 'Limón'),
    DataPoint([109.3, 116.1, 74.0], 'Limón'),
    DataPoint([127.2, 125.1, 76.1], 'Limón'),
    DataPoint([129.5, 124.2, 61.3], 'Limón'),
    DataPoint([114.4, 117.2, 71.8], 'Limón'),
    DataPoint([123.6, 111.4, 18.2], 'Limón'),
    DataPoint([145.6, 126.2, 26.7], 'Limón'),
    DataPoint([83.8, 93.1, 17.8], 'Limón'),
    DataPoint([78.0, 94.1, 22.2], 'Limón'),
    DataPoint([123.6, 124.2, 23.9], 'Limón'),
    DataPoint([119.3, 115.0, 23.7], 'Limón'),
    DataPoint([103.4, 113.5, 23.8], 'Limón'),
    DataPoint([117.8, 125.6, 36.9], 'Limón'),
    DataPoint([113.9, 111.0, 56.3], 'Limón'),
    DataPoint([127.8, 121.3, 52.5], 'Limón'),
    DataPoint([133.1, 132.4, 81.3], 'Limón'),
    DataPoint([142.1, 139.5, 73.2], 'Limón'),
    DataPoint([129.9, 129.9, 66.6], 'Limón'),
    DataPoint([127.8, 135.0, 90.4], 'Limón'),
    DataPoint([140.6, 138.7, 75.3], 'Limón'),
    DataPoint([121.9, 128.2, 83.4], 'Limón'),
    DataPoint([139.4, 128.7, 64.8], 'Limón'),
    DataPoint([123.5, 127.7, 77.9], 'Limón'),
    DataPoint([127.3, 126.7, 54.6], 'Limón'),
    DataPoint([119.9, 129.9, 71.9], 'Limón'),
    DataPoint([137.3, 132.1, 78.9], 'Limón'),
    DataPoint([143.1, 147.4, 89.5], 'Limón'),
    DataPoint([139.7, 141.9, 80.7], 'Limón'),
    DataPoint([131.8, 132.9, 76.6], 'Limón'),
    DataPoint([140.5, 138.8, 82.8], 'Limón'),
    DataPoint([122.2, 128.7, 70.4], 'Limón'),
    DataPoint([138.3, 133.1, 78.5], 'Limón'),
    DataPoint([114.4, 120.5, 73.5], 'Limón'),
    DataPoint([123.0, 125.5, 73.3], 'Limón'),
    DataPoint([134.4, 133.7, 74.0], 'Limón'),
    DataPoint([147.2, 134.1, 46.9], 'Limón'),
    DataPoint([156.7, 143.7, 50.9], 'Limón'),
    DataPoint([140.4, 137.7, 53.2], 'Limón'),
    DataPoint([150.0, 148.2, 56.7], 'Limón'),
    DataPoint([151.6, 133.1, 56.0], 'Limón'),
    DataPoint([155.3, 132.8, 56.1], 'Limón'),
    DataPoint([142.3, 136.3, 66.4], 'Limón'),
    DataPoint([152.4, 148.4, 65.6], 'Limón'),
    DataPoint([156.4, 144.6, 48.0], 'Limón'),
    DataPoint([141.4, 135.4, 52.1], 'Limón'),
    DataPoint([124.4, 127.7, 68.9], 'Limón'),
    DataPoint([126.2, 123.5, 70.3], 'Limón'),
    DataPoint([140.0, 136.7, 84.5], 'Limón'),
    DataPoint([136.9, 141.9, 72.7], 'Limón'),
    DataPoint([109.8, 115.4, 66.8], 'Limón'),
    DataPoint([133.5, 137.1, 61.9], 'Limón'),
    DataPoint([144.2, 137.5, 51.9], 'Limón'),
    DataPoint([121.4, 120.0, 72.7], 'Limón'),
    DataPoint([121.2, 127.7, 79.0], 'Limón'),
    DataPoint([129.4, 133.0, 71.2], 'Limón'),
    DataPoint([186.0, 161.2, 64.5], 'Naranja'),
    DataPoint([194.3, 152.6, 44.3], 'Naranja'),
    DataPoint([189.5, 164.9, 40.0], 'Naranja'),
    DataPoint([202.2, 162.7, 44.1], 'Naranja'),
    DataPoint([198.7, 164.8, 42.9], 'Naranja'),
    DataPoint([191.0, 160.6, 45.4], 'Naranja'),
    DataPoint([183.7, 156.8, 77.8], 'Naranja'),
    DataPoint([184.2, 142.8, 35.7], 'Naranja'),
    DataPoint([168.5, 162.6, 77.1], 'Naranja'),
    DataPoint([187.9, 153.2, 49.4], 'Naranja'),
    DataPoint([175.0, 139.4, 60.6], 'Naranja'),
    DataPoint([171.5, 146.1, 63.1], 'Naranja'),
    DataPoint([173.1, 155.7, 65.6], 'Naranja'),
    DataPoint([169.2, 151.8, 62.3], 'Naranja'),
    DataPoint([156.0, 155.1, 65.3], 'Naranja'),
    DataPoint([163.3, 154.4, 66.5], 'Naranja'),
    DataPoint([162.2, 148.2, 69.7], 'Naranja'),
    DataPoint([171.9, 145.4, 60.9], 'Naranja'),
    DataPoint([171.3, 139.1, 63.6], 'Naranja'),
    DataPoint([165.5, 148.1, 65.6], 'Naranja'),
    DataPoint([165.8, 136.0, 37.9], 'Naranja'),
    DataPoint([158.0, 126.1, 44.5], 'Naranja'),
    DataPoint([178.3, 133.1, 35.4], 'Naranja'),
    DataPoint([172.3, 135.8, 32.7], 'Naranja'),
    DataPoint([159.0, 124.1, 35.9], 'Naranja'),
    DataPoint([164.7, 129.4, 36.0], 'Naranja'),
    DataPoint([163.1, 133.5, 42.6], 'Naranja'),
    DataPoint([166.3, 129.2, 43.9], 'Naranja'),
    DataPoint([149.1, 132.5, 39.7], 'Naranja'),
    DataPoint([157.8, 140.9, 40.8], 'Naranja'),
    DataPoint([163.1, 130.7, 77.6], 'Naranja'),
    DataPoint([173.5, 128.6, 80.4], 'Naranja'),
    DataPoint([118.7, 98.3, 45.5], 'Naranja'),
    DataPoint([167.7, 139.0, 59.9], 'Naranja'),
    DataPoint([119.1, 94.8, 45.3], 'Naranja'),
    DataPoint([178.8, 135.6, 81.7], 'Naranja'),
    DataPoint([169.7, 145.9, 73.5], 'Naranja'),
    DataPoint([187.8, 149.2, 91.7], 'Naranja'),
    DataPoint([167.8, 145.4, 70.1], 'Naranja'),
    DataPoint([167.8, 145.4, 70.1], 'Naranja'),
    DataPoint([174.2, 150.2, 75.2], 'Naranja'),
    DataPoint([160.2, 137.0, 69.0], 'Naranja'),
    DataPoint([171.5, 147.4, 61.7], 'Naranja'),
    DataPoint([178.3, 148.9, 79.6], 'Naranja'),
    DataPoint([172.9, 141.8, 70.0], 'Naranja'),
    DataPoint([141.0, 139.1, 73.1], 'Naranja'),
    DataPoint([147.2, 137.3, 70.0], 'Naranja'),
    DataPoint([127.4, 112.5, 66.6], 'Naranja'),
    DataPoint([178.8, 145.9, 66.3], 'Naranja'),
    DataPoint([179.0, 143.1, 59.8], 'Naranja'),
    DataPoint([173.5, 117.5, 66.9], 'Naranja'),
    DataPoint([166.7, 99.5, 61.0], 'Naranja'),
    DataPoint([160.7, 124.7, 66.0], 'Naranja'),
    DataPoint([168.2, 119.0, 63.5], 'Naranja'),
    DataPoint([166.5, 122.4, 72.2], 'Naranja'),
    DataPoint([170.2, 122.2, 66.0], 'Naranja'),
    DataPoint([171.4, 113.3, 63.4], 'Naranja'),
    DataPoint([164.6, 114.3, 67.7], 'Naranja'),
    DataPoint([171.3, 114.4, 61.6], 'Naranja'),
    DataPoint([183.6, 136.1, 80.1], 'Naranja'),
    DataPoint([129.2, 123.7, 61.9], 'Naranja'),
    DataPoint([152.7, 133.4, 64.3], 'Naranja'),
    DataPoint([140.4, 131.8, 67.0], 'Naranja'),
    DataPoint([150.0, 129.9, 65.5], 'Naranja'),
    DataPoint([154.7, 134.9, 66.8], 'Naranja'),
    DataPoint([157.3, 139.5, 65.2], 'Naranja'),
    DataPoint([155.8, 135.3, 66.7], 'Naranja'),
    DataPoint([138.5, 126.5, 58.8], 'Naranja'),
    DataPoint([152.1, 133.2, 68.7], 'Naranja'),
    DataPoint([153.5, 131.9, 62.7], 'Naranja'),
    DataPoint([195.5, 110.1, 43.1], 'Naranja'),
    DataPoint([198.3, 118.3, 45.9], 'Naranja'),
    DataPoint([180.7, 97.6, 38.4], 'Naranja'),
    DataPoint([171.6, 89.3, 33.1], 'Naranja'),
    DataPoint([175.1, 103.4, 39.9], 'Naranja'),
    DataPoint([200.6, 116.5, 42.5], 'Naranja'),
    DataPoint([194.7, 101.0, 27.2], 'Naranja'),
    DataPoint([203.6, 115.8, 44.8], 'Naranja'),
    DataPoint([181.9, 108.4, 43.1], 'Naranja'),
    DataPoint([192.9, 103.9, 36.7], 'Naranja'),
    DataPoint([134.0, 139.1, 99.8], 'Naranja'),
    DataPoint([125.1, 122.4, 98.4], 'Naranja'),
    DataPoint([134.2, 122.5, 91.7], 'Naranja'),
    DataPoint([149.4, 124.9, 77.9], 'Naranja'),
    DataPoint([139.6, 132.7, 87.4], 'Naranja'),
    DataPoint([138.5, 129.3, 78.5], 'Naranja'),
    DataPoint([142.1, 133.4, 82.1], 'Naranja'),
    DataPoint([139.2, 127.9, 95.2], 'Naranja'),
    DataPoint([137.1, 130.5, 79.6], 'Naranja'),
    DataPoint([143.2, 138.2, 86.4], 'Naranja'),
    DataPoint([194.8, 160.6, 48.6], 'Naranja'),
    DataPoint([179.4, 146.0, 42.6], 'Naranja'),
    DataPoint([198.2, 155.8, 43.1], 'Naranja'),
    DataPoint([189.2, 149.5, 63.1], 'Naranja'),
    DataPoint([186.8, 145.7, 49.5], 'Naranja'),
    DataPoint([178.6, 145.9, 48.1], 'Naranja'),
    DataPoint([193.2, 150.4, 45.5], 'Naranja'),
    DataPoint([184.8, 149.7, 53.3], 'Naranja'),
    DataPoint([184.2, 148.3, 45.4], 'Naranja'),
    DataPoint([191.8, 159.0, 48.3], 'Naranja'),
    DataPoint([141.3, 119.7, 61.8], 'Naranja'),
    DataPoint([130.0, 116.6, 52.3], 'Naranja'),
    DataPoint([120.3, 110.6, 47.4], 'Naranja'),
    DataPoint([106.9, 105.6, 47.4], 'Naranja'),
    DataPoint([124.8, 110.2, 45.7], 'Naranja'),
    DataPoint([144.2, 108.4, 44.1], 'Naranja'),
    DataPoint([122.7, 103.5, 46.4], 'Naranja'),
    DataPoint([117.8, 113.6, 50.1], 'Naranja'),
    DataPoint([107.0, 105.9, 53.0], 'Naranja'),
    DataPoint([115.4, 118.7, 55.1], 'Naranja'),
    DataPoint([194.2, 174.6, 60.4], 'Naranja'),
    DataPoint([177.5, 152.5, 43.3], 'Naranja'),
    DataPoint([189.7, 171.0, 57.9], 'Naranja'),
    DataPoint([176.2, 145.6, 43.6], 'Naranja'),
    DataPoint([165.3, 141.0, 40.7], 'Naranja'),
    DataPoint([176.7, 151.1, 47.0], 'Naranja'),
    DataPoint([181.2, 152.5, 47.1], 'Naranja'),
    DataPoint([166.1, 138.8, 43.9], 'Naranja'),
    DataPoint([160.3, 124.3, 30.7], 'Naranja'),
    DataPoint([158.5, 129.8, 47.0], 'Naranja'),
    DataPoint([167.9, 128.5, 71.9], 'Naranja'),
    DataPoint([176.2, 137.3, 62.0], 'Naranja'),
    DataPoint([167.7, 138.5, 59.2], 'Naranja'),
    DataPoint([165.6, 136.5, 67.3], 'Naranja'),
    DataPoint([177.9, 135.4, 59.8], 'Naranja'),
    DataPoint([174.2, 135.7, 61.3], 'Naranja'),
    DataPoint([174.4, 136.2, 59.2], 'Naranja'),
    DataPoint([167.0, 127.9, 72.9], 'Naranja'),
    DataPoint([164.8, 127.5, 78.0], 'Naranja'),
    DataPoint([167.9, 138.3, 65.6], 'Naranja'),
    DataPoint([136.4, 110.2, 75.4], 'Naranja'),
    DataPoint([109.5, 87.5, 32.8], 'Naranja'),
    DataPoint([140.5, 106.4, 37.2], 'Naranja'),
    DataPoint([124.6, 91.8, 28.4], 'Naranja'),
    DataPoint([119.7, 109.8, 44.7], 'Naranja'),
    DataPoint([132.8, 107.3, 35.2], 'Naranja'),
    DataPoint([129.3, 105.3, 31.5], 'Naranja'),
    DataPoint([128.4, 94.7, 37.0], 'Naranja'),
    DataPoint([86.6, 70.1, 15.1], 'Naranja'),
    DataPoint([129.9, 103.0, 26.2], 'Naranja'),
    DataPoint([168.3, 109.5, 70.9], 'Naranja'),
    DataPoint([172.8, 136.6, 71.6], 'Naranja'),
    DataPoint([149.7, 113.9, 58.4], 'Naranja'),
    DataPoint([166.3, 113.4, 68.3], 'Naranja'),
    DataPoint([164.2, 107.7, 66.3], 'Naranja'),
    DataPoint([178.4, 127.9, 74.4], 'Naranja'),
    DataPoint([172.7, 129.6, 78.5], 'Naranja'),
    DataPoint([180.7, 131.6, 77.3], 'Naranja'),
    DataPoint([173.9, 134.2, 81.4], 'Naranja'),
    DataPoint([176.2, 129.4, 82.8], 'Naranja'),
    DataPoint([164.1, 121.1, 83.5], 'Naranja'),
    DataPoint([164.6, 120.2, 82.3], 'Naranja'),
    DataPoint([163.7, 126.2, 79.2], 'Naranja'),
    DataPoint([172.8, 125.7, 38.8], 'Naranja'),
    DataPoint([174.9, 132.2, 47.1], 'Naranja'),
    DataPoint([170.1, 130.5, 72.2], 'Naranja'),
    DataPoint([171.9, 127.0, 92.3], 'Naranja'),
    DataPoint([169.6, 123.3, 90.0], 'Naranja'),
    DataPoint([161.5, 101.3, 81.5], 'Naranja'),
    DataPoint([158.3, 124.1, 79.3], 'Naranja'),
    DataPoint([164.5, 154.1, 101.9], 'Naranja'),
    DataPoint([167.8, 146.9, 108.9], 'Naranja'),
    DataPoint([167.4, 144.9, 95.2], 'Naranja'),
    DataPoint([171.0, 152.6, 93.2], 'Naranja'),
    DataPoint([169.1, 142.1, 91.2], 'Naranja'),
    DataPoint([164.2, 142.3, 77.6], 'Naranja'),
    DataPoint([164.0, 138.2, 75.4], 'Naranja'),
    DataPoint([160.4, 143.7, 78.1], 'Naranja'),
    DataPoint([161.5, 147.3, 76.1], 'Naranja'),
    DataPoint([169.3, 140.1, 70.5], 'Naranja'),
    DataPoint([144.7, 103.2, 57.2], 'Naranja'),
    DataPoint([112.9, 80.4, 50.9], 'Naranja'),
    DataPoint([142.9, 102.6, 58.6], 'Naranja'),
    DataPoint([84.2, 59.8, 54.4], 'Naranja'),
    DataPoint([85.6, 65.8, 62.5], 'Naranja'),
    DataPoint([119.6, 96.2, 70.6], 'Naranja'),
    DataPoint([147.8, 105.3, 62.0], 'Naranja'),
    DataPoint([112.7, 92.4, 59.7], 'Naranja'),
    DataPoint([127.2, 105.6, 70.0], 'Naranja'),
    DataPoint([141.9, 112.3, 65.6], 'Naranja'),
    DataPoint([164.9, 121.0, 12.0], 'Naranja'),
    DataPoint([170.0, 125.1, 18.4], 'Naranja'),
    DataPoint([161.2, 119.3, 22.1], 'Naranja'),
    DataPoint([171.1, 116.0, 16.3], 'Naranja'),
    DataPoint([163.3, 109.2, 19.0], 'Naranja'),
    DataPoint([164.6, 110.1, 17.9], 'Naranja'),
    DataPoint([165.7, 113.8, 15.0], 'Naranja'),
    DataPoint([156.2, 108.7, 17.7], 'Naranja'),
    DataPoint([156.4, 112.3, 28.6], 'Naranja'),
    DataPoint([144.8, 106.7, 40.8], 'Naranja'),
    DataPoint([157.9, 117.2, 57.5], 'Naranja'),
    DataPoint([165.7, 125.7, 57.0], 'Naranja'),
    DataPoint([156.0, 134.3, 62.3], 'Naranja'),
    DataPoint([167.8, 130.1, 54.8], 'Naranja'),
    DataPoint([170.8, 128.5, 56.4], 'Naranja'),
    DataPoint([167.2, 125.5, 53.5], 'Naranja'),
    DataPoint([153.7, 137.1, 64.8], 'Naranja'),
    DataPoint([157.6, 122.6, 59.1], 'Naranja'),
    DataPoint([156.3, 113.9, 56.0], 'Naranja'),
    DataPoint([157.7, 116.6, 55.9], 'Naranja'),
    DataPoint([160.0, 126.0, 72.8], 'Naranja'),
    DataPoint([160.2, 117.3, 65.8], 'Naranja'),
    DataPoint([157.8, 114.9, 69.7], 'Naranja'),
    DataPoint([159.2, 119.5, 61.1], 'Naranja'),
    DataPoint([154.2, 120.8, 71.4], 'Naranja'),
    DataPoint([153.8, 113.5, 69.3], 'Naranja'),
    DataPoint([154.4, 114.0, 59.9], 'Naranja'),
    DataPoint([150.3, 108.6, 55.9], 'Naranja'),
    DataPoint([148.4, 114.5, 64.9], 'Naranja'),
    DataPoint([153.4, 113.7, 71.9], 'Naranja'),
    DataPoint([158.4, 139.2, 93.6], 'Naranja'),
    DataPoint([158.3, 136.0, 71.3], 'Naranja'),
    DataPoint([133.0, 132.3, 62.4], 'Naranja'),
    DataPoint([158.4, 140.2, 89.4], 'Naranja'),
    DataPoint([130.8, 132.6, 82.2], 'Naranja'),
    DataPoint([142.7, 126.9, 65.6], 'Naranja'),
    DataPoint([130.1, 136.8, 80.6], 'Naranja'),
    DataPoint([119.3, 128.4, 90.0], 'Naranja'),
    DataPoint([149.8, 126.4, 67.5], 'Naranja'),
    DataPoint([140.9, 139.4, 85.1], 'Naranja'),
    DataPoint([163.2, 138.1, 58.9], 'Naranja'),
    DataPoint([174.4, 122.5, 48.8], 'Naranja'),
    DataPoint([180.3, 137.3, 65.0], 'Naranja'),
    DataPoint([167.7, 149.2, 63.4], 'Naranja'),
    DataPoint([166.8, 139.1, 56.5], 'Naranja'),
    DataPoint([162.9, 150.0, 56.2], 'Naranja'),
    DataPoint([161.2, 136.0, 54.6], 'Naranja'),
    DataPoint([159.2, 124.8, 59.0], 'Naranja'),
    DataPoint([155.9, 150.5, 55.7], 'Naranja'),
    DataPoint([154.3, 133.6, 64.7], 'Naranja'),
  ];

  Future<ClassificationResult> classifyImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final img.Image? decodedImage = img.decodeImage(bytes);

    if (decodedImage == null) {
      return ClassificationResult(label: "Error al procesar la imagen", isMatch: false);
    }

    List<double> newFeatures = _calculateAverageRgb(decodedImage);

    double r = newFeatures[0];
    double g = newFeatures[1];
    double b = newFeatures[2];

    // ----------------------------------------------------------------
    // 🛡️ NUEVO: PRE-FILTROS DE SEGURIDAD (ANTI-TAPETES Y FLASH)
    // ----------------------------------------------------------------

    // 1. Filtro de Oscuridad (Si el promedio de todo es muy bajo, es casi negro)
    if (r < 40 && g < 40 && b < 40) {
      return ClassificationResult(label: "Demasiado oscuro (No es fruta)", isMatch: false);
    }

    // 2. Filtro de Saturación (Anti Grises/Blancos/Tapetes con flash)
    // Calculamos la diferencia entre el color más fuerte y el más débil.
    // Si la diferencia es muy pequeña, significa que es un color "neutro/grisáceo".
    double maxColor = [r, g, b].reduce(max);
    double minColor = [r, g, b].reduce(min);

    if (maxColor - minColor < 35) {
      // La imagen no tiene un color vibrante dominante.
      return ClassificationResult(label: "No se encuentra clasificado.", isMatch: false);
    }
    // ----------------------------------------------------------------

    // 3. Flujo KNN normal (Si pasó los filtros de seguridad)
    List<MapEntry<double, String>> distances = [];
    for (var point in knownDataset) {
      double dist = _calculateEuclideanDistance(newFeatures, point.features);
      distances.add(MapEntry(dist, point.label));
    }

    distances.sort((a, b) => a.key.compareTo(b.key));

    // Regla de rechazo estricta
    if (distances.first.key > distanceThreshold) {
      return ClassificationResult(label: "No se encontraron coincidencias", isMatch: false);
    }

    int lemonVotes = 0;
    int orangeVotes = 0;

    for (int i = 0; i < k; i++) {
      if (distances[i].value == 'Limón') {
        lemonVotes++;
      } else {
        orangeVotes++;
      }
    }

    if (lemonVotes > orangeVotes) {
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

    for (int y = 0; y < image.height; y += 2) {
      for (int x = 0; x < image.width; x += 2) {
        final pixel = image.getPixelSafe(x, y);
        rSum += pixel.r.toInt();
        gSum += pixel.g.toInt();
        bSum += pixel.b.toInt();
        pixelCount++;
      }
    }

    if (pixelCount == 0) return [0.0, 0.0, 0.0];

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