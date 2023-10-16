import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../widgets/custome_icon.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int page) {
    // pageController.jumpToPage(page);
    pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

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
          PageView(
            allowImplicitScrolling: true,
            children: pages,
            controller: pageController,
            onPageChanged: onPageChanged,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.transparent,
                // boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 1)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CupertinoButton(
                    onPressed: () {
                      navigationTapped(0);
                    },
                    padding: EdgeInsets.zero,
                    child: Icon(Icons.home,color: _page == 0 ? buttonColor : Colors.grey),
                    // color: _page == 0 ? buttonColor : Colors.grey,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      navigationTapped(1);
                    },
                    padding: EdgeInsets.zero,
                    child: Icon(Icons.search,color: _page == 1 ? buttonColor : Colors.grey),
                    // color: _page == 1 ? buttonColor : Colors.grey,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      navigationTapped(2);
                      showOptionDialog(context);
                    },
                    padding: EdgeInsets.zero,
                    child: CustomIcon(),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      navigationTapped(3);
                    },
                    padding: EdgeInsets.zero,
                    child: Icon(Icons.message_outlined,color: _page == 3 ? buttonColor : Colors.grey),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      navigationTapped(4);
                    },
                    padding: EdgeInsets.zero,
                    child: Icon(Icons.person_outline,color: _page == 4 ? buttonColor : Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: CupertinoTabBar(
      //   onTap: navigationTapped,
      //   currentIndex: _page,
      //   backgroundColor: Colors.transparent,
      //   activeColor: buttonColor,
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
      //     BottomNavigationBarItem(icon: CustomIcon()),
      //     BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: "Messages"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
      //   ],
      // ),
    );
  }
}
