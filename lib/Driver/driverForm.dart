import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../DB/DbHandler.dart';
import '../Model/driverModel.dart';

class DriverForm extends StatefulWidget {
  const DriverForm({super.key});

  @override
  State<DriverForm> createState() => _DriverFormState();
}

class _DriverFormState extends State<DriverForm> {
  TextEditingController cont1 = TextEditingController();
  TextEditingController cont2 = TextEditingController();
  TextEditingController cont3 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> addDriverRecord(BuildContext context) async {
    int did = int.parse(cont1.text);
    String name = cont2.text;
    int contact = int.parse(cont3.text);

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
      DrivereModel driver = DrivereModel(
          did: did, Name: name, contact: contact, imagePath: imageFilePath);

      DbHandler.instance.addDriverRecord(driver);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Drivers'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      children: [
                        TextFormField(
                          controller: cont1,
                          decoration: const InputDecoration(
                            labelText: 'Driver ID',
                            hintText: 'Enter Driver ID (int)',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Driver ID';
                            }
                            try {
                              int.parse(value);
                            } catch (e) {
                              return 'Driver ID must be an integer';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: cont2,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter Driver Name (string)',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: cont3,
                          decoration: const InputDecoration(
                            labelText: 'Contact Number',
                            hintText: 'Enter Contact Number (int)',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Contact Number';
                            }
                            try {
                              int.parse(value);
                            } catch (e) {
                              return 'Contact Number must be an integer';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              addDriverRecord(context);
                            }
                          },
                          child: const Text('Submit'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
        ));
  }
}
