import 'package:example/pages/borders_widget.dart';
import 'package:flutter/material.dart';
import 'package:followind/followind.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Followind(
      child: MaterialApp(
        title: 'Followind Example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MyHomePage(title: 'Followind Home Page'),
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
      body: Box(
        styles: bySizeClass(
          base: [col, mainMax, crossStretch, 8.p],
          xl: [row, 8.spacing],
          // xxl: [16.m],
        ),
        children: [
          Box(
            styles: bySizeClass(
              base: [
                expanded,
                col,
                mainCenter,
                2.gap,
                8.p,
                if (_counter > 5) 200.red.bg else 200.blue.bg,
                16.rounded,
                1.border,
                400.slate.border,
              ],
              // sm: [10.p, 6.gap],
              // md: [12.p],
              // lg: [16.p],
              xl: [20.p, 800.red.border],
              // xxl: [24.p],
            ),
            children: [
              Box(
                styles: bySizeClass(
                  base: [
                    alignCenter,
                    row,
                    mainMin,
                    crossCenter,
                    3.gap,
                    4.p,
                    16.rounded,
                    800.purple.bg,
                    200.gray.border,
                    400.purple.border.hover,
                    8.border,
                    200.slate.text,
                  ],
                  lg: [8.px, 4.py, 100.rounded],
                  xxl: [4.border, 200.red.border, 800.red.border.hover],
                ),
                onPressed: _goToBordersPage,
                children: [Text("Go to Borders"), Icon(Icons.arrow_forward)],
              ),
              Box(styles: [alignCenter], children: [Text("Test")]),
              Box(
                styles: [
                  4.px,
                  2.py,
                  16.rounded,
                  400.slate.border,
                  800.red.border.hover,
                  25.percent.width,
                ],
                children: [Text("This is some really long text")],
              ),
              Text("Test"),
              Box(
                // classNames: [
                //   "p-4 bg-red-200 gap-4",
                //   "border",
                //   "rounded-md rounded-tl-3xl rounded-br-3xl",
                //   "md:rounded-md md:rounded-bl-3xl md:rounded-tr-3xl",
                // ],
                children: [
                  const Text('You have pushed the button this many times:'),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              Box(
                // classNames: [
                //   "px-6 py-4 bg-red-400 gap-4",
                //   "border-x-2 border-y-4 border-r-8",
                //   "border-t-red-300 border-r-orange-400",
                //   "border-b-yellow-400 border-l-green-400"
                // ],
                children: [
                  const Text('You have pushed the button this many times:'),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              Box(
                // classNames: [
                //   'bg-orange-200 rounded',
                // ],
                styles: [
                  4.py,
                  8.px,
                  16.rounded,
                  400.slate.border,
                  800.red.border.hover,
                ],
                children: [Text("This is a single child.")],
              ),
            ],
          ),
          Expanded(
            child: Container(
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
                      child: Row(children: [Text("Go to Borders")]),
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
