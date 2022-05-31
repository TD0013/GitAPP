import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'viewModel.dart';
import 'model.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    final value = ref.read(notProvider.notifier);
    value.getBgData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Page",
          textAlign: TextAlign.center,
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final st = ref.watch(notProvider);
          // print(st);
          if (st is LoadingState) {
            return loading();
          } else if (st is HomeNoDataState) {
            return homeNoData(context);
          } else if (st is HomeWithUser) {
            return homeUser(context);
          } else {
            return errorScreen();
          }
        },
      ),
    );
  }
}

Widget loading() {
  return const SafeArea(
      child: Scaffold(body: Center(child: CircularProgressIndicator())));
}

Widget homeNoData(context) {
  return SizedBox.expand(
      child: Container(
    // Image.network(),
    decoration: BoxDecoration(
        image:
            DecorationImage(image: NetworkImage(bgImg!.url), fit: BoxFit.fill)),
    child: Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.all(80.0),
                            child: Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        TextSpan(
                                            text: bgImg!.title + "\n",
                                            style: const TextStyle(
                                                fontSize: 30,
                                                color: Colors.white)),
                                        TextSpan(
                                            text: bgImg!.explanation,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white))
                                      ]),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  icon: const Icon(Icons.info)),
            ),
          ),
        ),
        Center(
          child: ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      final myController = TextEditingController();
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: AlertDialog(
                          content: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.cancel_outlined)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 40),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: myController,
                                      decoration: const InputDecoration(
                                        labelText: "Enter UserName",
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Consumer(builder: (context, ref, child) {
                                      final st = ref.read(notProvider.notifier);
                                      return ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            st.searchUser(myController.text);
                                          },
                                          child: const Text("Search"));
                                    })
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: const Text("Search For user")),
        )
      ],
    ),
  ));
}

Widget homeUser(context) {
  // final screenWidth = MediaQuery.of(context).size;
  // print(screenWidth.height);
  return Container(
    child: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Image(image: NetworkImage(currUser!.avatarUrl)),
                SizedBox(
                  height: 300,
                  width: 300,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(currUser!.avatarUrl),
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Text(currUser!.login),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text("Followers"),
          SizedBox(
            height: 170,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: ScrollController(),
                  scrollDirection: Axis.horizontal,
                  itemCount: currUser!.followers.length,
                  itemBuilder: (context, index) {
                    // return Text(currUser!.followers[index].login);
                    return followerDisplay(currUser!.followers[index], context);
                  }),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text("Repos"),
          SizedBox(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: ScrollController(),
                  scrollDirection: Axis.horizontal,
                  itemCount: currUser!.repos.length,
                  itemBuilder: (context, index) {
                    // return Text(currUser!.followers[index].login);
                    return repoDisplay(currUser!.repos[index]);
                  }),
            ),
          )
        ],
      ),
    ),
  );
}

Widget errorScreen() {
  return const SafeArea(
      child: Scaffold(body: Center(child: Text("Something Went Wrong..."))));
}

Widget followerDisplay(User temp, context) {
  return Consumer(builder: (context, ref, child) {
    final st = ref.read(notProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          st.searchUser(temp.login);
        },
        child: Column(
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: CircleAvatar(
                backgroundImage: NetworkImage(temp.avatarUrl),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(temp.login)
          ],
        ),
      ),
    );
  });
}

Widget repoDisplay(Repos rep) {
  return Card(
    color: rep.private ? Colors.red : Colors.green,
    child: Padding(padding: const EdgeInsets.all(10.0), child: Text(rep.name)),
  );
  // return Padding(padding: const EdgeInsets.all(10.0), child: Text(rep.name));
}
