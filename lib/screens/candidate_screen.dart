import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../helpers/http_exception.dart';
import '../provider/home_provider.dart';
import './home_screen.dart';
import '../widgets/custom_text_from_field.dart';
import '../helpers/snackbar.dart';

class CandidateScreen extends StatelessWidget {
  static const routeName = '/candidate-screen';
  final _formKey = GlobalKey<FormState>();

  double? gpa;
  int? grade;
  String? repReansons;
  String? previousRes;

  CandidateScreen({Key? key}) : super(key: key);

  _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        Provider.of<HomeProvider>(context, listen: false)
            .updateUser(gpa!, grade!, previousRes!, repReansons!)
            .then((value) {
          showSnackBar('you are now a candidate', Colors.green, context);
          Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.routeName, (Route<dynamic> route) => false);
        });
      } on HttpException catch (e) {
        showSnackBar(e.message, Colors.red, context);
      } catch (e) {
        showSnackBar('please check your fields', Colors.red, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('be Candidate'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  textInputType: TextInputType.number,
                  text: 'GPA',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter Your GPA';
                    }

                    RegExp regExp = RegExp("(\\d+[,.]?[\\d]*)");
                    bool isMatch = regExp.hasMatch(val);
                    if (!isMatch) {
                      return 'Please Enter A Valid GPA';
                    }

                    if (double.parse(val) > 4 || double.parse(val) < 0) {
                      return 'GPA must be [0 - 4]';
                    }

                    return null;
                  },
                  save: (val) {
                    gpa = double.parse(val!);
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextFormField(
                  textInputType: TextInputType.number,
                  text: 'Grade',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter Your Grade';
                    }
                    RegExp _regExp = RegExp(r'^[1-4]+$');

                    bool isMatch = _regExp.hasMatch(val);
                    if (!isMatch) {
                      return 'Please Enter a Vaue Between 1 and 4';
                    }

                    return null;
                  },
                  save: (val) {
                    grade = int.parse(val!);
                  },
                ),
                const SizedBox(height: 5),
                CustomTextFormField(
                  maxLines: 5,
                  textInputType: TextInputType.text,
                  text: 'Why do you want to be representative',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter Your Explanation';
                    }
                    return null;
                  },
                  save: (val) {
                    repReansons = val!;
                  },
                ),
                const SizedBox(height: 5),
                CustomTextFormField(
                  maxLines: 5,
                  textInputType: TextInputType.text,
                  text: 'Were you responsible for something before explain?',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter Your Explanation';
                    }
                    return null;
                  },
                  save: (val) {
                    previousRes = val!;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                // SizedBox(
                //   width: double.infinity,
                //   height: 50,
                //   child: CustomButton(
                //     text: 'Submit',
                //     function: () {
                //       // _submit(userId, context);
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _submit(context);
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.check),
      ),
    );
  }
}
