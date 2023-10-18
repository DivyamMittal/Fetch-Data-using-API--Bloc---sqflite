import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';
import '../database/database_helper.dart';
import '../models/user_model.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];
  bool _dataLoaded = false; // Add a flag to track data loading

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final db = await DatabaseHelper.instance.database;
    final userData = await db.query('user');
    log("userdata: ${userData.length}");
    users = userData.map((json) => UserModel.fromJson(json)).toList();
    filterUsers(_searchController.text);
    log("users length: ${users.length}");

    // Set the dataLoaded flag to true after data is loaded
    setState(() {
      _dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_dataLoaded) {
      // Display a loading indicator or a message while data is being loaded
      return Scaffold(
        appBar: AppBar(
          title: Text('User List'),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(), // Add loading indicator
        ),
      );
    } else {
      // Once data is loaded, display the user list
      return Scaffold(
        appBar: AppBar(
          title: Text('User List'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  filterUsers(query);
                },
                decoration: InputDecoration(
                  labelText: 'Search by Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  log("data is here");
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(user.id.toString()),
                    ),
                    title: Text(
                      user.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user.username),
                    trailing: Text(user.email),
                  );
                },
              ),
            )
            // BlocBuilder<UserBloc, List<UserModel>>(
            //   builder: (context, users) {
            //     if (users.isEmpty) {
            //       return CircularProgressIndicator(); // Display a loading indicator
            //     } else {
            //       return Expanded(
            //         child: ListView.builder(
            //           itemCount: users.length,
            //           itemBuilder: (context, index) {
            //             final user = users[index];
            //             log("data is here");
            //             return ListTile(
            //               leading: CircleAvatar(
            //                 child: Text(user.id.toString()),
            //               ),
            //               title: Text(
            //                 user.name,
            //                 style: TextStyle(
            //                     fontSize: 18, fontWeight: FontWeight.bold),
            //               ),
            //               subtitle: Text(user.username),
            //               trailing: Text(user.email),
            //             );
            //           },
            //         ),
            //       );
            //     }
            //   },
            // ),
          ],
        ),
      );
    }
  }

  void filterUsers(String query) {
    final lowercaseQuery = query.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredUsers = List.from(users);
        setState(() {});
        log("query empty: ${filteredUsers.length}");
      } else {
        log("query not empty: ${filteredUsers.length}");
        filteredUsers = users
            .where((user) => user.name.toLowerCase().contains(lowercaseQuery))
            .toList();
      }
    });
  }
}
