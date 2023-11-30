import 'dart:convert';
import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet/wallet.dart' as wallet;
import '../models/wallet.dart';

class WalletService {
  Future<bool> validateMnemonicWords(String mnemonics) async {
    return bip39.validateMnemonic(mnemonics);
  }
  Future<WalletModel> createWallet() async {
    final mnemonic = bip39.generateMnemonic();
    return WalletWithMnimonics(mnemonic);
  }
  Future<WalletModel> WalletWithMnimonics(mnemonic) async {
    Uint8List seed = bip39.mnemonicToSeed(mnemonic);
    final master = wallet.ExtendedPrivateKey.master(seed, wallet.xprv);
    final root = master.forPath("m/44'/0'/0'/0/0");
    final privateKey = wallet.PrivateKey((root as wallet.ExtendedPrivateKey).key);
    //print("Private Key: " + privateKey.value.toString());

    final publicKey = wallet.tron.createPublicKey(privateKey);
    /*print("Public Key: " + publicKey.value.toString());*/

    final hexString = BigInt.parse(privateKey.value.toString()).toRadixString(16);
    String privateKeyHx = hexString.padLeft(64, '0'); // Private key
    //print("Public Key Hx: " + privateKeyHx);

    final publicKeyEth = wallet.ethereum.createPublicKey(privateKey);
    var ethAddress = wallet.ethereum.createAddress(publicKeyEth); // Ethereum address
    //print("Eth Address: " + ethAddress);

    final publicKeyTr = wallet.tron.createPublicKey(privateKey);
    var tronAddress = wallet.tron.createAddress(publicKeyTr); // Tron address
    //print("Tron Address: " + tronAddress);

    return WalletModel(
      mnemonic: mnemonic,
      ethAddress: ethAddress,
      tronAddress: tronAddress,
      privateKey: privateKeyHx,
    );
  }
}
Future<List<Map<String, dynamic>>> getWalletArray() async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? walletsString = await secureStorage.read(key: 'wallets');
  if (walletsString != null && walletsString.isNotEmpty){
    final walletsArray = json.decode(walletsString);
    if (walletsArray is Iterable) {
      return List<Map<String, dynamic>>.from(walletsArray);
    } else {
      // Handle the case when walletsArray is not iterable (e.g., if it's a single object instead of an array)
      return [];
    }
  } else {
    return [];
  }
}
