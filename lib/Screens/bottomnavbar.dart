import 'package:flutter/material.dart';

import '../Booking/booking.dart';
import '../Driver/driver.dart';
import '../Vehicle/vehicle.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;
  List<Widget> Screens = [
    const VehicleScreen(),
    const DriverScreen(),
    const BookingPage(),
    // const BookingExpensePage(),
    //  const BookingReportScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor:Colors.blue,
          items: const [
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.bus_alert,
                color: Colors.blue,
              ),
              icon: Icon(
                Icons.bus_alert,
                color: Colors.grey,
              ),
              label: 'Vehicle',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              icon: Icon(
                Icons.person,
                color: Colors.grey,
              ),
              label: 'Driver',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.book,
                color: Colors.blue,
              ),
              icon: Icon(
                Icons.book,
                color: Colors.grey,
              ),
              label: 'Booking',
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          }),
      body: Screens[selectedIndex],
    );
  }
}
