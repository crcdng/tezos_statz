import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezos_statz/screens/about.dart';
import 'package:tezos_statz/screens/address.dart';
import 'package:tezos_statz/screens/balance.dart';
import 'package:tezos_statz/screens/transfers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final startScreenIndex = prefs.containsKey("tzaddress") ? 1 : 0;
  runApp(TzStatzApp(startScreenIndex));
}

class TzStatzApp extends StatefulWidget {
  final startScreenIndex;

  TzStatzApp(this.startScreenIndex);

  @override
  _TzStatzAppState createState() => _TzStatzAppState();
}

class _TzStatzAppState extends State<TzStatzApp> {
  late int _screenIndex;

  static List<String> _titles = <String>[
    'Tezos Address',
    'Balance',
    'Transactions',
    'About Tezos Statz Demo',
  ];

  static List<Widget> _screens = <Widget>[
    AddressScreen(),
    BalanceScreen(),
    TransfersScreen(),
    AboutScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _screenIndex = widget.startScreenIndex;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TzStatz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Color.fromRGBO(4, 5, 46, 1.0),
        canvasColor: Color.fromRGBO(4, 5, 46, 1.0),
      ),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(_titles.elementAt(_screenIndex)),
            shadowColor: Colors.deepOrange,
            backgroundColor: Color.fromRGBO(46, 46, 46, 1.0),
          ),
          body: PageTransitionSwitcher(
              duration: Duration(milliseconds: 625),
              transitionBuilder: (Widget child, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return FadeThroughTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child);
              },
              child: _screens.elementAt(_screenIndex)),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.deepOrange,
            unselectedItemColor: Color.fromRGBO(251, 255, 249, 1.0),
            currentIndex: _screenIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.code),
                label: 'Address',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.money),
                label: 'Balance',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Transfers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'About',
              )
            ],
            onTap: (newIndex) {
              setState(() {
                _screenIndex = newIndex;
              });
            },
          ),
        ),
      ),
    );
  }
}
