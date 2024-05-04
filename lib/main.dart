import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezos_statz/data/datasources/local_storage.dart';
import 'package:tezos_statz/data/datasources/remote_datasource.dart';
import 'package:tezos_statz/data/repositories/address_repository_impl.dart';
import 'package:tezos_statz/data/repositories/balance_repository_impl.dart';
import 'package:tezos_statz/data/repositories/transaction_repository_impl.dart';
import 'package:tezos_statz/domain/usecases/retrieve_address.dart';
import 'package:tezos_statz/domain/usecases/retrieve_balance.dart';
import 'package:tezos_statz/domain/usecases/retrieve_transactions.dart';
import 'package:tezos_statz/domain/usecases/store_address.dart';
import 'package:http/http.dart' as http;

import 'ui/screens/about.dart';
import 'ui/screens/address_screen.dart';
import 'ui/screens/balance_screen.dart';
import 'ui/screens/transactions_screen.dart';
import 'ui/state/address_notifier.dart';
import 'ui/state/balance_notifier.dart';
import 'ui/state/transactions_notifier.dart';

late SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if an address has been previously stored, start with the balance screen else with the address screen
  prefs = await SharedPreferences.getInstance();
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
  late RemoteDataSource _remoteDataSource;
  late LocalStorage _localStorage;

  static List<String> _titles = <String>[
    'Tezos Address',
    'Balance',
    'Transactions',
    'About Tezos Statz Demo',
  ];

  static List<Widget> _screens = <Widget>[
    AddressScreen(),
    BalanceScreen(),
    TransactionsScreen(),
    AboutScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _screenIndex = widget.startScreenIndex;
    _remoteDataSource = RemoteDataSource(client: http.Client());
    _localStorage = LocalStorage(storage: prefs, key: "tzaddress");
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final addressRepositoryImpl =
                AddressRepositoryImpl(storage: _localStorage);
            return AddressNotifier(
              storeAddressUsecase:
                  StoreAddressUsecase(repository: addressRepositoryImpl),
              retrieveAddressUsecase:
                  RetrieveAddressUsecase(repository: addressRepositoryImpl),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) => BalanceNotifier(
            usecase: RetrieveBalanceUsecase(
              repository: BalanceRepositoryImpl(datasource: _remoteDataSource),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => TransactionsNotifier(
            usecase: RetrieveTransactionsUsecase(
              repository:
                  TransactionsRepositoryImpl(datasource: _remoteDataSource),
            ),
          ),
        ),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
