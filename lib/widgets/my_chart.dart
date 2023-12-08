import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:difog/utils/app_config.dart';


@immutable
class MyChart extends StatelessWidget {
  final String amount;
  final double income;
  final double getIncome;

  MyChart({
    super.key,
    required this.amount,
    required this.income,
    required this.getIncome,
  });

  Map<String, double> getDataMap() {
    double bonus = income - getIncome;
    return {
      "Received": getIncome==0?0.0:getIncome,
      "Pending": income,
    };
  }

  // Colors for each segment
  // of the pie chart
  List<Color> colorList = [

    AppConfig.primaryColor,
    AppConfig.primaryColor.withOpacity(.20),
  ];
  final gradientList = <List<Color>>[
    [
      AppConfig.primaryColor,
      const Color.fromRGBO(138, 138, 138, 1.0)
    ],
    [
      const Color.fromRGBO(28, 35, 88, 0.4),
      const Color.fromRGBO(30, 23, 74, 0.4)
    ],
  ];

  final TextStyle aboutPackage = const TextStyle(
    color: AppConfig.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 18

  );
  @override
  Widget build(BuildContext context) {

    print(income);
    print(getIncome);
    Map<String, double> dataMap = getDataMap();
    return Container(
      width: double.infinity,
      //padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: MyColors.primaryColor.withOpacity(0.6), // Shadow color
        //     spreadRadius: 1, // Spread radius
        //     blurRadius: 0, // Blur radius
        //     offset: const Offset(0, 2), // Offset from the image
        //   ),
        // ],
        // color: MyColors.containerColor,
          //gradient: AppConfig.containerGradient,
          //borderRadius: BorderRadius.circular(20)

      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Image.asset(
                "assets/images/bitcoin.png",
                width: 40,
              ),
              Text("Portfolio",style: TextStyle(fontWeight: FontWeight.bold),)
            ]),

            const SizedBox(height: 20),


            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Package",
                      style: TextStyle(
                          color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14
                      ),
                    ),
                    Text(
                      "${AppConfig.currency} $amount",
                      style: const TextStyle(
                        color: AppConfig.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),

                Spacer(),

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Capping",

                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14
                      ),
                    ),
                    Text("${AppConfig.currency} $income", style: aboutPackage)
                  ],
                ),
              ],
            ),


            const SizedBox(height: 16),
            PieChart(
              chartLegendSpacing: 35,
              degreeOptions: const DegreeOptions(initialAngle: 270),
              chartType: ChartType.ring,
              centerTextStyle: const TextStyle(color: Colors.black),
              dataMap: dataMap,
              colorList: colorList,
              //emptyColor: const Color.fromRGBO(138, 138, 138, 1.0),
              chartRadius: MediaQuery.of(context).size.width / 3.5,
              ringStrokeWidth: 18,
              animationDuration: const Duration(seconds: 3),
              chartValuesOptions: const ChartValuesOptions(
                  showChartValues: true,
                  showChartValuesOutside: true,
                  showChartValuesInPercentage: true,
                  chartValueStyle:
                  TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontWeight: FontWeight.bold,),
                  showChartValueBackground: true),
              legendOptions: const LegendOptions(
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(fontSize: 15, color: Colors.white,
                    fontWeight: FontWeight.bold,),
                  legendPosition: LegendPosition.right,
                  showLegendsInRow: false),
              //gradientList: gradientList,
            ),

            const SizedBox(height: 30),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Received Income",style: TextStyle(
                  color:  Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14

                )),
                Text("${AppConfig.currency} $getIncome", style: aboutPackage)
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Pending Income", style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14

                )),
                Text("${AppConfig.currency} ${income - getIncome}", style: aboutPackage)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
