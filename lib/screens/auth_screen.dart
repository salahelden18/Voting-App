import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../helpers/http_exception.dart';
import '../provider/auth_provider.dart';
import '../widgets/custom_text_from_field.dart';
import '../widgets/custome_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String _email = '';
  String _password = '';
  String _department = 'software engineering';
  String _name = '';

  List<String> items = [
    'software engineering',
    'computer engineering',
    'electric engineering'
  ];

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    _formKey.currentState!.save();
    try {
      if (_isLogin) {
        await Provider.of<AuthProvider>(context, listen: false)
            .login(_email, _password);
        _showSnackBar('Logged in sucessfully', Colors.green);
        // ignore: use_build_context_synchronously
        // Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
      } else {
        await Provider.of<AuthProvider>(context, listen: false)
            .signup(_name, _department, _email, _password);
        _showSnackBar('user Created Successully', Colors.green);
        // ignore: use_build_context_synchronously
        // Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
      }
    } on HttpException catch (e) {
      _showSnackBar(e.message, Colors.red);
    } catch (e) {
      print(e);
      _showSnackBar(
          'Could not authenticate you, please try agian later', Colors.red);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to our Uskudar university voting app',
                    style: Theme.of(context).textTheme.headline6,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 15),
                  if (!_isLogin)
                    CustomTextFormField(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: primaryColor,
                      ),
                      text: 'Name',
                      validator: (val) {
                        if (val!.isEmpty) return 'Please Enter Your Name';
                        return null;
                      },
                      save: (val) {
                        _name = val!;
                      },
                    ),
                  SizedBox(height: _isLogin ? 0 : 10),
                  if (!_isLogin)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xffECEDF1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        items: items.map(buildMenuItem).toList(),
                        value: _department,
                        isExpanded: true,
                        iconSize: 36,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        onChanged: (val) {
                          setState(() {
                            _department = val!;
                          });
                        },
                      ),
                    ),
                  SizedBox(height: _isLogin ? 0 : 10),
                  CustomTextFormField(
                    prefixIcon: const Icon(
                      Icons.email,
                      color: primaryColor,
                    ),
                    text: 'Email',
                    textInputType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please Enter Your Email';
                      }
                      RegExp regExp = RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                      bool match = regExp.hasMatch(val);
                      if (!match) {
                        return 'Please Enter A Valid Email';
                      }
                      return null;
                    },
                    save: (val) {
                      _email = val!;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: primaryColor,
                    ),
                    text: 'Password',
                    isPassword: true,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please Enter Your Password';
                      } else if (val.length < 7) {
                        return 'Your Password Should At Least Be 8 characters';
                      }
                      return null;
                    },
                    save: (val) {
                      _password = val!;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_isLogin
                          ? 'Don\'t have an accout?'
                          : 'Already have an account?'),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin ? 'Sign Up' : 'Login'),
                      ),
                    ],
                  ),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: _isLogin ? 'Login' : 'Sign Up',
                        function: _submit,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontSize: 20, color: primaryColor),
        ),
      );
}
