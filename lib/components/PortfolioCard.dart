import 'package:difog/components/MyPieChart.dart';
import 'package:difog/utils/app_config.dart';
import 'package:flutter/material.dart';

class PortfolioCard extends StatelessWidget {
  final String packageName;
  final double limit;
  final double earned;

  const PortfolioCard({
    super.key,
    required this.packageName,
    required this.limit,
    required this.earned,
  });



  //@override
  //State<PortfolioCard> createState() => _PortfolioCardState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      height: MediaQuery.sizeOf(context).height,
      width: 220,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: AppConfig.primaryColor.withOpacity(.40),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              width: 1, color: AppConfig.primaryColor.withOpacity(.20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Image.asset(
              "assets/images/bitcoin.png",
              width: 40,
            ),
            Text(packageName)
          ]),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "\$${limit}",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppConfig.primaryText),
                  ),
                  const Text(
                    "Earning Limit",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    "\$${earned}",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppConfig.primaryText),
                  ),
                  const Text(
                    "Earned",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            child: MyPieChart(dataMap: {

              "Limit": limit,
              "Earned": earned,
            },),
          )
        ],
      ),
    );
  }
}

/*class _PortfolioCardState extends State<PortfolioCard> {




}*/
