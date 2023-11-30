import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/cupertino.dart';
import 'package:wallet/wallet.dart' as wallet;
import 'dart:typed_data';
void main() {
  final mnemonic = bip39.generateMnemonic();
  WalletGenerator.generateWallet(mnemonic);
}

class WalletGenerator {
  static void generateWallet(String mnemonic) {
    Uint8List seed = bip39.mnemonicToSeed(mnemonic);
    final master = wallet.ExtendedPrivateKey.master(seed, wallet.xprv);
    final root = master.forPath("m/44'/0'/0'/0/0");
    final privateKey = wallet.PrivateKey((root as wallet.ExtendedPrivateKey).key);
    print("Private Key: " + privateKey.value.toString());

    final publicKey = wallet.tron.createPublicKey(privateKey);
    print("Public Key: " + publicKey.value.toString());

    final hexString = BigInt.parse(privateKey.value.toString()).toRadixString(16);
    String privateKeyHx = hexString.toString(); // Private key
    print("Public Key Hx: " + privateKeyHx);

    final publicKeyEth = wallet.ethereum.createPublicKey(privateKey);
    var ethAddress = wallet.ethereum.createAddress(publicKeyEth); // Ethereum address
    print("Eth Address: " + ethAddress);

    final publicKeyTr = wallet.tron.createPublicKey(privateKey);
    var tronAddress = wallet.tron.createAddress(publicKeyTr); // Tron address
    print("Tron Address: " + tronAddress);
  }
}
