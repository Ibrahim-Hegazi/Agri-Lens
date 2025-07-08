import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/components/components.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';
import '../../../shared/styles/colors.dart';



class PlantDetailsScreen extends StatefulWidget {
  final String floor;
  final String cell;
  final int healthPercentage;
  final int cellNumber;
  final int dht;
  final int soilMoisture;
  final Uint8List? image;
  final Uint8List? processedImage;

  const PlantDetailsScreen({
    Key? key,
    required this.floor,
    required this.cell,
    required this.healthPercentage,
    required this.cellNumber,
    required this.soilMoisture,
    required this.dht,
    this.image,
    this.processedImage,
  }) : super(key: key);

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  String selectedImageType = 'Original';

  @override
  Widget build(BuildContext context) {
    print('DDDHHHTTT : ${widget.dht}');


    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: widget.image != null && widget.processedImage != null
                      ? BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                  )
                      : null,
                  child: (selectedImageType == 'Original'
                      ? widget.image
                      : widget.processedImage) !=
                      null
                      ? Image.memory(
                    selectedImageType == 'Original'
                        ? widget.image!
                        : widget.processedImage!,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    fit: BoxFit.cover,
                  )
                      : SizedBox(
                    height: 250,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: CircularProgressIndicator(
                          color: ColorManager.greenColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 5,
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFF494949), size: 30,),
                  color: Colors.white,
                  onSelected: (value) {
                    setState(() {
                      selectedImageType = value;
                    });
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'Original',
                      child: Text('Original  Image',style: GoogleFonts.reemKufi(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF494949)
                      ),),
                    ),
                    PopupMenuItem(
                      value: 'Processed',
                      child: Text('Filtered  Image',style: GoogleFonts.reemKufi(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF494949)
                      ),),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Transform.scale(
                    scale: 1.2,
                    child: SvgPicture.asset(
                      'assets/icons/ep_back.svg',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          '${widget.floor} ${widget.cell}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: ColorManager.greenColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          'Health Percentage ${widget.healthPercentage}%',
                          style: GoogleFonts.reemKufi(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xFF494949)
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: detailesText(
                          headColor: const Color(0xFF494949),
                          headText: 'Status:',
                          dhtText: '${widget.dht.round()}°',
                          dhtTextColor: getColorOfTempStats(widget.dht.round()),
                          soilText: '${widget.soilMoisture.round()}%',
                          soilTextColor: getColorOfStats(widget.soilMoisture.round()),
                        ),
                      ),
                      const SizedBox(height: 20),




                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
