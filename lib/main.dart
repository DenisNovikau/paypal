import 'package:flutter/material.dart';
import 'PaypalPayment.dart';

void main() {
  runApp(const MaterialApp(home: App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Paypal Payment Example')),
        body: Center(
            child: ElevatedButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => PaypalPayment())),
          child: const Text('Pay with Paypal'),
        )));
  }
}
