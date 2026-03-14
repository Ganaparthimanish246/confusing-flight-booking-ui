import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const WorstUIApp());
}

class WorstUIApp extends StatelessWidget {
  const WorstUIApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Confusing Flight Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.yellowAccent,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainLayout(),
        '/results': (context) => const FlightResultsPage(),
        '/payment': (context) => const PaymentPage(),
        '/confirmation': (context) => const ConfirmationPage(),
      },
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // Nav mapping to confuse user
  final List<Widget> _pages = [
    const BookingPage(),      // 0: label "Not Home" (icon home) -> Opens Booking
    const ConfusingProfilePage(),   // 1: label "Find Nothing" (icon search) -> Opens Profile
    const FlightSearchPage(), // 2: label "Maybe" (icon flight) -> Opens Search
    const HomePage(),         // 3: label "Who am I?" (icon person) -> Opens Home
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.pinkAccent,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.blueAccent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 45),
            label: 'Not Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 10),
            label: 'Find Nothing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket, size: 25),
            label: 'Maybe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 60),
            label: 'Who am I?',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final Random _rand = Random();

  final List<String> buttonLabels = [
    "Maybe Book", "Click If Lucky", "Not This Button", "Try Again",
    "Random Flight", "Secret Booking", "Do Not Click", "Where?",
    "Why?", "Go Back", "Next?", "Lost", "Proceed", "Cancel All",
    "Find", "Book", "Run", "Help", "Yes", "No",
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      body: Stack(
        children: [
          Center(
            child: RotationTransition(
              turns: _animController,
              child: const Text(
                'WELCOME TO USELESSNESS',
                style: TextStyle(fontSize: 80, fontWeight: FontWeight.w900, color: Colors.orange),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ...List.generate(25, (index) {
            double top = _rand.nextDouble() * MediaQuery.of(context).size.height * 0.9;
            double left = _rand.nextDouble() * MediaQuery.of(context).size.width * 0.9;
            double width = _rand.nextDouble() * 150 + 40;
            double height = _rand.nextDouble() * 100 + 30;
            Color color = Color((_rand.nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.9);
            
            return Positioned(
              top: top,
              left: left,
              child: InkWell(
                onTap: () {
                  if (index == 5) { // Secret Booking -> goes to Search vaguely
                    Navigator.pushReplacementNamed(context, '/'); // reload main
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Try another button', style: TextStyle(color: Colors.red)), backgroundColor: Colors.yellow),
                    );
                  }
                },
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(_rand.nextDouble() * 50),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    buttonLabels[index % buttonLabels.length],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: (index == 5) ? 6 : 14, // important one is tiny
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class FlightSearchPage extends StatefulWidget {
  const FlightSearchPage({Key? key}) : super(key: key);
  @override
  State<FlightSearchPage> createState() => _FlightSearchPageState();
}

class _FlightSearchPageState extends State<FlightSearchPage> {
  bool _showDropdown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      appBar: AppBar(title: const Text('Maybe Search?', style: TextStyle(color: Colors.black, fontSize: 8)), backgroundColor: Colors.green),
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            child: const Text('USELESS TEXT', style: TextStyle(fontSize: 90, color: Colors.grey)),
          ),
          ListView(
            padding: const EdgeInsets.all(50),
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Passengers? who knows',
                  fillColor: Colors.orange,
                  filled: true,
                ),
              ),
              const SizedBox(height: 100),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Date maybe?',
                  fillColor: Colors.blueAccent,
                  filled: true,
                ),
              ),
              const SizedBox(height: -20),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Where are you maybe going?',
                  fillColor: Colors.yellow,
                  filled: true,
                ),
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showDropdown = !_showDropdown;
                  });
                },
                child: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.all(20),
                  child: const Text('Destination (guess it)', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.all(2)),
                onPressed: () {
                  Navigator.pushNamed(context, '/results');
                },
                child: const Text('Don\'t Search', style: TextStyle(fontSize: 8, color: Colors.white)),
              ),
            ],
          ),
          if (_showDropdown)
            Positioned(
              top: 100, // opens behind elements because of stack order
              left: 50,
              child: Container(
                color: Colors.lightGreen,
                height: 200,
                width: 200,
                child: ListView(
                  children: [
                    ListTile(title: const Text('Nowhere'), onTap: () {}),
                    ListTile(title: const Text('Everywhere'), onTap: () {}),
                    ListTile(title: const Text('Somewhere'), onTap: () {}),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FlightResultsPage extends StatefulWidget {
  const FlightResultsPage({Key? key}) : super(key: key);
  @override
  State<FlightResultsPage> createState() => _FlightResultsPageState();
}

class _FlightResultsPageState extends State<FlightResultsPage> {
  Timer? _timer;
  final Random _rand = Random();
  Color _priceColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          _priceColor = Color((_rand.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(title: const Text('Results (Maybe)', style: TextStyle(fontSize: 40)), toolbarHeight: 100, backgroundColor: Colors.indigo),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 10,
            child: _buildFlightCard(1, 'Airlines...', '\$999?'),
          ),
          Positioned(
            top: 50,
            left: 40,
            child: _buildFlightCard(2, 'Oth.. Air', '\$4?'),
          ),
          Positioned(
            top: 30,
            left: 80,
            child: _buildFlightCard(3, 'Hihihihi', '\$10000000'),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/payment'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: const Text('Maybe Later', style: TextStyle(color: Colors.black)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFlightCard(int id, String airline, String price) {
    return Card(
      color: Colors.white70,
      elevation: 10,
      child: Container(
        width: 250,
        height: 150,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(airline, style: const TextStyle(fontSize: 6, color: Colors.transparent), selectionColor: Colors.black), // Name is invisible unless selected
            const SizedBox(height: 10),
            Text('Price: $price', style: TextStyle(color: _priceColor, fontSize: 30, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){}, child: const Text('Don\'t Book')),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to payment
                    Navigator.pushNamed(context, '/payment');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Book?', style: TextStyle(fontSize: 10)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  bool _isChecked = false;

  void _showRandomPopup() {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Are you sure you want to be unsure?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Yes')),
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('No')),
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Banana')),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime,
      appBar: AppBar(title: const Text('Not Booking'), backgroundColor: Colors.deepPurpleAccent),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('SOME USELESS TEXT THAT IS VERY LARGE', style: TextStyle(fontSize: 50, color: Colors.white), textAlign: TextAlign.center),
            CheckboxListTile(
              value: _isChecked,
              onChanged: (val) {
                setState(() => _isChecked = val!);
                if(Random().nextBool()) {
                  _showRandomPopup();
                }
              },
              title: const Text('I do not agree', style: TextStyle(fontSize: 10)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Cancel actually confirms booking -> goes to payment
                    Navigator.pushNamed(context, '/payment');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Cancel', style: TextStyle(fontSize: 20)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Confirm resets form
                    setState(() {
                      _isChecked = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Confirm', style: TextStyle(fontSize: 20)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat(); // Fake loading bar resetting repeatedly
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Payment Options', style: TextStyle(color: Colors.white, fontSize: 30)),
          const SizedBox(height: 50),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _progressController.value,
                backgroundColor: Colors.red,
                color: Colors.green,
                minHeight: 20,
              );
            },
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _payBtn('Pay Now Maybe', Colors.blue),
              _payBtn('Pay Later Possibly', Colors.orange),
              _payBtn('Pay Twice', Colors.purple),
              _payBtn('Random Payment', Colors.teal),
            ],
          )
        ],
      ),
    );
  }

  Widget _payBtn(String text, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.all(30)),
      onPressed: () {
        Navigator.pushNamed(context, '/confirmation');
      },
      child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.white)),
    );
  }
}

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Stack(
        children: [
          const Center(
            child: Text(
              'Your flight might be booked… or maybe not.\nTry clicking random buttons to find out.',
              style: TextStyle(fontSize: 12, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(top: 100, left: 10, child: const Text('Conf #1: 72A9X0', style: TextStyle(fontSize: 40))),
          Positioned(bottom: 100, right: 30, child: const Text('Conf #2: 999999', style: TextStyle(fontSize: 30, color: Colors.yellow))),
          Positioned(
            bottom: 50,
            left: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('Where am I?', style: TextStyle(color: Colors.white)),
            ),
          ),
          Positioned(
            top: 200,
            right: 50,
            child: IconButton(
              icon: const Icon(Icons.print, size: 80, color: Colors.green),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class ConfusingProfilePage extends StatelessWidget {
  const ConfusingProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_off, size: 200, color: Colors.red),
            const Text('Who is this?', style: TextStyle(fontSize: 50)),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nothing happened.')));
              },
              child: const Text('Edit Profile'),
            )
          ],
        ),
      ),
    );
  }
}
