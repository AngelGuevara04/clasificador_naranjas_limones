import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/classifier_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos la instancia reactiva de nuestro ViewModel
    final viewModel = Provider.of<ClassifierViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clasificador Cítricos (MVVM)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Muestra la imagen tomada o un ícono si está vacío
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
                  child: Icon(Icons.camera_alt, size: 120, color: Colors.grey),
                ),
              const SizedBox(height: 20),

              // Estado de carga o resultado
              if (viewModel.isLoading)
                const CircularProgressIndicator()
              else
                Text(
                  viewModel.classificationLabel,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // Botón flotante para interactuar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: viewModel.isLoading ? null : viewModel.pickImageAndClassify,
        icon: const Icon(Icons.camera),
        label: const Text("Tomar Foto"),
      ),
    );
  }
}