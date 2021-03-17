import 'package:apiretrofit/models/user_model.dart';
import 'package:apiretrofit/repositories/user_respository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// instacia do repo */
  final _repository = UserRepository(Dio());

  final nameTextEditingController = TextEditingController();
  final usernameTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Api Retrofit'))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => newUser(),
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _repository.findAll(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final users = snapshot.data;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  onTap: () => showDetails(user.id),
                  title: Text(user.name),
                  subtitle: Text(user.username),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  void showDetails(String id) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: FutureBuilder<UserModel>(
              future: _repository.findById(id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final user = snapshot.data;
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.username),
                  );
                }
                return Container();
              },
            ),
          );
        });
  }

  void newUser() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Container(
              height: 100,
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameTextEditingController,
                    ),
                    TextFormField(
                      controller: usernameTextEditingController,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              FlatButton(
                  onPressed: () async {
                    await _repository.save(UserModel(
                        name: nameTextEditingController.text,
                        username: usernameTextEditingController.text));
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text('Salvar'))
            ],
          );
        });
  }
}
