import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './constants/colors.dart';
import './provider/auth_provider.dart';
import './provider/home_provider.dart';
import './screens/auth_screen.dart';
import './screens/candidate_info_screen.dart';
import './screens/candidate_screen.dart';
import './screens/home_screen.dart';
import './screens/splash_screen.dart';
import './screens/tabs_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final prefs = await SharedPreferences.getInstance();
  // String? token = prefs.getString('token');

  runApp(const MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => HomeProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Voting App',
          theme: ThemeData(
            primaryColor: primaryColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            buttonTheme: const ButtonThemeData(
              buttonColor: primaryColor,
              minWidth: double.infinity,
              height: 50,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
                fixedSize: const Size(500, 45),
                textStyle: Theme.of(context).textTheme.headline6,
              ),
            ),
            textTheme: TextTheme(
              headline6: Theme.of(context).textTheme.headline6?.copyWith(
                    fontSize: 20,
                    color: primaryColor,
                  ),
            ),
          ),
          home: auth.isAuth
              ? const TabsScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          // home: token == null ? const AuthScreen() : const TabsScreen(),
          routes: {
            HomeScreen.routeName: (ctx) => const HomeScreen(),
            TabsScreen.routeName: (ctx) => const TabsScreen(),
            CandidateScreen.routeName: (ctx) => CandidateScreen(),
            CandidateInfoScreen.routeName: (ctx) => const CandidateInfoScreen(),
          },
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (ctx) => const AuthScreen(),
          ),
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (ctx) => const AuthScreen(),
          ),
        ),
      ),
    );
  }
}
