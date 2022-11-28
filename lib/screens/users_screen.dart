import 'package:chat_app/models/users.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final users = [
    User(online: true, email: 'turing@gmail.com', name: 'Turing', uuid: '1'),
    User(online: false, email: 'clarke@gmail.com', name: 'Clarke', uuid: '2'),
    User(online: true, email: 'trump@gmail.com', name: 'Trump', uuid: '3')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My name', style: TextStyle( color: Colors.black87) ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon( Icons.exit_to_app, color: Colors.black87 ), 
          onPressed: () { 

          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon( Icons.check_circle, color: Colors.blue[400] ),
            //child: Icon( Icons.offline_bolt, color: Colors.red ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        header: WaterDropHeader(
          complete: Icon( Icons.check, color: Colors.blue[400] ),
          waterDropColor: Colors.blue,
        ),
        child: _listviewUsers(),
      )
    );
  }

  ListView _listviewUsers() {
    return ListView.separated(
      itemBuilder: ( _, i ) => _userListTitle(users[i]), 
      itemCount: users.length, 
      separatorBuilder: ( _, int index) => const Divider(),
    );
  }

  ListTile _userListTitle(User user) {
    return ListTile(
        title: Text( user.name),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text( user.name.substring(0,2))
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
      );
  }

  _loadUsers() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}