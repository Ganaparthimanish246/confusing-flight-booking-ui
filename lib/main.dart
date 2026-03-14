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
      title: 'Premium Flights',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainLayout(),
        '/search_maybe': (context) => const FlightSearchPage(),
        '/results': (context) => const FlightResultsPage(),
        '/booking': (context) => const BookingPage(),
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

  // Navigation looks clean, but routing is mismatched!
  final List<Widget> _pages = [
    const BookingPage(),      // 0: Tab is "Home" but goes to Booking
    const ProfilePage(),      // 1: Tab is "Search" but goes to Profile
    const HomePage(),         // 2: Tab is "Profile" but goes to Home
    const FlightSearchPage(), // 3: Tab is "Menu" but goes to Confusing Search
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
        selectedItemColor: const Color(0xFF1E88E5),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Not Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Find Nothing'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Who am I?'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Maybe'),
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

class _HomePageState extends State<HomePage> {
  bool _isConfused = false;
  final Random _rand = Random();

  final List<String> buttonLabels = [
    "Maybe Book", "Click If Lucky", "Not This Button", "Try Again",
    "Random Flight", "Secret Booking", "Do Not Click", "Where?",
    "Why?", "Go Back", "Next?", "Lost", "Proceed", "Cancel All",
    "Find", "Book", "Run", "Help", "Yes", "No",
  ];

  @override
  Widget build(BuildContext context) {
    if (_isConfused) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const Center(
              child: Text(
                'Wait, what did you click?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            ...List.generate(25, (index) {
              double top = _rand.nextDouble() * MediaQuery.of(context).size.height * 0.85;
              double left = _rand.nextDouble() * MediaQuery.of(context).size.width * 0.8;
              double width = _rand.nextDouble() * 120 + 60;
              double height = _rand.nextDouble() * 40 + 30;
              Color color = Color((_rand.nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.9);
              
              return Positioned(
                top: top,
                left: left,
                child: InkWell(
                  onTap: () {
                    if (index == 5) { // Secret Booking goes forward
                      Navigator.pushNamed(context, '/search_maybe');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nope, try another button!')),
                      );
                      setState(() {}); // Reshuffle positions
                    }
                  },
                  child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      buttonLabels[index % buttonLabels.length],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Next Flight', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Where are you traveling to?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Column(
                children: [
                  const TextField(decoration: InputDecoration(labelText: 'From', prefixIcon: Icon(Icons.flight_takeoff))),
                  const SizedBox(height: 16),
                  const TextField(decoration: InputDecoration(labelText: 'To', prefixIcon: Icon(Icons.flight_land))),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Expanded(child: TextField(decoration: InputDecoration(labelText: 'Departure', prefixIcon: Icon(Icons.calendar_today)))),
                      SizedBox(width: 16),
                      Expanded(child: TextField(decoration: InputDecoration(labelText: 'Return', prefixIcon: Icon(Icons.calendar_today)))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        // User thinks they are searching, but boom, confusion begins!
                        setState(() { _isConfused = true; });
                      },
                      child: const Text('Search Flights', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
      appBar: AppBar(title: const Text('Advanced Search'), backgroundColor: Colors.white, elevation: 1),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const TextField(decoration: InputDecoration(labelText: 'Passengers? who knows', border: OutlineInputBorder())),
              const SizedBox(height: 20),
              const TextField(decoration: InputDecoration(labelText: 'Date maybe?', border: OutlineInputBorder())),
              const SizedBox(height: 20),
              const TextField(decoration: InputDecoration(labelText: 'Where are you maybe going?', border: OutlineInputBorder())),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() => _showDropdown = !_showDropdown);
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  child: const Text('Destination (guess it)', style: TextStyle(fontSize: 16, color: Colors.black87)),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(16)),
                onPressed: () => Navigator.pushNamed(context, '/results'),
                child: const Text('Search Now', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
          if (_showDropdown)
            Positioned(
              top: 150, // Dropdown opens behind UI elements!
              left: 20,
              right: 20,
              child: Material(
                elevation: 4,
                child: Container(
                  color: Colors.white,
                  height: 150,
                  child: ListView(
                    children: [
                      ListTile(title: const Text('Nowhere'), onTap: () => setState(()=> _showDropdown = false)),
                      ListTile(title: const Text('Everywhere'), onTap: () => setState(()=> _showDropdown = false)),
                      ListTile(title: const Text('Somewhere'), onTap: () => setState(()=> _showDropdown = false)),
                    ],
                  ),
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
      appBar: AppBar(title: const Text('Flight Results'), backgroundColor: Colors.white, elevation: 1),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFlightCard('Airlines...', '\$999?'),
          _buildFlightCard('Oth.. Air', '\$4?'),
          _buildFlightCard('HiddenAir', '\$10000000'),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/payment'),
              child: const Text('Maybe Later', style: TextStyle(color: Colors.grey)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFlightCard(String airline, String price) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(airline, style: const TextStyle(fontSize: 16, color: Colors.transparent), selectionColor: Colors.black), // Airline hidden unless selected
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Price: $price', style: TextStyle(color: _priceColor, fontSize: 24, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () {
                    // Dodging button behavior!
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Oops, you missed it!')));
                    Navigator.pushNamed(context, '/booking');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E88E5)),
                  child: const Text('Book?', style: TextStyle(color: Colors.white)),
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
  bool _isChecked = true;
  final _formKey = GlobalKey<FormState>();

  void _showRandomPopup() {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Are you sure you want to be unsure?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Yes')),
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('No')),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Booking'), backgroundColor: Colors.white, elevation: 1),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextFormField(decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _isChecked,
                onChanged: (val) {
                  setState(() => _isChecked = val!);
                  if(Random().nextBool()) {
                    _showRandomPopup();
                  }
                },
                title: const Text('I agree to the Terms and Conditions (Maybe)'),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        side: const BorderSide(color: Colors.red),
                      ),
                      onPressed: () {
                        // "Confirm" actually resets the form
                        _formKey.currentState?.reset();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Form Reset!')));
                      },
                      child: const Text('Confirm', style: TextStyle(color: Colors.red, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(16)),
                      onPressed: () {
                        // "Cancel" actually proceeds!
                        Navigator.pushNamed(context, '/payment');
                      },
                      child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
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
    _progressController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment'), backgroundColor: Colors.white, elevation: 1),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Processing Payment...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                return LinearProgressIndicator(value: _progressController.value);
              },
            ),
            const SizedBox(height: 40),
            const Text('Select Payment Method', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Pay Now Maybe'),
              leading: Radio(value: 1, groupValue: 0, onChanged: (val){ Navigator.pushNamed(context, '/confirmation'); }),
            ),
            ListTile(
              title: const Text('Pay Later Possibly'),
              leading: Radio(value: 2, groupValue: 0, onChanged: (val){ Navigator.pushNamed(context, '/confirmation'); }),
            ),
            ListTile(
              title: const Text('Pay Twice'),
              leading: Radio(value: 3, groupValue: 0, onChanged: (val){ Navigator.pushNamed(context, '/confirmation'); }),
            ),
            ListTile(
              title: const Text('Random Payment'),
              leading: Radio(value: 4, groupValue: 0, onChanged: (val){ Navigator.pushNamed(context, '/confirmation'); }),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'Your flight might be booked… or maybe not.\nTry clicking random buttons to find out.',
              style: TextStyle(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: const [
                  Text('Confirmation #1: 72A9X0', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Confirmation #2: 999999', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E88E5), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              child: const Text('Where am I?', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), backgroundColor: Colors.white, elevation: 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 100, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Who is this?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile locked.')));
              },
              child: const Text('Edit Profile'),
            )
          ],
        ),
      ),
    );
  }
}
