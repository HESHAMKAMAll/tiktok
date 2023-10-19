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
  // late PageController pageController;
  //
  // @override
  // void initState() {
  //   pageController = PageController();
  //   super.initState();
  // }
  //
  // @override
  // void dispose() {
  //   pageController.dispose();
  //   super.dispose();
  // }

  // void navigationTapped(int page) {
  //   // pageController.jumpToPage(page);
  //   pageController.animateToPage(
  //     page,
  //     duration: Duration(milliseconds: 300),
  //     curve: Curves.linear,
  //   );
  // }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // context.read<UploadVideoController>().isLoading.stream.listen((event) {});
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
