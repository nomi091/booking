import 'dart:io';

import 'package:flutter/material.dart';
import 'package:booking/Model/vehicleModel.dart';
import 'package:booking/customwidgets.dart';
import 'package:booking/DB/dbHandler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class EditVehicle extends StatefulWidget {
  //EditVehicle({super.key});
  int vid;
  VehicleModel v;
  EditVehicle(this.vid, this.v, {super.key});

  @override
  State<EditVehicle> createState() => _EditVehicleState();
}

class _EditVehicleState extends State<EditVehicle> {
  TextEditingController cont1 = TextEditingController();
  TextEditingController cont2 = TextEditingController();
  TextEditingController cont3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    cont1.text = widget.v.vid.toString();
    cont2.text = widget.v.make.toString();
    cont3.text = widget.v.color.toString();
  }

  Future<void> updateRecords(BuildContext context) async {
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
      DbHandler.instance.updateVehicleRecords(widget.vid, vehicle);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Add a title to the AppBar
          title: const Text('Edit Car'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                children: [
                  customTextField(
                      controller: cont1,
                      labelText: 'Registration',
                      hintText: 'Enter Vehicle Registration'),
                  customTextField(
                      controller: cont2,
                      labelText: 'Name',
                      hintText: 'Enter Vehicle Name'),
                  customTextField(
                      controller: cont3,
                      labelText: 'Model',
                      hintText: 'Enter Vehicle Model'),
                  const SizedBox(
                    height: 40,
                  ),
                  customButton(
                      onPressed: () => updateRecords(context), data: 'Update')
                ],
              ),
            ),
          )),
        ));
  }
}
