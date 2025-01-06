import 'package:example/pages/borders_widget.dart';
import 'package:flutter/material.dart';
import 'package:following_wind/following_wind.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FollowingWind(
      child: MaterialApp(
        title: 'FollowingWind Example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MyHomePage(title: 'FollowingWind Home Page'),
      ),
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

  void _goToBordersPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BordersPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Box(
          classNames: [
            "col xl:row main-max gap-4 xl:gap-8",
            "border border-green-400 rounded-xl",
            "py-10",
            "m-4 sm:m-6 md:m-8 lg:m-10 xl:m-12 2xl:m-16",
            // "bg-green-100 sm:bg-red-400 md:bg-orange-400 lg:bg-yellow-400 xl:bg-blue-400 2xl:bg-purple-400",
            // if (_counter > 5) "bg-red-800",
          ],
          children: [
            Box(
              classNames: [
                "col main-center gap-2 sm:gap-6",
                "p-8 sm:p-10 md:p-12 lg:p-16 xl:p-20 2xl:p-24",
                // "h-10/12 w-1/2",
                if (_counter > 5) "bg-red-200" else "bg-blue-200",
              ],
              children: [
                Box(
                  classNames: [
                    "p-4 lg:px-8 lg:py-4 rounded-xl gap-3",
                    "text-4xl text-white",
                    // "my-8",
                    "sm:h-40 sm:w-60 md:h-60 md:w-80",
                    "bg-purple-400 sm:bg-red-400 md:bg-orange-400 lg:bg-yellow-400 xl:bg-blue-400",
                    // "sm:size-1/5 md:size-2/5 lg:size-3/5",
                  ],
                  onPressed: _goToBordersPage,
                  children: [
                    Text("Go to Borders"),
                    Icon(Icons.arrow_forward),
                  ],
                ),
                Text("Test"),
                Box(
                  classNames: [
                    "bg-slate-200 p-8 py-10 text-3xl",
                    "rounded sm:rounded-sm md:rounded-md lg:rounded-lg xl:rounded-xl 2xl:rounded-2xl",
                    // "main-center"
                    // "h-52",
                  ],
                  children: [
                    Text("This is some really long text"),
                  ],
                ),
                Text("Test"),
                Box(
                  classNames: [
                    "p-4 bg-red-200 gap-4",
                    "border",
                    "rounded-md rounded-tl-3xl rounded-br-3xl",
                    "md:rounded-md md:rounded-bl-3xl md:rounded-tr-3xl",
                  ],
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
                  classNames: [
                    "px-6 py-4 bg-red-400 gap-4",
                    "border-x-2 border-y-4 border-r-8",
                    "border-t-red-300 border-r-orange-400",
                    "border-b-yellow-400 border-l-green-400"
                  ],
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
                  classNames: [
                    'p-4 bg-orange-200 rounded',
                  ],
                  children: [
                    Text("This is a single child."),
                  ],
                ),
              ],
            ),
            Container(
              color: colors['blue']?[200],
              padding: const EdgeInsets.all(20 * 4),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colors['blue']?[800],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: DefaultTextStyle(
                      style: const TextStyle(color: Colors.white),
                      child: Row(
                        children: [
                          Text("Go to Borders"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
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
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
