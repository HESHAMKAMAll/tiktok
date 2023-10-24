import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../widgets/custome_icon.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 0;

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[_page],
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              child: Column(
                children: [
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CupertinoButton(
                        onPressed: () {
                          onPageChanged(0);
                        },
                        padding: EdgeInsets.zero,
                        child: Icon(Icons.home,color: _page == 0 ? buttonColor : Colors.grey),
                        // color: _page == 0 ? buttonColor : Colors.grey,
                      ),
                      CupertinoButton(
                        onPressed: () {
                          onPageChanged(1);
                        },
                        padding: EdgeInsets.zero,
                        child: Icon(Icons.search,color: _page == 1 ? buttonColor : Colors.grey),
                        // color: _page == 1 ? buttonColor : Colors.grey,
                      ),
                      CupertinoButton(
                        onPressed: () {
                          onPageChanged(2);
                          // showOptionDialog(context);
                        },
                        padding: EdgeInsets.zero,
                        child: const CustomIcon(),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          onPageChanged(3);
                        },
                        padding: EdgeInsets.zero,
                        child: Icon(Icons.message_outlined,color: _page == 3 ? buttonColor : Colors.grey),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          onPageChanged(4);
                        },
                        padding: EdgeInsets.zero,
                        child: Icon(Icons.person_outline,color: _page == 4 ? buttonColor : Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
