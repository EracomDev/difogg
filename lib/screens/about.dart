import 'package:flutter/material.dart';
import 'package:difog/utils/app_config.dart';

class AboutPage extends StatelessWidget {
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


              Text("About Our Decentralized Wallet",
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to ${AppConfig.appName} decentralized wallet!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'At ${AppConfig.appName}, we are committed to providing you with a secure and user-friendly platform to manage your digital assets. Our decentralized wallet empowers you to take control of your financial future, allowing you to store, send, and receive various cryptocurrencies securely and conveniently.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Here\'s some information about our wallet and the benefits it offers:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            _buildBenefitItem(
              'Secure and Private',
              'We prioritize the security and privacy of your digital assets. Our decentralized wallet utilizes cutting-edge encryption techniques and secure protocols to safeguard your funds and personal information. You retain full control of your private keys, ensuring that only you have access to your funds.',
            ),
            SizedBox(height: 16.0),
            _buildBenefitItem(
              'User-Friendly Interface',
              'We believe that managing cryptocurrencies should be accessible to everyone. Our wallet features an intuitive and user-friendly interface, making it easy for both beginners and experienced users to navigate the platform seamlessly. Whether you\'re checking your balance, initiating transactions, or exploring additional features, our wallet provides a smooth and hassle-free experience.',
            ),
            SizedBox(height: 16.0),
            _buildBenefitItem(
              'Multi-Currency Support',
              'Our decentralized wallet supports a wide range of cryptocurrencies, giving you the freedom to manage various digital assets within a single platform. From popular cryptocurrencies like Bitcoin (BTC) and Ethereum (ETH) to emerging altcoins, our wallet enables you to diversify your portfolio and stay ahead in the rapidly evolving crypto market.',
            ),
            SizedBox(height: 16.0),
            _buildBenefitItem(
              'Decentralized Infrastructure',
              'As the name suggests, our wallet operates on a decentralized infrastructure, leveraging the power of blockchain technology. This means that your transactions are validated and recorded by a distributed network of nodes, ensuring transparency, immutability, and resilience to potential attacks.',
            ),
            SizedBox(height: 16.0),
            _buildBenefitItem(
              'Cross-Platform Compatibility',
              'We understand the importance of accessibility in the digital world. Our decentralized wallet is designed to be compatible with multiple platforms, including web browsers, desktop applications, and mobile devices. This cross-platform compatibility enables you to manage your digital assets wherever you are, ensuring a seamless experience across all your devices.',
            ),
            SizedBox(height: 16.0),
            _buildBenefitItem(
              'Continuous Development and Support',
              'We are dedicated to improving our wallet and providing ongoing support to our users. Our team of experts works tirelessly to enhance security measures, introduce new features, and address any user concerns. We welcome user feedback and suggestions as we strive to create the best decentralized wallet for the crypto community.',
            ),
            SizedBox(height: 16.0),
            Text(
              'At ${AppConfig.appName}, we believe in the democratization of finance and the power of decentralized technologies. Our decentralized wallet is a testament to our commitment to providing individuals with the tools and freedom to control their financial destiny. Join us on this exciting journey and experience the future of digital finance with our secure and user-friendly decentralized wallet.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          description,
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
