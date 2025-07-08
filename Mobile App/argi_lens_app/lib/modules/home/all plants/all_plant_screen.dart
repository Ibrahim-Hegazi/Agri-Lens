import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/components/components.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';


class AllPlantScreen extends StatefulWidget {
  const AllPlantScreen({super.key});

  @override
  State<AllPlantScreen> createState() => _AllPlantScreenState();
}

class _AllPlantScreenState extends State<AllPlantScreen> {
  @override
  void initState() {
    super.initState();


    final cubit = context.read<AppCubit>();
    cubit.loadPotPreview(4); // السيلاية الأولى
    cubit.loadPotPreview(3); // السيلاية الثانية
    cubit.loadPotPreview(5); // السيلاية الثالثة

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
    builder: (context, state) {
    var cubit = AppCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Plants',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Transform.scale(
              scale: 0.8,
              child: SvgPicture.asset(
                'assets/icons/ep_back.svg',
                width: 32,
                height: 32,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: allHealthPlantBuilder(context)),
        ],
      ),
    );
    }
    );
}}
