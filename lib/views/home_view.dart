import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../viewmodels/classifier_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  /// Función auxiliar para mostrar el menú de selección de fuente
  void _showPickerOptions(BuildContext context, ClassifierViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () {
                  viewModel.pickImageAndClassify(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Cámara'),
                onTap: () {
                  viewModel.pickImageAndClassify(ImageSource.camera);
                  Navigator.of(context).pop();
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
    final viewModel = Provider.of<ClassifierViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clasificador Cítricos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // SafeArea protege contra la muesca (notch) y la barra de estado
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (viewModel.selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.file(
                        viewModel.selectedImage!,
                        height: 350,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.image_search, size: 120, color: Colors.grey),
                  ),
                const SizedBox(height: 20),
                if (viewModel.isLoading)
                  const CircularProgressIndicator()
                else
                  Text(
                    viewModel.classificationLabel,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 80), // Espacio para el botón extendido
              ],
            ),
          ),
        ),
      ), // <-- ¡Aquí faltaba el paréntesis de cierre del SafeArea!
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: viewModel.isLoading ? null : () => _showPickerOptions(context, viewModel),
        icon: const Icon(Icons.add_a_photo),
        label: const Text("Seleccionar Imagen"),
      ),
    );
  }
}