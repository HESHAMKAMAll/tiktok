import 'package:flutter/material.dart';
import '../models/user.dart';

class SearchController extends ChangeNotifier {
  final List<User> _searchUsers = [];
  List<User> get searchUsers => _searchUsers;

  searchUser(String typedUser) async{}
}