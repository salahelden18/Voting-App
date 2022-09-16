import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/home_provider.dart';
import '../widgets/candidateItem.dart';
import '../widgets/floating_button.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List> candidateList;

  var _isInit = true;
  Future<List> getCandidateList() {
    return Provider.of<HomeProvider>(context, listen: false).getCanidateList();
  }

  // @override
  // void initState() {
  //   candidateList = getCandidateList();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      candidateList = getCandidateList();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'List Of Candidates',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                  future: candidateList,
                  builder: (ctx, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return snapshot.data!.isEmpty
                          ? Center(
                              child: Text(
                                'No Candidates yet be the first one',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: snapshot.data?.length,
                                itemBuilder: (ctx, index) => CandidateItem(
                                    snapshot: snapshot, index: index),
                              ),
                            );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: const CustomFloatingActionButton());
  }
}
    
    // return FutureBuilder(
    //   future: Provider.of<HomeProvider>(context, listen: false).getUserData(),
    //   builder: (ctx, AsyncSnapshot<Map<String, dynamic>> snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     } else {
    //       return SafeArea(
    //         child: Padding(
    //           padding: const EdgeInsets.all(10.0),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 snapshot.data!['name'],
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .headline6!
    //                     .copyWith(fontSize: 30),
    //               ),
    //               const SizedBox(
    //                 height: 5,
    //               ),
    //               Text(snapshot.data!['department']),
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               Text(
    //                 'List Of Candidates',
    //                 style: Theme.of(context).textTheme.headline6,
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     }
    //   },
    // );
  
