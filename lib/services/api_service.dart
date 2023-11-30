import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, double>> getPriceAndChange(String? internalName) async {
    if (internalName == null) {
      throw ArgumentError('internalName cannot be null');
    }

    final response = await http.get(
      Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?ids=binancecoin,matic-network,binance-usd,tether,dai,ethereum,polygon,&vs_currencies=usd&include_24hr_change=true&include_last_updated_at=true&include_volume=true',
      ),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData.isNotEmpty && responseData[internalName]!=null) {
        double price = double.tryParse(responseData[internalName]['usd']!.toString()) ?? 0.0;
        double change = double.tryParse(responseData[internalName]['usd_24h_change']!.toString()) ?? 0.0;
        // Round to two decimal places
        price = double.parse(price.toStringAsFixed(2));
        change = double.parse(change.toStringAsFixed(2));
        return {'price': price, 'change': change};
      } else {
        return {'price': 0, 'change': 0};
      };
    } else {
      return {'price': 0, 'change': 0};
    }
  }
}
