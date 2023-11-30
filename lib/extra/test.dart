import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:difog/services/contract_service.dart';

import '../screens/add_asset.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AssetList(),
    );
  }
}

class AssetList extends StatefulWidget {
  @override
  _ContractListPageState createState() => _ContractListPageState();
}
class _ContractListPageState extends State<AssetList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Token List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddNewAssetScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ContractListView(),
    );
  }
}


class ContractListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
      future: ContractService().contractList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading contracts'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No contracts available'));
        } else {
          final contractData = snapshot.data!;

          return ListView.builder(
            itemCount: contractData.length,
            itemBuilder: (context, index) {
              final contractName = contractData.keys.toList()[index];
              final contractsList = contractData[contractName]!;

              return Column(
                children: [
                  ...contractsList.map((contractInfo) {
                    final contractAddress = contractInfo['address'] as String;
                    final symbol = contractInfo['symbol'] as String;
                    final showStatus = contractInfo['showStatus'] as bool;
                    final blockchainName = contractInfo['blockchain'] as String;
                    return ContractListItem(
                      contractName:contractName,
                      contractAddress: contractAddress,
                      symbol : symbol,
                      blockchainName: blockchainName,
                      showStatus: showStatus,
                    );
                  }).toList(),
                ],
              );
            },
          );
        }
      },
    );
  }
}

class ContractListItem extends StatefulWidget {
  final String contractName;
  final String contractAddress;
  final String symbol;
  final String blockchainName;
  final bool showStatus;

  ContractListItem({
    required this.contractName,
    required this.contractAddress,
    required this.symbol,
    required this.blockchainName,
    required this.showStatus,
  });

  @override
  _ContractListItemState createState() => _ContractListItemState();
}
class _ContractListItemState extends State<ContractListItem> {
  bool? _status; // You can start with it being null to know if it's set or not

  @override
  void initState() {
    super.initState();
    _status = widget.showStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.symbol),
            subtitle: Text(widget.blockchainName),
            trailing: Switch(
              value: _status!,
              onChanged: (newValue) async {
                setState(() {
                  _status = newValue;
                });

                // Update the status in the contract data
                await ContractService().updateContractStatus(
                  widget.contractName,
                  newValue,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}






