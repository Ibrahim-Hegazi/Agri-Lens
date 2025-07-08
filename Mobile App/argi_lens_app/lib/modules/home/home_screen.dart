import 'dart:async';
import 'dart:ui';


import 'package:agre_lens_app/modules/home/search/search_screen.dart';
import 'package:agre_lens_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import 'all plants/all_plant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? sensorTimer;

  @override
  void initState() {
    super.initState();

    // تحميل أول مرة
    context.read<AppCubit>().loadSensorData(3);

    final cubit = context.read<AppCubit>();
    cubit.loadPotPreview(4); // السيلاية الأولى
    cubit.loadPotPreview(3); // السيلاية الثانية
    cubit.loadPotPreview(5); // السيلاية الثالثة

    // التحديث كل دقيقة
    sensorTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      context.read<AppCubit>().loadSensorData(3);
    });
  }

  @override
  void dispose() {
    sensorTimer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is TimerSavedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Timer updated!',
              style: TextStyle(fontSize: 16),
              ),
              duration: Duration(seconds: 1),
              backgroundColor: ColorManager.greenColor,
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        String farmName = cubit.farmName ?? 'My Farm';
        return Padding(padding: EdgeInsets.only(left: 22),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(farmName,
                  style: GoogleFonts.reemKufi(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF414042)
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(right: 23),
                  child: TextField(
                    onTap: () {
                      final cubit = AppCubit.get(context);
                      final potIds = [4, 3, 5];

                      List<Map<String, dynamic>> plantItems = List.generate(3, (index) {
                        final potId = potIds[index];
                        final pot = cubit.potPreviews[potId];

                        return {
                          "floor": "Floor 1",
                          "cell": "Cell ${index + 1}",
                          "cellNumber": index + 1,
                          "healthPercentage": pot?.lastHealth ?? 0,
                          "dht": pot?.dht ?? 0,
                          "soilMoisture": pot?.soilMoisture ?? 0,
                          "image": pot?.image,
                          "processedImage": pot?.processedImage,
                        };
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage(items: plantItems)),
                      );
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Color(0xFF414042)),
                      hintText: "Search",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF414042),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Color(0xFF414042)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Color(0xFF414042)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Color(0xFF414042), width: 1.5),
                      ),
                    ), cursorColor: Color(0xFF414042),
                  ),
                ),
                const SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllPlantScreen()),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Your Plants Health',
                        style: GoogleFonts.reemKufi(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF414042)
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right, color: Color(0xFF414042),)
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(height: 150,child: healthPlantBuilder(context),),
                const SizedBox(height: 5,),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllPlantScreen()),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('All Floors',
                        style: GoogleFonts.reemKufi(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF414042)
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right, color: Color(0xFF414042),)
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(height: 140,child: floorPlantBuilder(),),
                const SizedBox(height: 10,),
                Text('Sensors Reading',
                  style: GoogleFonts.reemKufi(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF414042)
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(right: 20,bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (cubit.sensorData != null) ...[
                        Expanded(
                          child: sensorReading1(
                            sensorName: 'Soil Moisture',
                            avgSoil: cubit.sensorData!.avgSoil.round(),
                            maxSoil: cubit.sensorData!.maxSoil,
                            minSoil: cubit.sensorData!.minSoil,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: sensorReading2(
                            sensorName: 'DHT',
                            avgDHT: cubit.sensorData!.avgTemperature.round(),
                            maxDHT: cubit.sensorData!.maxTemperature,
                            minDHT: cubit.sensorData!.minTemperature,
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: sensorReadingLoading(
                            sensorName: 'Soil Moisture',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: sensorReadingLoading(
                            sensorName: 'DHT',
                          ),
                        ),
                      ]
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
