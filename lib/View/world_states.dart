import 'dart:async';

import 'package:covid_19_tracker_app/Services/states_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

import 'countries_list.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({super.key});

  @override
  State<WorldStatesScreen> createState() => _WorldStatesState();
}

class _WorldStatesState extends State<WorldStatesScreen> with TickerProviderStateMixin{
  late final AnimationController _controller=AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();


  @override
  void dispose() {
    _controller.dispose(); // Dispose of the AnimationController
    super.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 50),

                FutureBuilder(
                    future: statesServices.fetchWorldStatesRecords(),
                    builder: (context, AsyncSnapshot snapshot) {

                      if(!snapshot.hasData){
                        return Expanded(
                          flex: 1,
                          child: Center(
                            child: SpinKitFadingCircle(
                              color: Colors.white,
                              size: 50.0,
                              controller: _controller,
                            ),
                          ),
                        );
                      }else{
                        return Column(
                          children: [
                            PieChart(
                              dataMap: {
                                'Total' : double.parse(snapshot.data.cases.toString()),
                                'Recovered' : double.parse(snapshot.data.recovered.toString()),
                                'Details' : double.parse(snapshot.data.deaths.toString()),
                              },
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true
                              ),
                              chartRadius: MediaQuery.of(context).size.width/3.2,
                              legendOptions: const LegendOptions(
                                  legendPosition: LegendPosition.left
                              ),
                              animationDuration: const Duration(milliseconds:1200),
                              chartType: ChartType.ring,
                              colorList: colorList,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .01),
                              child: Card(
                                child: Column(
                                  children: [
                                    ReusableRow(title: 'Total',value: snapshot.data.cases.toString(),),
                                    ReusableRow(title: 'Deaths',value: snapshot.data.deaths.toString(),),
                                    ReusableRow(title: 'Recovered',value: snapshot.data.recovered.toString(),),
                                    ReusableRow(title: 'Active',value: snapshot.data.active.toString(),),
                                    ReusableRow(title: 'Critical',value: snapshot.data.critical.toString(),),
                                    ReusableRow(title: 'Today Deaths',value: snapshot.data.todayDeaths.toString(),),
                                    ReusableRow(title: 'Today Recovered',value: snapshot.data.todayRecovered.toString(),),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const CountriesListScreen()));
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Color(0xff1aa260),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: const Center(
                                  child: Text('Track Countries'),
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    },
                                ),
              ],
            ),
          )
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final title, value;
  ReusableRow({super.key,this.value,this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5,top: 10,right: 10,left: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value)
            ],
          ),
          SizedBox(height: 5,),
          Divider()
        ],
      ),
    );
  }
}

