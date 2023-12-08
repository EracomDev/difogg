import 'package:flutter/material.dart';

import '../utils/app_config.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.myBackground,
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
              Text(
                "FAQ",
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
      body: ListView(
        children: const [
          ExpansionTile(
            title: Text(
              'What is a decentralized wallet?',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'A decentralized wallet, also known as a crypto wallet, is a digital wallet that allows users to securely store, send, and receive cryptocurrencies without relying on a centralized authority like a bank. It gives users full control over their funds and enables them to interact with decentralized applications (dApps) on blockchain networks.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              'How do I create a decentralized wallet?',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'To create a decentralized wallet, you can use a wallet provider or create one yourself using a library like Web3j or ethers.dart. The wallet provider will generate a unique public-private key pair for you, which you can use to securely manage your funds. Make sure to follow best practices for generating and storing your private key to ensure the security of your wallet.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              'Can I recover my decentralized wallet if I lose my private key?',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No, if you lose your private key, it is usually not possible to recover your decentralized wallet. That is why it is crucial to backup and securely store your private key when you create your wallet. Losing the private key means losing access to your funds permanently.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              'Are decentralized wallets safe?',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Decentralized wallets can be secure if proper security measures are followed. It is essential to generate a strong private key, store it securely, and be cautious of phishing attempts or malware. Using hardware wallets or cold storage options can provide an extra layer of security. Always verify the authenticity of wallet providers and dApps before interacting with them.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              'Can I use a decentralized wallet for multiple cryptocurrencies?',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Yes, many decentralized wallets support multiple cryptocurrencies. When choosing a wallet, ensure it supports the specific cryptocurrencies you intend to use. Different wallet providers may have varying levels of support for different coins or tokens.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              'What are gas fees in decentralized wallets?',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Gas fees are transaction fees paid in cryptocurrency to process and validate transactions on blockchain networks. When you send a transaction or interact with a dApp, you may need to pay gas fees. These fees vary based on network congestion and the complexity of the transaction. Make sure to review and set an appropriate gas fee to avoid delays or failed transactions.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
