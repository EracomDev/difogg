import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/app_config.dart';
import 'app_layout.dart';

class Cryptocurrency {
  final String name;
  final double price;
  final double volume;
  final double changePercentage;
  final bool isUp;

  Cryptocurrency({
    required this.name,
    required this.price,
    required this.volume,
    required this.changePercentage,
    required this.isUp,
  });
}

class CryptocurrencyCard extends StatelessWidget {
  final Cryptocurrency cryptocurrency;

  const CryptocurrencyCard({required this.cryptocurrency});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cryptocurrency.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'Volume: ',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${cryptocurrency.volume.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${cryptocurrency.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${cryptocurrency.changePercentage.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 14,
                        color: cryptocurrency.isUp ? Colors.green : Colors.red,
                      ),
                    ),
                    Icon(
                      cryptocurrency.isUp
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: cryptocurrency.isUp ? Colors.green : Colors.red,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LiveRatesPage extends StatefulWidget {
  @override
  _LiveRatesPageState createState() => _LiveRatesPageState();
}

class _LiveRatesPageState extends State<LiveRatesPage> {
  List<Cryptocurrency> cryptocurrencies = [];

  Future<void> fetchRates() async {
    final response = await http.get(
      Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        cryptocurrencies = data.map((coin) {
          return Cryptocurrency(
            name: coin['name'],
            price: coin['current_price'].toDouble(),
            volume: coin['total_volume'].toDouble(),
            changePercentage: coin['price_change_percentage_24h'].toDouble(),
            isUp: coin['price_change_percentage_24h'] >= 0,
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to fetch rates');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRates();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppConfig.titleIconAndTextColor, //change your color here
          ),
          backgroundColor: AppConfig.titleBarColor,

          //systemOverlayStyle:SystemUiOverlayStyle(statusBarColor: MyColors.secondaryColor,statusBarBrightness: Brightness.light,statusBarIconBrightness: Brightness.light),

          elevation: 0,

          automaticallyImplyLeading: true,
          //brightness: Brightness.light,

          //brightness: Brightness.light,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  "Market",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: AppConfig.titleIconAndTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var cryptocurrency in cryptocurrencies)
                  CryptocurrencyCard(cryptocurrency: cryptocurrency),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
