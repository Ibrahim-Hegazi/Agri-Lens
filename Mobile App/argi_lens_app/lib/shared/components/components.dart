import 'dart:math';
import 'dart:typed_data' ;
import 'dart:ui';

import 'package:agre_lens_app/modules/history/report/report_screen.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../models/PotReportModel.dart';
import '../../modules/home/floor/floor_screen.dart';
import '../../modules/home/plant details/plant_details_screen.dart';
import '../cubit/cubit.dart';
import '../styles/colors.dart';

Widget defaultFormField({
  required BuildContext context,
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?)? validator,
  Function(String)? onSubmit,
  Function(String)? onChanged,
  Function()? onTap,
  String? labelText,
  String? errorText,
  IconData? prefixIcon,
  Widget? suffixIcon,
  VoidCallback? suffixPressed,
  bool isPassword = false,
  bool isClickable = true,
}) => Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ColorManager.greenColor,
          selectionColor: ColorManager.greenColor.withOpacity(0.5),
          selectionHandleColor: ColorManager.greenColor,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        enabled: isClickable,
        onFieldSubmitted: onSubmit,
        onTap: onTap,
        onChanged: onChanged,
        cursorColor: Colors.black,
        selectionControls: MaterialTextSelectionControls(),
        validator: validator,
        decoration: InputDecoration(
          errorText: errorText,
          errorMaxLines: 2,
          labelText: labelText,
          labelStyle: TextStyle(
            color: Color(0xFF475569),
          ),
          floatingLabelStyle: TextStyle(color: Colors.black),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon,
          border: const UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFCBD5E1)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.5),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
        ),
      ),
    );

Widget profileFormField({
  required String label,
  required TextEditingController controller,
  required bool isEnabled,
  bool obscureText = false,
})=> Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 0.88,
        letterSpacing: 0,
        color: Colors.black,
      ),
    ),
    const SizedBox(height: 8),
    Container(
      width: double.infinity,
      height: 44,
      child: TextFormField(
        obscureText: obscureText,
        enabled: isEnabled,
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey),
        ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.black),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        style: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  ],
);

Widget defaultButton({
  required Color? colorButton,
  required Color? textColorButton,
  required Widget? text,
  Function()? onTap,
}) => InkWell(
  onTap: onTap,
  child: Container(
        height: 36,
        width: double.infinity,
        decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        color: colorButton
        ),
        child: Center(
        child: text
        ),
  ),
);

Widget buildHealthPlantItem({
  required BuildContext context,
  required String floor,
  required String cell,
  required int healthPercentage,
  required int cellNumber,
  required int dht,
  required int soilMoisture,
  Uint8List? image,
  Uint8List? processedImage,

})=> InkWell(
  onTap: (){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantDetailsScreen(
          floor: floor,
          cell: cell,
          healthPercentage: healthPercentage,
          cellNumber: cellNumber,
          soilMoisture: soilMoisture,
          dht: dht,
          image: image,
          processedImage: processedImage,
          //imgUrl : imgUrl
        ),
      ),
    );
  },
  child: Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 104,
            width: 104,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Image.asset(
                  'assets/images/plant health.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              border: Border.all(
                  color: getColorOfStats(healthPercentage),
              ),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                border: Border.all(
                    color: getColorOfStats(healthPercentage),
                ),
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.55)
            ),
          ),
          Text('$healthPercentage%',
            style: GoogleFonts.reemKufi(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.black
            ),
          ),
        ],
      ),
      const SizedBox(height: 5,),
      Text('$floor\n$cell',
        style: GoogleFonts.reemKufi(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black
        ),)
    ],
  ),
);

Widget healthPlantBuilder(BuildContext context){

  final cubit = AppCubit.get(context);
  final potIds = [4, 3, 5];
  print("Image bytes: ${cubit.potPreviews[potIds]?.image?.length}");


  return BuildCondition(
  condition: true,
  builder: (context)=> ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(right: 10),
      itemBuilder: (context, index){
        final potId = potIds[index];
        final lastHealth = cubit.potPreviews[potId]?.lastHealth ?? 0;
        final soilMoisture = cubit.potPreviews[potId]?.soilMoisture ?? 0;
        final dht = cubit.potPreviews[potId]?.dht ?? 0;
        return buildHealthPlantItem(
        context: context,
        floor: "Floor 1",
        cell: "Cell ${index + 1}",
        cellNumber: index + 1,
        healthPercentage: lastHealth,
        dht: dht,
        soilMoisture: soilMoisture,
          image: cubit.potPreviews[potId]?.image,
          processedImage: cubit.potPreviews[potId]?.processedImage,
      );},
      separatorBuilder: (context, index)=> SizedBox(width: 15,),
      itemCount: 3),
  fallback: (context)=> Center(child: CircularProgressIndicator(
    color: ColorManager.greenColor,
  )),
);}

