import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: onTap, 

      items: [
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selectedIndex == 0
                      ? Colors.blue
                      : Color(0xFFF1F5F9),
                ),
                child: Image.asset(
                  selectedIndex == 0
                      ? 'lib/asset/icons/w_building.png'
                      : 'lib/asset/icons/a_building.png',
                  width: 30,
                  height: 30,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Daftar Kelas',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: selectedIndex == 0
                      ? Colors.blue
                      : Colors.blueGrey,
                ),
              ),
            ],
          ),
          label: '',
        ),

        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selectedIndex == 1
                      ? Colors.blue
                      : Color(0xFFF1F5F9),
                ),
                child: Image.asset(
                  selectedIndex == 1
                      ? 'lib/asset/icons/w_bell.png'
                      : 'lib/asset/icons/a_bell.png',
                  width: 30,
                  height: 30,
                ),
              ),
              SizedBox(height: 4),
              Text('Pengumuman',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: selectedIndex == 1
                        ? Colors.blue
                        : Colors.blueGrey,
                  )),
            ],
          ),
          label: '',
        ),

        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selectedIndex == 2
                      ? Colors.blue
                      : Color(0xFFF1F5F9),
                ),
                child: Image.asset(
                  selectedIndex == 2
                      ? 'lib/asset/icons/w_add-p.png'
                      : 'lib/asset/icons/a_add-p.png',
                  width: 30,
                  height: 30,
                ),
              ),
              SizedBox(height: 4),
              Text('Tambah',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: selectedIndex == 2
                        ? Colors.blue
                        : Colors.blueGrey,
                  )),
            ],
          ),
          label: '',
        ),
      ],
    );
  }
}