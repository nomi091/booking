import 'dart:io';

import 'package:flutter/material.dart';

import '../DB/dbHandler.dart';
import '../Model/driverModel.dart';
import 'driverForm.dart';
import 'editdriver.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  List<DrivereModel> dlist = [];
  Future<void> loaddriver() async {
    dlist = await DbHandler.instance.ShowDriverRecords();
    setState(() {});
  }

  void addDriver() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => (const DriverForm())),
    );
    loaddriver();
  }

  @override
  void initState() {
    super.initState();
    loaddriver();
  }

  void delDriverRecord(int DID) async {
    await DbHandler.instance.delDriverRecord(DID);
    loaddriver();
  }

  void editVehicleRecords(DrivereModel d) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditDriver(d.did, d)));
    loaddriver();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Add a title to the AppBar
        title: const Text('View Drivers'),
      ),
      body: ListView.builder(
          itemCount: dlist.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Row(
                    children: [
                      dlist[index].imagePath != null
                          ? Image.file(
                              File(dlist[index]
                                  .imagePath), // Load the image from the file path
                              width: 50, // Set the desired width
                              height: 50, // Set the desired height
                            )
                          : const SizedBox(),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                         // color: Colors.black,
                          height: 40,
                          width: 70,
                          child: Text(dlist[index].Name.toString())),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          //color: Colors.black,
                          height: 40,
                          width: 70,
                          child: Text(dlist[index].contact.toString())),
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                          onPressed: () {
                            editVehicleRecords(dlist[index]);
                          },
                          icon: const Icon(Icons.edit)),
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                          onPressed: () => delDriverRecord(dlist[index].did),
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: addDriver,
        child: const Icon(Icons.add),
      ),
    );
  }
}
