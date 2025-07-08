import 'package:agre_lens_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../home/home_screen.dart';

class TimerScreen extends StatefulWidget {
   const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      AppCubit.get(context).loadSavedTimer();
    });
  }
  @override
  Widget build(BuildContext context) {
    const int infiniteScrollCount = 100000;
    const int middleIndex = infiniteScrollCount ~/ 2;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is TimerResetState) {
          setState(() {});
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        String farmName = cubit.farmName ?? 'My Farm';

        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(farmName,
                  style: GoogleFonts.reemKufi(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF414042)
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(right: 23, left: 22),
                child: TextField(
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
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Row(
                  children: [
                    InkWell(
                      onTap: (){},
                      child: Text('Your Plants Health',
                        style: GoogleFonts.reemKufi(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF414042)
                        ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right, color: Color(0xFF414042),)
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: SizedBox(height: 150,child: healthPlantBuilder(context),),
              ),
              const SizedBox(height: 20,),
              Stack(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 22),
                          child: Text(
                            'Set time',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("H", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                            SizedBox(width: 70),
                            Text("M", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // الخطوط العلوية والسفلية
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 70),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Divider(thickness: 1, color: Colors.grey.shade400),
                                  SizedBox(height: 40), // المسافة بين الخطين
                                  Divider(thickness: 1, color: Colors.grey.shade400),
                                ],
                              ),
                            ),

                            // عجلة الأرقام
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // عجلة الساعات
                                SizedBox(
                                  width: 70,
                                  height: 150,
                                  child: ListWheelScrollView.useDelegate(
                                    controller: cubit.hourController,
                                    itemExtent: 50,
                                    physics: FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      cubit.updateHour(index);
                                    },
                                    childDelegate: ListWheelChildLoopingListDelegate(
                                      children: List.generate(24, (index) => _buildTimeItem(index, cubit.selectedHour)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                // عجلة الدقائق
                                SizedBox(
                                  width: 70,
                                  height: 150,
                                  child: ListWheelScrollView.useDelegate(
                                    controller: cubit.minuteController,
                                    itemExtent: 50,
                                    physics: FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      cubit.updateMinute(index);
                                    },
                                    childDelegate: ListWheelChildLoopingListDelegate(
                                      children: List.generate(60, (index) => _buildTimeItem(index, cubit.selectedMinute)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 5, // ارتفاع الحافة الصغيرة
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x26000000), // يبدأ بالرمادي
                            Colors.transparent, // يختفي تدريجياً
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  timerButton(
                      onTap: (){
                        cubit.resetTimer();
                        cubit.changeNavBarIndex(0);
                      },
                      textButton: 'Cancel',
                      buttonColor: Colors.transparent,
                      borderButtonColor: Color(0xFF4E4E4E),
                      textColorButton: Color(0xFF4E4E4E)),
                  SizedBox(width: 10,),
                  timerButton(
                      onTap: (){
                        cubit.saveTimer();
                        cubit.changeNavBarIndex(0);
                      },
                      textButton: 'Save',
                      buttonColor: ColorManager.greenColor,
                      borderButtonColor: ColorManager.greenColor,
                      textColorButton: Colors.white)
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

Widget _buildTimeItem(int value, int selectedValue) {
  return Center(
    child: Text(
      value.toString().padLeft(2, '0'),
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: (value == selectedValue) ? Colors.black : Colors.grey,
      ),
    ),
  );
}





