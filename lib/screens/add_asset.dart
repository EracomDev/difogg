import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../services/blockchain_service.dart';
import '../services/contract_service.dart';
import '../utils/app_config.dart';
import '../utils/blockchains.dart'; // Import the contract service

class AddNewAssetScreen extends StatefulWidget {
  @override
  _AddNewAssetScreenState createState() => _AddNewAssetScreenState();
}

class _AddNewAssetScreenState extends State<AddNewAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _internalNameController = TextEditingController();
  final TextEditingController _contractAbiController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _decimalController = TextEditingController();
  String _contractAbi = '';
  String _selectedBlockchain = 'bscMainnet'; // Default selected blockchain is BSC

  void _saveNewAsset() async {
    if (_formKey.currentState!.validate()) {
      String abiData = _contractAbi;
      String assetName = _internalNameController.text.trim();
      String C_address = _addressController.text;
      bool success = await ContractService().saveAbiToFile(C_address, abiData);
      String getInternalName(String C_address) {
        switch (C_address) {
          case 'binancecoin':
            return 'binancecoin';
          case 'matic-network':
            return 'matic-network';
          case '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56':
            return 'binance-usd';
          case '0x55d398326f99059fF775485246999027B3197955':
          case '0x325a4deFFd64C92CF627Dd72d118f1b8361c5691':
            return 'tether';
          case '0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063':
            return 'dai';
          case 'ethereum':
            return 'ethereum';
          case 'polygon':
            return 'polygon';
          default:
            return 'default';
        }
      }
      String inernalName = getInternalName(C_address);
      if (success) {
        Map<String, dynamic> newContract = {
          'internalName': inernalName,
          'symbol': assetName,
          'type': 'token',
          'contractAbi': '', //no need get it from Files
          'address': _addressController.text,
          'blockchain': _selectedBlockchain,
          'currency': '\$',
          'showStatus': true,
          'isToken': true
        };
        await ContractService().addContract(
            C_address, newContract);
        // Show a success message using a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Asset added successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _addressController.addListener(_getAssetDetails);
    _getAssetDetails();
  }

  void _getAssetDetails() async {
    String contractAddress = _addressController.text;
    if (contractAddress.isNotEmpty) {
      try {
        ContractDetails contractDetails = await getContractDetails(contractAddress, _selectedBlockchain);
        setState(() {
          _internalNameController.text = contractDetails.name;
          _contractAbi = contractDetails.abi;
          _decimalController.text = contractDetails.decimals.toString();
        });
      } catch (e) {
        print(e);
      }
    }
  }
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


              Text("Add New Assets",
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedBlockchain,
              dropdownColor:AppConfig.background,
                onChanged: (newValue) {
                  setState(() {
                    _selectedBlockchain = newValue!;
                  });
                  // Call _getAssetDetails whenever the blockchain is changed from the dropdown.
                  _getAssetDetails();
                },
                items: [
                  DropdownMenuItem(value: 'bscMainnet', child: Text('Binance Smart Chain')),
                  DropdownMenuItem(value: 'bscTestnet', child: Text('Binance Smart Chain Testnet')),
                  DropdownMenuItem(value: 'ethereumMainnet', child: Text('Ethereum')),
                  DropdownMenuItem(value: 'ethereumTestnet', child: Text('Ethereum Testnet')),
                  DropdownMenuItem(value: 'polygonMainnet', child: Text('Polygon')),
                  DropdownMenuItem(value: 'polygonTestnet', child: Text('Polygon Testnet')),
                ],
                decoration: InputDecoration(labelText: 'Blockchain'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a blockchain';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10,),

              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Contract Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10,),
              TextFormField(
                controller: _internalNameController,
                decoration: InputDecoration(labelText: 'Symbol'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the asset name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _decimalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Decimals'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the decimals';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveNewAsset,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
