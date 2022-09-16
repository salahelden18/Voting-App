import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../provider/home_provider.dart';
import '../widgets/candidate_info_item.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<Map<String, dynamic>> user;
  var _isInit = true;

  Future<Map<String, dynamic>> getUser() {
    return Provider.of<HomeProvider>(context).getUserData();
  }

  // @override
  // void initState() {
  //   user = getUser();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      user = getUser();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: user,
      builder: (ctx, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                CandidateInfoItem(
                  title: 'username: ',
                  value: snapshot.data!['name'],
                ),
                CandidateInfoItem(
                  title: 'department: ',
                  value: snapshot.data!['department'],
                ),
                CandidateInfoItem(
                  title: 'email: ',
                  value: snapshot.data!['email'],
                ),
                Card(
                  elevation: 4,
                  child: ListTile(
                    onTap: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .logout();
                    },
                    title: Text(
                      'Logout',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: const Text('Tab to logout'),
                    trailing: const Icon(Icons.exit_to_app),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
