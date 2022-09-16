import 'package:flutter/material.dart';

class CandidateInfoItem extends StatelessWidget {
  const CandidateInfoItem({Key? key, required this.title, required this.value})
      : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(15),
          // child: Text('$title: $value'),
          child: RichText(
            text: TextSpan(
              text: title,
              style: Theme.of(context).textTheme.headline6,
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
