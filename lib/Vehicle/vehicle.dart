import 'dart:io';

import 'package:flutter/material.dart';
import 'package:booking/Model/vehicleModel.dart';
import 'package:booking/Vehicle/editvehicle.dart';
import 'package:booking/Vehicle/vehicleForm.dart';
import 'package:booking/DB/dbHandler.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreeneState();
}

class _VehicleScreeneState extends State<VehicleScreen> {
  List<VehicleModel> vlist = [];
  Future<void> loadveh() async {
    vlist = await DbHandler.instance.ShowVehicleRecords();
    setState(() {});
  }

  void addVehicle() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => (const VehicleForm())),
    );
    loadveh();
  }

  @override
  void initState() {
    super.initState();
    loadveh();
  }

  void delVehicleRecord(int VID) async {
    await DbHandler.instance.delVehicleRecord(VID);
    loadveh();
  }

  void editVehicleRecords(VehicleModel v) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditVehicle(v.vid, v)));
    loadveh();
  }

  @override
  Widget build(BuildContext context) {
    // loadveh();
    return Scaffold(
      appBar: AppBar(
        // Add a title to the AppBar
        title: const Text('Registered Cars'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addVehicle,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: vlist.length,
          itemBuilder: (context, index) {
            return SafeArea(
              child: SizedBox(
                height: 80,
                width: 300,
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Row(
                            children: [
                              if (vlist[index]
                                  .imagePath!
                                  .isNotEmpty) // Check if imagePath is not null
                                Image.file(
                                  File(vlist[index]
                                      .imagePath!), // Load the image from the file path
                                  width: 50, // Set the desired width
                                  height: 50, // Set the desired height
                                ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(vlist[index].make),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(vlist[index].color),
                              const SizedBox(
                                width: 55,
                              ),
                              IconButton(
                                  onPressed: () {
                                    editVehicleRecords(vlist[index]);
                                  },
                                  icon: const Icon(Icons.edit)),
                              const SizedBox(
                                width: 15,
                              ),
                              IconButton(
                                  onPressed: () =>
                                      delVehicleRecord(vlist[index].vid),
                                  icon: const Icon(Icons.delete))
                            ],
                          ),
                        ],
                      )),
                ),
              ),
            );
          }),
    );
  }
}
