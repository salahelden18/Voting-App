import 'package:flutter/material.dart';
import '../screens/candidate_info_screen.dart';
import '../constants/colors.dart';

// ignore: must_be_immutable
class CandidateItem extends StatelessWidget {
  CandidateItem({Key? key, required this.index, required this.snapshot})
      : super(key: key);
  int index;
  AsyncSnapshot<List<dynamic>> snapshot;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(CandidateInfoScreen.routeName,
              arguments: snapshot.data![index]);
        },
        contentPadding: const EdgeInsets.only(left: 5, right: 20),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: fifthColor,
          child: FittedBox(
            child: Text(
              snapshot.data![index]['votes'].toString(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: Text(
          snapshot.data![index]['name'],
        ),
        subtitle: Text(
          snapshot.data![index]['department'],
        ),
        trailing: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