Widget buildFloorPlantItem({
  required BuildContext context,
  required int floorNum,
})=> Container(
  height: 120,
  width: 140,
  padding: EdgeInsets.only(right: 16,left: 16,top: 16),
  decoration: BoxDecoration(
    color: Color(0xFFFAFAFA),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: ColorManager.greenColor),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 4,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/floor.jpeg',
          width: 100,
          height: 85,
          fit: BoxFit.cover,
        ),
      ),
      SizedBox(height: 8),
      Expanded(
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Floor $floorNum',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF414042),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FloorScreen(floorNum:floorNum)),
                );
              },
              child: Container(
                width: 16,
                height: 16,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/icons/arrow.svg',
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);

Widget floorPlantBuilder()=>BuildCondition(
  condition: true,
  builder: (context)=> ListView.separated(
      clipBehavior: Clip.none,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(right: 10),
      itemBuilder: (context, index)=> buildFloorPlantItem(
        context: context,
        floorNum: index+1
      ),
      separatorBuilder: (context, index)=> SizedBox(width: 15,),
      itemCount: 1),
  fallback: (context)=> Center(child: CircularProgressIndicator(
    color: ColorManager.greenColor,
  )),
);

Widget buildAllHealthPlantItem({
  required BuildContext context,
  required String floor,
  required String cell,
  required int healthPercentage,
  required int cellNumber,
  required int dht,
  required int soilMoisture,
  Uint8List? image,
  Uint8List? processedImage,
})=> Padding(
  padding: const EdgeInsets.only(left: 22),
  child: Column(
    children: [
      InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantDetailsScreen(
                floor: floor,
                cell: cell,
                healthPercentage: healthPercentage,
                cellNumber: cellNumber,
                dht: dht,
                soilMoisture: soilMoisture,
                image: image,
                processedImage: processedImage,
              ),
            ),
          );
        },
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 104,
                  width: 104,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                      child: Image.asset(
                        'assets/images/plant health.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: getColorOfStats(healthPercentage),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: getColorOfStats(healthPercentage),
                      ),
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.55)
                  ),
                ),
                Text('$healthPercentage%',
                  style: GoogleFonts.reemKufi(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.black
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$floor\n$cell',
                  style: GoogleFonts.reemKufi(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black
                  ),),
                Text('Health Percentage $healthPercentage%',
                  style: GoogleFonts.reemKufi(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black
                  ),),
              ],
            )
          ],
        ),
      ),
    ],
  ),
);

Widget allHealthPlantBuilder(BuildContext context) {
  final cubit = AppCubit.get(context);
  final potIds = [null, 4, 3, 5, null];
  return BuildCondition(
  condition: true,
  builder: (context) => ListView.separated(
    scrollDirection: Axis.vertical,
    physics: BouncingScrollPhysics(),
    padding: EdgeInsets.only(right: 10),
    itemCount: 5,
    itemBuilder: (context, index) {
      final potId = potIds[index];
      final lastHealth = cubit.potPreviews[potId]?.lastHealth ?? 0;
      final dht = cubit.potPreviews[potId]?.dht ?? 0;
      final soilMoisture = cubit.potPreviews[potId]?.soilMoisture ?? 0;
      if (index == 4 || index == 0 || potId == null) {
        return SizedBox(height: 20);
      }
      return buildAllHealthPlantItem(
        context: context,
        floor: 'Floor 1',
        cell: 'Cell $index',
        cellNumber: index,
        healthPercentage: lastHealth,
        dht: dht,
        soilMoisture: soilMoisture,
        image: cubit.potPreviews[potId]?.image,
        processedImage: cubit.potPreviews[potId]?.processedImage,
      );
    },
    separatorBuilder: (context, index) => SizedBox(height: 10),
  ),
  fallback: (context) => Center(
    child: CircularProgressIndicator(
      color: ColorManager.greenColor,
    ),
  ),
);}

