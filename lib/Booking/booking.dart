import 'package:flutter/material.dart';
import 'package:booking/DB/DbHandler.dart';
import 'package:booking/Model/bookingModel.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController totalCostController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  List<int> driverIds = [];
  List<int> vehicleIds = [];

  int? selectedDriverId;
  int? selectedVehicleId;

  @override
  void initState() {
    super.initState();

    totalCostController = TextEditingController();
    _fetchData();
  }

  @override
  void dispose() {
    totalCostController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final vehicleList = await DbHandler.instance.ShowVehicleRecords();
    setState(() {
      vehicleIds = vehicleList.map((e) => e.vid).toList();
      if (vehicleIds.isNotEmpty) {
        selectedVehicleId = vehicleIds.first;
      } else {
        selectedVehicleId = null;
      }
    });

    final driverList = await DbHandler.instance.ShowDriverRecords();
    setState(() {
      driverIds = driverList.map((driver) => driver.did).toList();
      selectedDriverId = driverIds.isNotEmpty ? driverIds.first : null;
    });
  }

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      hintText: 'Enter $label',
      labelText: 'Enter $label',
      hintStyle: const TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      labelStyle: const TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      border: const OutlineInputBorder(),
    );
  }

  ButtonStyle buildButtonStyle() {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(
        const Size(290, 48),
      ),
      backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
    );
  }

  Future<void> _selectDateTime(
      BuildContext context, TextEditingController controller,
      {bool isDate = true}) async {
    DateTime picked;
    if (isDate) {
      picked = (await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          )) ??
          DateTime.now();
    } else {
      TimeOfDay pickedTime = (await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          )) ??
          TimeOfDay.now();
      picked = DateTime.now()
          .add(Duration(hours: pickedTime.hour, minutes: pickedTime.minute));
    }

    if (picked != DateTime.now()) {
      controller.text = DateFormat('yyyy-MM-dd HH:mm').format(picked);
    }
  }

  void _editBooking(BuildContext context, BookingModel booking) {
    TextEditingController editedStartTimeController = TextEditingController();
    TextEditingController editedEndTimeController = TextEditingController();
    TextEditingController editedTotalCostController = TextEditingController();

    // Set the initial values for the edited booking

    editedTotalCostController.text = booking.totalCost.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                TextFormField(
                  controller: editedStartTimeController,
                  decoration: buildInputDecoration('Start Time'),
                  onTap: () =>
                      _selectDateTime(context, editedStartTimeController),
                ),
                const SizedBox(height: 3),
                TextFormField(
                  controller: editedEndTimeController,
                  decoration: buildInputDecoration('End Time'),
                  onTap: () => _selectDateTime(context, editedEndTimeController,
                      isDate: false),
                ),
                const SizedBox(height: 3),
                TextFormField(
                  controller: editedTotalCostController,
                  decoration: buildInputDecoration('Total Cost'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    String errorMessage = '';
                    try {
                      BookingModel updatedBooking = BookingModel(
                        id: booking.id,
                        driverId: booking.driverId,
                        vehicleId: booking.vehicleId,
                        city: 'Lahore',
                        totalCost: double.parse(editedTotalCostController.text),
                      );

                      int rowsAffected = await DbHandler.instance
                          .updateBooking(updatedBooking);

                      if (rowsAffected > 0) {
                        Navigator.of(context).pop();
                        setState(() {});
                      } else {
                        errorMessage = 'Error updating data';
                      }
                    } catch (e) {
                      errorMessage = 'Error: $e';
                    }

                    if (errorMessage.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorMessage),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: buildButtonStyle(),
                  child: const Text(
                    'Update',
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteBooking(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this booking?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                int rowsAffected =
                    await DbHandler.instance.deleteBooking(booking.id!);

                if (rowsAffected > 0) {
                  Navigator.of(context).pop();
                  setState(() {});
                } else {
                  // Handle deletion error
                  // ...
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking List'),
      ),
      body: FutureBuilder<List<BookingModel>>(
        future: DbHandler.instance.getAllBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No bookings available.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                BookingModel booking = snapshot.data![index];
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Driver ID: ${booking.driverId}'),
                      Text('Vehicle ID: ${booking.vehicleId}'),
                      Text('Total Cost: ${booking.totalCost}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // IconButton(
                      //   icon: const Icon(Icons.edit),
                      //   onPressed: () {
                      //     _editBooking(context, booking);
                      //   },
                      // ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteBooking(context, booking);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          totalCostController.clear();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      DropdownButtonFormField<int>(
                        value: selectedDriverId,
                        items: driverIds.map((driverId) {
                          return DropdownMenuItem<int>(
                            value: driverId,
                            child: Text('Driver ID: $driverId'),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          if (value != null) {
                            setState(() {
                              selectedDriverId = value;
                            });
                          }
                        },
                        decoration: buildInputDecoration('Driver ID'),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<int>(
                        value: selectedVehicleId,
                        items: vehicleIds.map((int vehicleId) {
                          return DropdownMenuItem<int>(
                            value: vehicleId,
                            child: Text('Vehicle ID: $vehicleId'),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          if (value != null) {
                            setState(() {
                              selectedVehicleId = value;
                            });
                          }
                        },
                        decoration: buildInputDecoration('Vehicle ID'),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: cityController,
                        decoration: buildInputDecoration('City'),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: totalCostController,
                        decoration: buildInputDecoration('Total Cost'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          String errorMessage = '';
                          try {
                            BookingModel newBooking = BookingModel(
                              id: 1,
                              driverId: selectedDriverId!,
                              vehicleId: selectedVehicleId!,
                              city: cityController.text,
                              totalCost: double.parse(totalCostController.text),
                            );

                            int rowId = await DbHandler.instance
                                .insertBooking(newBooking);

                            if (rowId > 0) {
                              Navigator.of(context).pop();
                              setState(() {
                                totalCostController.clear();
                              });
                            } else {
                              errorMessage = 'Error saving data';
                            }
                          } catch (e) {
                            errorMessage = 'Error: $e';
                          }

                          if (errorMessage.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        style: buildButtonStyle(),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 18, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
