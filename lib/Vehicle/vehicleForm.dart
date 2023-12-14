import 'package:flutter/material.dart';
import 'package:booking/DB/dbHandler.dart';
import 'package:booking/Model/vehicleModel.dart';
import 'package:booking/customwidgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class VehicleForm extends StatefulWidget {
  const VehicleForm({Key? key}) : super(key: key);

  @override
  State<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  TextEditingController cont1 = TextEditingController();
  TextEditingController cont2 = TextEditingController();
  TextEditingController cont3 = TextEditingController();
  File? _selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> addVehicleRecord(BuildContext context) async {
    int vid = int.parse(cont1.text);
    String make = cont2.text;
    String color = cont3.text;

    // Use image_picker to select an image
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // If an image is selected, get the file path
      String imagePath = pickedFile.path;

      // Create a unique filename for the image
      String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Get the app's document directory
      Directory appDocDir = await getApplicationDocumentsDirectory();

      // Combine the directory path and image filename to get the full path
      String imageFilePath = '${appDocDir.path}/$imageFileName.png';

      // Move the selected image file to the app's document directory
      File(pickedFile.path).copy(imageFilePath);

      VehicleModel vehicle = VehicleModel(
        vid: vid,
        make: make,
        color: color,
        imagePath: imageFilePath, // Store the image path
      );

      // Save the vehicle model with the image path
      DbHandler.instance.addVehicleRecord(vehicle);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Car'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: cont1,
                    decoration: const InputDecoration(
                      labelText: 'Registration',
                      hintText: 'Enter Registration ID (int)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Registration ID';
                      }
                      try {
                        int.parse(value);
                      } catch (e) {
                        return 'Registration ID must be an integer';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: cont2,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Name',
                      hintText: 'Enter Vehicle Name (string)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Vehicle';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: cont3,
                    decoration: const InputDecoration(
                      labelText: 'Model Name',
                      hintText: 'Enter Model Name (string)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Model';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  customButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addVehicleRecord(context);
                      }
                    },
                    data: 'Submit',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
