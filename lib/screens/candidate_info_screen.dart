import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_app_final_2_nodejs_api/screens/tabs_screen.dart';
import '../constants/colors.dart';
import '../helpers/http_exception.dart';
import '../helpers/snackbar.dart';
import '../provider/home_provider.dart';
import './home_screen.dart';
import '../widgets/candidate_info_item.dart';

class CandidateInfoScreen extends StatelessWidget {
  static const routeName = '/candidate-info-screen';
  const CandidateInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            CandidateInfoItem(
              title: 'username: ',
              value: userData['name'],
            ),
            CandidateInfoItem(
              title: 'department: ',
              value: userData['department'],
            ),
            CandidateInfoItem(
              title: 'GPA: ',
              value: '${userData['gpa']}',
            ),
            CandidateInfoItem(
              title: 'Grade: ',
              value: '${userData['grade']}',
            ),
            CandidateInfoItem(
              title: 'Votes: ',
              value: '${userData['votes']}',
            ),
            CandidateInfoItem(
              title: 'why d you want to be candidate? ',
              value: userData['repReansons'],
            ),
            CandidateInfoItem(
              title: 'what is your previous responsibiities? ',
              value: userData['previousRes'],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          try {
            Provider.of<HomeProvider>(context, listen: false)
                .updateUserVote(userData['_id'], userData['votes'])
                .then((value) {
              showSnackBar('you voted successfuly', Colors.green, context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  TabsScreen.routeName, (Route<dynamic> route) => false);
            }).catchError((e) {
              showSnackBar(e.message, Colors.red, context);
            });
          } on HttpException catch (e) {
            showSnackBar(e.message, Colors.red, context);
          } catch (e) {
            showSnackBar('something went wrong please try agian later',
                Colors.red, context);
          }
        },
        label: const Text('Vote'),
        icon: const Icon(Icons.check),
        backgroundColor: primaryColor,
      ),
    );
  }
}
