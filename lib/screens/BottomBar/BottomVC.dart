import 'package:flutter/material.dart';
import 'package:getkrowd/screens/BottomBar/WaitListVC.dart';
import 'package:getkrowd/screens/BottomBar/scan_screen.dart';

class BottomVC extends StatefulWidget {
  const BottomVC({Key? key}) : super(key: key);

  @override
  State<BottomVC> createState() => _BottomVCState();
}

class _BottomVCState extends State<BottomVC>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _currentIndex = 0;
  final List<Widget> _children = [
    const ScanScreen(),
    const WaitListVC(),
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: _children.length);

    _tabController?.addListener(() {
      setState(() {
        _currentIndex = _tabController!.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _tabController?.animateTo(_currentIndex);
          });
        },
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[800],
        selectedLabelStyle: const TextStyle(color: Colors.yellow),
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Wait List',
          ),
        ],
      ),
    );
  }
}
