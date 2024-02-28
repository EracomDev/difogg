class MyTransaction {
  String hash;
  String from;
  String to;
  BigInt value;
  int timeStamp; // Change the type to int
  String tokenSymbol;

  MyTransaction(
      {required this.hash,
      required this.from,
      required this.to,
      required this.value,
      required this.timeStamp,
      required this.tokenSymbol});

  factory MyTransaction.fromJson(Map<String, dynamic> json) {
    return MyTransaction(
      hash: json['hash'],
      from: json['from'],
      to: json['to'],
      timeStamp: int.parse(json['timeStamp']), // Parse as int
      value: BigInt.parse(json['value']),
      tokenSymbol: json['tokenSymbol'].toString(),
    );
  }
}
