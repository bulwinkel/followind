import 'package:flutter/material.dart';
import 'package:following_wind/following_wind.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FollowingWind Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'FollowingWind Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Box(
        className: "h-full m-4 main-center gap-10 py-10 bg-green-100",
        children: [
          Box(
            className: "col main-center gap-4 p-20 bg-blue-200",
            children: [
              Box(
                className: [
                  "p-4 bg-red-200 gap-4",
                  "border",
                  "rounded-md rounded-tl-3xl rounded-br-3xl",
                ].joined,
                children: [
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              Box(
                className: [
                  "p-4 bg-red-200 gap-4",
                  "border-x-2 border-y-4 border-t-red-300 border-r-orange-400 border-b-yellow-400 border-l-green-400 border-r-0",
                ].joined,
                children: [
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ],
          ),
          Container(
            color: colors['blue']?[200],
            height: double.infinity,
            padding: const EdgeInsets.all(20 * 4),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: colors['red']?[200],
                  border: Border(
                    top: BorderSide(
                      color: colors['red']![400]!,
                      style: BorderStyle.solid,
                      width: 1,
                    ),
                    right: BorderSide(
                      color: colors['orange']![400]!,
                      width: 2,
                    ),
                    bottom: BorderSide(
                      color: colors['yellow']![400]!,
                      width: 3,
                    ),
                    left: BorderSide(
                      color: colors['green']![400]!,
                      width: 4,
                    ),
                  ),
                  // borderRadius: const BorderRadius.only(
                  //   topLeft: Radius.circular(24),
                  //   topRight: Radius.circular(6),
                  //   bottomRight: Radius.circular(24),
                  //   bottomLeft: Radius.circular(6),
                  // ),
                ),
                padding: const EdgeInsets.all(4 * 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'You have pushed the button this many times:',
                    ),
                    const SizedBox(width: 4 * 4),
                    Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
