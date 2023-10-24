import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../widgets/material_custom.dart';
import 'profile.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchController = TextEditingController();

  // bool isShowUsers = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            Expanded(
              child: MaterialCustom(
                borderRadius: 10,
                child: TextFormField(
                  controller: searchController,
                  onChanged: (String _) {
                    setState(() {
                      // isShowUsers = true;
                    });
                  },
                  onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "search",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(CupertinoIcons.search, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                searchController.clear();
                setState(() {});
              },
              child: MaterialCustom(
                borderRadius: 10,
                child: const Padding(
                  padding: EdgeInsets.all(11.0),
                  child: Icon(Icons.clear_outlined),
                ),
              ),
            ),
          ],
        ),
      ),
      body: searchController.text.isNotEmpty
          ? StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').where('name', isGreaterThanOrEqualTo: searchController.text).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: buttonColor));
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(color: buttonColor));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) {
                    var data = snapshot.data!.docs[i];
                    return GestureDetector(
                      onTap: ()=>Navigator.push(context, CupertinoPageRoute(builder: (context) => Profile(data: data))),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            data["profilePhoto"],
                          ),
                        ),
                        title: Text(
                          data["name"],
                          style: TextStyle(
                            fontSize: 20,
                            color: buttonColor,
                          ),
                        ),
                        subtitle: Text(
                          data["email"],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Center(child: Image.asset("assets/icons/join.png", height: 300)),
                // SizedBox(height: 10),
                Center(
                  child: Text(
                    "Search for users!",
                    style: TextStyle(
                      color: buttonColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
