// import 'package:flutter/material.dart';
// import 'package:booking/DB/dbHandler.dart';
// import 'package:booking/Model/bookingModel.dart';
// import 'package:booking/Model/expenseModel.dart';


// class BookingExpensePage extends StatefulWidget {
//   const BookingExpensePage({Key? key}) : super(key: key);

//   @override
//   _BookingExpensePageState createState() => _BookingExpensePageState();
// }

// class _BookingExpensePageState extends State<BookingExpensePage> {
//   late TextEditingController bookingIdController;
//   late TextEditingController expenseTypeController;
//   late TextEditingController amountController;
//   List<BookingModel> bookings = [];

//   @override
//   void initState() {
//     super.initState();
//     bookingIdController = TextEditingController();
//     expenseTypeController = TextEditingController();
//     amountController = TextEditingController();

//     // Fetch the list of bookings
//     DbHandler.instance.getAllBookings().then((bookingsList) {
//       setState(() {
//         bookings = bookingsList;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     bookingIdController.dispose();
//     expenseTypeController.dispose();
//     amountController.dispose();
//     super.dispose();
//   }

//   InputDecoration buildInputDecoration(String label) {
//     return InputDecoration(
//       hintText: 'Enter $label',
//       labelText: 'Enter $label',
//       hintStyle: const TextStyle(
//           fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
//       labelStyle: const TextStyle(
//           fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
//       border: const OutlineInputBorder(),
//     );
//   }

//   ButtonStyle buildButtonStyle() {
//     return ButtonStyle(
//       minimumSize: MaterialStateProperty.all(
//         const Size(290, 48),
//       ),
//       backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Booking Expense List'),
//       ),
//       body: FutureBuilder<List<BookingExpense>>(
//         future: DbHandler.instance.getAllBookingExpenses(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text('No booking expenses available.'),
//             );
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 BookingExpense bookingExpense = snapshot.data![index];
//                 return ListTile(
//                   title: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Expense ID: ${bookingExpense.id}'),
//                       Text('Booking ID: ${bookingExpense.bookingId}'),
//                       Text('Expense Type: ${bookingExpense.expenseType}'),
//                       Text('Amount: ${bookingExpense.amount}'),
//                     ],
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.edit),
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 content: SingleChildScrollView(
//                                   scrollDirection: Axis.vertical,
//                                   child: Column(
//                                     children: [
//                                       DropdownButtonFormField<int>(
//                                         value: bookingExpense.bookingId,
//                                         items: bookings.map((BookingModel booking) {
//                                           return DropdownMenuItem<int>(
//                                             value: booking.id!,
//                                             child: Text('Booking ID: ${booking.id}'),
//                                           );
//                                         }).toList(),
//                                         onChanged: (int? newValue) {
//                                           setState(() {
//                                             bookingExpense.bookingId = newValue!;
//                                           });
//                                         },
//                                         decoration: buildInputDecoration('Booking ID'),
//                                       ),
//                                       const SizedBox(height: 3),
//                                       TextField(
//                                         controller: expenseTypeController
//                                           ..text = bookingExpense.expenseType,
//                                         decoration: buildInputDecoration('Expense Type'),
//                                       ),
//                                       const SizedBox(height: 3),
//                                       TextField(
//                                         controller: amountController
//                                           ..text = bookingExpense.amount.toString(),
//                                         decoration: buildInputDecoration('Amount'),
//                                       ),
//                                       const SizedBox(height: 10),
//                                       ElevatedButton(
//                                         onPressed: () async {
//                                           bookingExpense.expenseType =
//                                               expenseTypeController.text;
//                                           bookingExpense.amount =
//                                               double.parse(amountController.text);

//                                           int rowsAffected = await DbHandler.instance
//                                               .updateBookingExpense(bookingExpense);

//                                           if (rowsAffected > 0) {
//                                             Navigator.of(context).pop();
//                                             setState(() {});
//                                           } else {
//                                             // Handle update error
//                                             // ...
//                                           }
//                                         },
//                                         style: buildButtonStyle(),
//                                         child: const Text(
//                                           'Update',
//                                           style: TextStyle(
//                                               fontSize: 18,
//                                               fontStyle: FontStyle.italic),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: const Text('Confirm Deletion'),
//                                 content:
//                                 const Text('Are you sure you want to delete this expense?'),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                     child: const Text('Cancel'),
//                                   ),
//                                   TextButton(
//                                     onPressed: () async {
//                                       int rowsAffected = await DbHandler.instance
//                                           .deleteBookingExpense(bookingExpense.id!);

//                                       if (rowsAffected > 0) {
//                                         Navigator.of(context).pop();
//                                         setState(() {});
//                                       } else {
//                                         // Handle deletion error
//                                         // ...
//                                       }
//                                     },
//                                     child: const Text('Delete'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           bookingIdController.clear();
//           expenseTypeController.clear();
//           amountController.clear();

//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 content: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Column(
//                     children: [
//                       DropdownButtonFormField<int>(
//                         value: bookings.isNotEmpty ? bookings.first.id : null,
//                         items: bookings.map((BookingModel booking) {
//                           return DropdownMenuItem<int>(
//                             value: booking.id!,
//                             child: Text('Booking ID: ${booking.id}'),
//                           );
//                         }).toList(),
//                         onChanged: (int? newValue) {
//                           setState(() {
//                             bookingIdController.text = newValue.toString();
//                           });
//                         },
//                         decoration: buildInputDecoration('Booking ID'),
//                       ),
//                       const SizedBox(height: 3),
//                       TextField(
//                         controller: expenseTypeController,
//                         decoration: buildInputDecoration('Expense Type'),
//                       ),
//                       const SizedBox(height: 3),
//                       TextField(
//                         controller: amountController,
//                         decoration: buildInputDecoration('Amount'),
//                         keyboardType: TextInputType.number,
//                       ),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () async {
//                           String errorMessage = '';
//                           try {
//                             BookingExpense newBookingExpense = BookingExpense(
//                               bookingId: int.parse(bookingIdController.text),
//                               expenseType: expenseTypeController.text,
//                               amount: double.parse(amountController.text),
//                             );

//                             int rowId = await DbHandler.instance
//                                 .insertBookingExpense(newBookingExpense);

//                             if (rowId > 0) {
//                               Navigator.of(context).pop();
//                               setState(() {
//                                 bookingIdController.clear();
//                                 expenseTypeController.clear();
//                                 amountController.clear();
//                               });
//                             } else {
//                               errorMessage = 'Error saving data';
//                             }
//                           } catch (e) {
//                             errorMessage = 'Error: $e';
//                           }

//                           if (errorMessage.isNotEmpty) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(errorMessage),
//                                 duration: const Duration(seconds: 2),
//                               ),
//                             );
//                           }
//                         },
//                         style: buildButtonStyle(),
//                         child: const Text(
//                           'Save',
//                           style: TextStyle(
//                               fontSize: 18, fontStyle: FontStyle.italic),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
