import 'package:flutter/material.dart';
import 'package:difog/services/contract_service.dart';
import 'package:difog/utils/card_design.dart';
import '../utils/app_config.dart';
import 'add_asset.dart';


class AssetList extends StatefulWidget {
  @override
  _ContractListPageState createState() => _ContractListPageState();
}
class _ContractListPageState extends State<AssetList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

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


              Text("Token List",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: AppConfig.titleIconAndTextColor,
                ),
              ),
            ],
          ),

        ),
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
    return Container(
      decoration: decoration,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.symbol, style: TextStyle(fontSize: 14.0)),
            subtitle: Text(widget.blockchainName, style: TextStyle(fontSize: 14.0)),
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
