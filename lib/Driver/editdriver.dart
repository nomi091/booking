import 'dart:io';

import 'package:booking/DB/dbHandler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../Model/driverModel.dart';

class EditDriver extends StatefulWidget {
  //EditVehicle({super.key});
  int did;
  DrivereModel d;
  EditDriver(this.did, this.d, {super.key});

  @override
  State<EditDriver> createState() => _EditDriverState();
}

class _EditDriverState extends State<EditDriver> {
  TextEditingController cont1 = TextEditingController();
  TextEditingController cont2 = TextEditingController();
  TextEditingController cont3 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    cont1.text = widget.d.did.toString();
    cont2.text = widget.d.Name.toString();
    cont3.text = widget.d.contact.toString();
  }

  void updateRecords(BuildContext context) async {
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

      DbHandler.instance.updateDriverRecords(widget.did, driver);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              Form(
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
                              updateRecords(context);
                            }
                          },
                          child: const Text('Submit'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    ));
  }
}
