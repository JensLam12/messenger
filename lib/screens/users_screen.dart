import 'package:chat_app/models/users.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../services/socket_service.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final userService = UsersServices();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<User> users = [];
  // final users = [
  //   User(online: true, email: 'turing@gmail.com', name: 'Turing', uuid: '1'),
  //   User(online: false, email: 'clarke@gmail.com', name: 'Clarke', uuid: '2'),
  //   User(online: true, email: 'trump@gmail.com', name: 'Trump', uuid: '3')
  // ];

  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final user = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: Text( user.name, style: const TextStyle( color: Colors.black87) ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon( Icons.exit_to_app, color: Colors.black87 ), 
          onPressed: () { 
            socketService.disconnect();
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: 
            (socketService.serverStatus == ServerStatus.online ) 
              ? Icon( Icons.check_circle, color: Colors.blue[400] )
              : const Icon( Icons.offline_bolt, color: Colors.red ),
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
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usertTo = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _loadUsers() async {
    //await Future.delayed(const Duration(milliseconds: 1000));
    users = await userService.getUsers();
    setState(() {});
    _refreshController.refreshCompleted();
  }
}