import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import '../utils/app_config.dart';
import '../utils/blockchains.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../services/blockchain_service.dart';
class TransactionItem extends StatelessWidget {
  final String date;
  final String hash;
  final String to;
  final String from;
  final String amount;
  final String address;

  const TransactionItem({
    required this.date,
    required this.hash,
    required this.to,
    required this.from,
    required this.amount,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final bool isReceived = to.toLowerCase() == address.toLowerCase();
    final IconData icon = isReceived ? Icons.arrow_downward : Icons.arrow_upward;
    final String transferText = isReceived ? 'Received' : 'Transfer';

    //print(to);
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isReceived ? Colors.green : Colors.red,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  transferText,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  isReceived ? from : to,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isReceived ? Colors.green : Colors.red,
            ),
            textAlign: TextAlign.right, // Align the text to the right
          ),
        ],
      ),
    );
  }
}

class TransactionsList extends StatelessWidget {
  final List<MyTransaction> transactions;
  final String address;

  const TransactionsList({required this.transactions, required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppConfig.titleIconAndTextColor, //change your color here
        ),
        backgroundColor: AppConfig.titleBarColor,

        elevation: 0,
        automaticallyImplyLeading: true,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [

              Text("Transactions",
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            MyTransaction transaction = transactions[index];
            int timestamp = transaction.timeStamp;

            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
            String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
            String formattedTime = DateFormat('HH:mm:ss').format(dateTime);
            EtherAmount valueInEther = EtherAmount.inWei(transaction.value);
            double valueInEtherDouble = valueInEther.getValueInUnit(EtherUnit.ether);
            return TransactionItem(
              address: address,
              date: formattedDate + ' ' + formattedTime,
              hash: transaction.hash,
              from: transaction.from,
              to: transaction.to,
              amount: valueInEtherDouble.toString(),
            );
          },
        ),
      ),
    );
  }
}