List<Widget> historyWidgets = [];

Widget buildHistoryItem({
  required int avgSoil,
  required int avgTemperature,
  required int reportNum,
  required int reportSerial,
  required List<int> allHealth,
  required List<int> allSoil,
  required List<int> allTemperature,
  required String reportCellNum,
  required PotReportModel report,
  required BuildContext context,
  Uint8List? image,

}) {
  String formattedDate = '${report.dateTime.day.toString().padLeft(2, '0')} '
      '${_monthName(report.dateTime.month)} '
      '${report.dateTime.year}';

  String formattedTime = TimeOfDay.fromDateTime(report.dateTime).format(context);
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportScreen(
            avgSoil: avgSoil,
            avgTemperature: avgTemperature,
            image: image,
            formattedTime: formattedTime,
            formattedDate: formattedDate,
            reportNum: reportNum,
            serialNum: reportSerial,
            healthPrecentage: report.avgHealth,
            allHealth: report.allHealth,
            allSoil: report.allSoil,
            allTemperature: report.allTemperature,
            reportCellNum: _mapPotToCell(report.potId),
          )
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/plant health.jpeg',
                width: 52,
                height: 52,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Report $reportNum',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF26273A),
                          ),
                        ),
                        SizedBox(width: 15,),
                        Text(
                          'Cell ${_mapPotToCell(report.potId)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF26273A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Report Serial',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black45,
                    ),
                  ),
                  Text(
                    '$reportSerial',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF26273A),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 10,),
                Container(
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: getColorOfStats(report.avgHealth),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${report.avgHealth}%',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text(
                      formattedDate,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black45,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      formattedTime,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Widget historyItemBuilder(BuildContext context, [List<PotReportModel>? reports]) {
  final cubit = AppCubit.get(context);
  final potIds = [4, 3, 5];
  final reports = cubit.isDefault
      ? cubit.potReports
      : (cubit.getFilteredReports().isNotEmpty ? cubit.getFilteredReports() : cubit.potReports);

  return BuildCondition(
    condition: reports.isNotEmpty,
    builder: (context) {
      return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 10),
          ...reports.reversed.toList().asMap().entries.map((entry) {
            int randomNumber = Random().nextInt(1001);
            int index = entry.key;
            //final potId = index < potIds.length ? potIds[index] : 0;
            PotReportModel report = entry.value;

            return Column(
              children: [
                buildHistoryItem(
                  context: context,
                  reportNum: reports.length - index,
                  reportSerial: 6980945542 + randomNumber - 1,
                  reportCellNum: _mapPotToCell(report.potId),
                  report: report,
                  avgSoil: report.avgSoil,
                  avgTemperature: report.avgTemperature,
                  image: report.image,
                  allHealth: report.allHealth,
                  allSoil: report.allSoil,
                  allTemperature: report.allTemperature
                ),
                const SizedBox(height: 10),
              ],
            );
          }).toList(),
          const SizedBox(height: 16),
        ],
      ),
    );},
    fallback: (context) => Center(
      child: Text(
        "No data found for the selected filters.",
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    ),
  );
}



  String _monthName(int month) {
  const months = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];
  return months[month - 1];
}

String _mapPotToCell(dynamic potId) {
  int? id = int.tryParse(potId.toString());
  switch (id) {
    case 4:
      return "1";
    case 3:
      return "2";
    case 5:
      return "3";
    default:
      return potId.toString();
  }
}

