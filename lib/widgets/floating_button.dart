import 'package:flutter/material.dart';
import '../screens/candidate_screen.dart';
import '../constants/colors.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).pushNamed(CandidateScreen.routeName);
      },
      label: const Text('Candidate'),
      icon: const Icon(Icons.add),
      backgroundColor: primaryColor,
    );
  }
}
