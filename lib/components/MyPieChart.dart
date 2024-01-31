import 'package:difog/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class MyPieChart extends StatefulWidget {
  Map<String, double> dataMap;

  MyPieChart({super.key, required this.dataMap});

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  @override
  Widget build(BuildContext context) {
    /*  {"Limit": double.parse(capping),
    "Earned": double.parse(earning)*/

    //Map<String, double> dataMap = widget.dataMap;
    Map<String, double> dataMap = {
      "Pending": double.parse(widget.dataMap["Limit"].toString()) -
          double.parse(widget.dataMap["Earned"].toString()),
      "Earned": (widget.dataMap["Earned"]) as double
    };

    return Scaffold(
      body: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 10,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: [
          AppConfig.primaryColor.withOpacity(.20),
          AppConfig.primaryColor
        ],
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 15,
        // centerText: "Package 1",
        legendOptions: const LegendOptions(
          showLegendsInRow: true,
          legendPosition: LegendPosition.bottom,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 12),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
        // gradientList: ---To add gradient colors---
        // emptyColorGradient: ---Empty Color gradient---
      ),
    );
  }
}