Widget sensorReading1 ({
  required String? sensorName,
  required int? avgSoil,
  required int? minSoil,
  required int? maxSoil,
})=> Container(
  height: 84,
  width: 104,
  decoration: BoxDecoration(
    color: Color(0xFFFAFAFA),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: getColorOfStats(avgSoil!)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 4,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(
        vertical: 9,
        horizontal: 16
    ),
    child: Column(
      children: [
        Text(
          '$sensorName',
          style: TextStyle(
              color: Color(0xFF414042),
              fontSize: 14,
              fontWeight: FontWeight.w600
          ),
        ),
        Text(
          '$avgSoil%',
          style: GoogleFonts.poppins(
              color: getColorOfStats(avgSoil!),
              fontSize: 14,
              fontWeight: FontWeight.w600
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Min',
                style: TextStyle(
                    color: Color(0xFF414042),
                    fontSize: 8,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
            Text(
              'Max',
              style: TextStyle(
                  color: Color(0xFF414042),
                  fontSize: 8,
                  fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                '$minSoil%',
                style: GoogleFonts.poppins(
                    color: getColorOfStats(minSoil!),
                    fontSize: 8,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
            Text(
              '$maxSoil%',
              style: GoogleFonts.poppins(
                  color: getColorOfStats(maxSoil!),
                  fontSize: 8,
                  fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ],
    ),
  ),
);


Widget sensorReadingLoading ({
  required String? sensorName,
})=> Container(
  height: 84,
  width: 104,
  decoration: BoxDecoration(
    color: Color(0xFFFAFAFA),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 4,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(
        vertical: 9,
        horizontal: 16
    ),
    child: Column(
      children: [
        Text(
          '$sensorName',
          style: TextStyle(
              color: Color(0xFF414042),
              fontSize: 14,
              fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: 5,),
        SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(color: Colors.grey,))
      ],
    ),
  ),
);

Widget sensorReading2 ({
  required String? sensorName,
  required int? avgDHT,
  required int? minDHT,
  required int? maxDHT,
})=> Container(
  height: 84,
  width: 104,
  decoration: BoxDecoration(
    color: Color(0xFFFAFAFA),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: getColorOfTempStats(avgDHT!)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 4,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(
        vertical: 9,
        horizontal: 16
    ),
    child: Column(
      children: [
        Text(
          '$sensorName',
          style: TextStyle(
              color: Color(0xFF414042),
              fontSize: 14,
              fontWeight: FontWeight.w600
          ),
        ),
        Text(
          '$avgDHT°',
          style: GoogleFonts.poppins(
              color: getColorOfTempStats(avgDHT!),
              fontSize: 14,
              fontWeight: FontWeight.w600
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Min',
                style: TextStyle(
                    color: Color(0xFF414042),
                    fontSize: 8,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
            Text(
              'Max',
              style: TextStyle(
                  color: Color(0xFF414042),
                  fontSize: 8,
                  fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                '$minDHT°',
                style: GoogleFonts.poppins(
                    color: getColorOfTempStats(minDHT!),
                    fontSize: 8,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
            Text(
              '$maxDHT°',
              style: GoogleFonts.poppins(
                  color: getColorOfTempStats(maxDHT!),
                  fontSize: 8,
                  fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ],
    ),
  ),
);

Widget detailesText ({
  required String headText,
  required String soilText,
  required String dhtText,
  Color headColor = const Color(0xFF494949),
  Color soilTextColor = const Color(0xFF494949),
  Color dhtTextColor = const Color(0xFF494949),
})=> Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      headText,
      style: GoogleFonts.reemKufi(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: headColor
      ),
    ),
    SizedBox(height: 15,),
    Text.rich(
      TextSpan(
        text: 'DHT:    ',
        style: GoogleFonts.reemKufi(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF494949),
        ),
        children: [TextSpan(
          text: dhtText,
          style: GoogleFonts.reemKufi(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: dhtTextColor
          )
        )]
      ),
    ),
    Text.rich(
      TextSpan(
        text: 'Soil Moisture:    ',
        style: GoogleFonts.reemKufi(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF494949),
        ),
        children: [TextSpan(
          text: soilText,
          style: GoogleFonts.reemKufi(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: soilTextColor
          )
        )]
      ),
    ),
  ],
);

Widget timerButton({
  required Function()? onTap,
  required String textButton,
  required Color buttonColor,
  required Color borderButtonColor,
  required Color textColorButton,
})=> GestureDetector(
  onTap: onTap,
  child: Container(
      height: 45,
      width: 145,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: buttonColor,
        border: Border.all(color: borderButtonColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          textButton,
        style: TextStyle(color: textColorButton, fontSize: 16, fontWeight: FontWeight.w500),
            ),
      ),
  ),
);

Color getColorOfStats(int stats) {
  if (stats <= 50) {
    return ColorManager.redColor;
  } else if (stats <= 75) {
    return ColorManager.yellowColor;  }
  else {
    return ColorManager.greenColor;
  }
}

Color getColorOfTempStats(int stats) {
  if (stats <= 30 && stats >= 15) {
    return ColorManager.greenColor;
  } else if (stats <= 35 && stats >= 10) {
    return ColorManager.yellowColor;  }
  else{
    return ColorManager.redColor;
  }
}




