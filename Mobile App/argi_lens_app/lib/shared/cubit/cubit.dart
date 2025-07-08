import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:agre_lens_app/modules/history/history_screen.dart';
import 'package:agre_lens_app/modules/home/home_screen.dart';
import 'package:agre_lens_app/modules/scan/scan_screen.dart';
import 'package:agre_lens_app/modules/settings/settings_screen.dart';
import 'package:agre_lens_app/modules/timer/timer_screen.dart';
import 'package:agre_lens_app/shared/cubit/states.dart';
import 'package:agre_lens_app/shared/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../../models/PotReportModel.dart';
import '../../models/SensorDataModel.dart';
import '../../models/pot_preview_model.dart';
import '../network/remote/api_service.dart';

class AppCubit extends Cubit<AppStates> {

  AppCubit() : super(AppInitialStates()) {
    hourController = FixedExtentScrollController(initialItem: selectedHour);
    minuteController = FixedExtentScrollController(initialItem: selectedMinute);
    _init();
    fetchUserData(); // تم استدعاء fetchUserData هنا بشكل طبيعي
    username = username ?? 'Default Username';
  }

  void _init() async {
    await loadSavedTimer();
  }

  static AppCubit get(BuildContext context) => BlocProvider.of(context);
  bool hasLoadedReportsOnce = false;

  //fetch user data
  String? username;
  String? profileImageUrl;
  String? email;
  String? farmName;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController userNameController;
  late TextEditingController farmNameController;

  StreamSubscription? userDataSubscription;

  File? profileImage;
  File? temporaryProfileImage;

  void setTemporaryProfileImage(File image) {
    temporaryProfileImage = image;
    emit(UserDataImageUpdatedState(temporaryProfileImage));
  }

  Future<String?> uploadImageToCloudinary(File imageFile) async {
    emit(UserDataLoadingState());
    try {
      final cloudName = 'dsp9effrj';
      final uploadPreset = 'flutter_unsigned';

      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final data = json.decode(res.body);
        final imageUrl = data['secure_url'];
        emit(UserDataImageUpdatedState(imageFile));
        return imageUrl;
      } else {
        emit(UserDataErrorState());
        return null;
      }
    } catch (e) {
      emit(UserDataErrorState());
      return null;
    }
  }

  // دالة لاستقبال التحديثات الفورية من Firestore
  Stream<DocumentSnapshot> getUserDataStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  void fetchUserData() {
    emit(UserDataLoadingState()); // حالة تحميل البيانات

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // استماع للتحديثات الفورية من Firestore
      userDataSubscription = getUserDataStream().listen((doc) {
        if (doc.exists && doc.data() != null) {
          var data = doc.data() as Map<String, dynamic>;

          // الآن يمكنك الوصول إلى 'username'
          username = data['username'] ?? 'User';
          profileImageUrl = data['profileImage'] ?? 'assets/images/profile_pic.png'; // إذا كانت null، استخدم قيمة فارغة
          email = data['email'] ?? '';
          farmName = data['farmName'] ?? 'My Farm';

          // تهيئة المتحكمات بعد جلب البيانات
          emailController = TextEditingController(text: email);
          passwordController = TextEditingController(text: '************');
          userNameController = TextEditingController(text: username);
          farmNameController = TextEditingController(text: farmName);

          emit(UserDataLoadedState()); // حالة عندما يتم تحميل البيانات بنجاح
        } else {
          emit(UserDataErrorState()); // في حالة البيانات غير موجودة
        }
      });
    } catch (e) {
      emit(UserDataErrorState()); // حالة خطأ في حالة حدوث مشكلة
    }
  }


  @override
  Future<void> close() {
    userDataSubscription?.cancel(); // إلغاء الاشتراك في الـ Stream عند غلق الـ Cubit
    return super.close();
  }

  Future<void> saveUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // بيانات التحديث الأولي (قبل الصورة)
      Map<String, dynamic> updatedData = {
        'username': userNameController.text,
        'farmName': farmNameController.text,
      };

      // أول تحديث (الاسم والمزرعة فقط)
      await FirebaseFirestore.instance.collection('users').doc(uid).update(updatedData);

      // تحديث بعد الصورة لو فيه صورة جديدة
      if (temporaryProfileImage != null) {
        final uploadedUrl = await uploadImageToCloudinary(temporaryProfileImage!);
        if (uploadedUrl != null) {
          profileImageUrl = uploadedUrl;

          // نحدث الصورة فقط
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'profileImage': uploadedUrl,
          });
        }
      }

      emit(UserDataSavedSuccessState());
      fetchUserData(); // تحديث الكيوبت بالبيانات الجديدة
    } catch (e) {
      print('Error saving user data: $e');
      emit(UserDataErrorState());
    }
  }


  SensorDataModel? sensorData;

  Future<void> loadSensorData(int farmId) async {
    emit(SensorLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final api = ApiService(token);

      final data = await api.fetchSensorData(farmId);

      sensorData = data; // ✅ هنا تحفظ البيانات في الكيوبت
      emit(SensorLoaded(data));
    } catch (e) {
      emit(SensorError(e.toString()));
    }
  }

  Map<int, PotPreviewModel> potPreviews = {};

  Future<void> loadPotPreview(int potId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final api = ApiService(token);

      final preview = await api.fetchPotPreview(potId);

      // ✅ اطبع البيانات اللي راجعة عشان نعرف الصورة بتوصل ولا لأ
      print("Pot ID: $potId");
      print("Image bytes: ${preview.image?.length}");
      print("Dht: ${preview.dht}");
      print("Soil: ${preview.soilMoisture}");
      print("🛡️ Token used: $token");
      print("Processed image bytes: ${preview.processedImage?.length}");

      potPreviews[potId] = preview;
      emit(PotPreviewLoadedState(potId));
    } catch (e) {
      print("Error loading preview: $e");
      emit(SensorError(e.toString()));
    }
  }





  String selectedButton = '';
  String selectedButton2 = '';

  String startDate = "Select Start";
  String endDate = "Select End";

  DateTimeRange? selectedDateRange;
  void setDateRange(DateTimeRange range) {
    selectedDateRange = range;
    startDate = DateFormat('dd MMM yyyy').format(range.start);
    endDate = DateFormat('dd MMM yyyy').format(range.end);
    resetFilter();

    emit(DateRangeUpdatedState()); // تأكد من وجود هذه الحالة
  }
  void clearDateRange() {
    selectedDateRange = null;
    startDate = "Select Start";
    endDate = "Select End";
    emit(DateRangeClearedState()); // تأكد من إضافة الحالة
  }

  // تحقق إذا كانت القيم كلها فارغة (أي القيم الافتراضية)
  bool get isDefault => selectedButton.isEmpty && selectedButton2.isEmpty && startDate == "Select Start" && endDate == "Select End";

  // اختيار زر أول
  void selectButton(String text) {
    if (selectedButton != text) {
      selectedButton = text;
      emit(ButtonChangeState());  // تحديث الـ UI بعد التغيير
    }
  }

  void selectButton2(String text) {
    if (selectedButton2 != text) {
      selectedButton2 = text;
      emit(ButtonChangeState());  // تحديث الـ UI بعد التغيير
    }
  }


  // تغيير حالة الـ BottomSheet
  void changeBottomSheetState({required bool isShow}) {
    if (isBottomSheetShown != isShow) {  // تأكد من عدم تحديث الحالة بدون داعي
      isBottomSheetShown = isShow;
      emit(ButtonChangeState());  // إرسال حالة جديدة لإعادة بناء الواجهة
    }
  }

  // إعادة تعيين الفلتر الأول
  void resetFilter() {
    if (selectedButton.isNotEmpty) {  // تحقق من أنه ليس فارغًا
      selectedButton = '';  // إعادة التعيين إلى قيمة فارغة
      emit(AppChangeFilterState());
    }
  }

  // إعادة تعيين الفلتر الثاني
  void resetFilter2() {
    if (selectedButton2.isNotEmpty) {  // تحقق من أنه ليس فارغًا
      selectedButton2 = '';  // إعادة التعيين إلى قيمة فارغة
      emit(AppChangeFilterState());
    }
  }


  List<PotReportModel> getFilteredReports() {
    List<PotReportModel> filteredReports = potReports;

    // فلترة حسب الحالة الصحية
    if (selectedButton2.isNotEmpty) {
      filteredReports = filteredReports.where((report) {
        int health = report.avgHealth ?? 0;
        switch (selectedButton2) {
          case 'Healthy':
            return health >= 75;
          case 'Medium':
            return health >= 50 && health < 75;
          case 'Bad':
            return health < 50;
          default:
            return true;
        }
      }).toList();
    }

    // فلترة حسب التاريخ من البوتونات الجاهزة
    DateTime now = DateTime.now();
    if (selectedButton.isNotEmpty) {
      filteredReports = filteredReports.where((report) {
        DateTime date = report.dateTime.toLocal();
        switch (selectedButton) {
          case 'Today':
            return isSameDay(date, now);
          case 'Yesterday':
            return isSameDay(date, now.subtract(Duration(days: 1)));
          case 'This Week':
            DateTime weekStart = now.subtract(Duration(days: now.weekday - 1)); // بداية الأسبوع (السبت أو الاثنين حسب التقويم)
            DateTime weekEnd = weekStart.add(Duration(days: 6)); // نهاية الأسبوع
            // خليه يفلتر أي حاجة ما بين بداية ونهاية الأسبوع
            return !date.isBefore(weekStart) && !date.isAfter(weekEnd);

          case 'This month':
            return date.year == now.year && date.month == now.month;
          case 'Previous month':
            DateTime prevMonth = DateTime(now.year, now.month - 1);
            return date.year == prevMonth.year && date.month == prevMonth.month;
          default:
            return true;
        }
      }).toList();
    }

    // فلترة حسب المدى الزمني
    if (selectedDateRange != null) {
      filteredReports = filteredReports.where((report) {
        final localDate = report.dateTime.toLocal(); // ✅ هنا برضو لازم toLocal
        return localDate.isAfter(selectedDateRange!.start.subtract(const Duration(seconds: 1))) &&
            localDate.isBefore(selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    return filteredReports;
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }



  int healthPlantPrecentage = 45;

  void updateHealth(int newHealth) {
    healthPlantPrecentage = newHealth;
    emit(AppHealthUpdatedState());
  }

  bool isBottomSheetShown = false;



  int selectedHour = 1;
  int selectedMinute = 0;

  int savedHour = 1;
  int savedMinute = 0;

  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;

  Future<void> loadSavedTimer() async {
    final prefs = await SharedPreferences.getInstance();

    savedHour = prefs.getInt('savedHour') ?? 1;
    savedMinute = prefs.getInt('savedMinute') ?? 0;

    selectedHour = savedHour;
    selectedMinute = savedMinute;

    // تحديث المؤشرات بدون إعادة التهيئة
    hourController.jumpToItem(selectedHour);
    minuteController.jumpToItem(selectedMinute);

    emit(TimerResetState()); // تحديث الواجهة
  }


  Future<void> saveTimer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('savedHour', selectedHour);
    await prefs.setInt('savedMinute', selectedMinute);

    int totalDelayMinutes = selectedMinute + (selectedHour * 60);
    print(totalDelayMinutes);


    savedHour = selectedHour;
    savedMinute = selectedMinute;

    emit(TimerSavedState()); // إرسال حالة الحفظ

    try {
      final token = prefs.getString('token') ?? '';
      final api = ApiService(token);

      final response = await api.updateDelayTime(
        farmId: 3, // تقدر تخليه متغير حسب الحاجة
        newDelayTime: totalDelayMinutes,
      );

      print("تم الإرسال ✅: ${response.statusCode}");
      emit(TimerSentToServerState());
    } catch (e) {
      print("فشل الإرسال ❌: $e");
      emit(TimerSendErrorState(e.toString()));
    }
  }





  void updateHour(int hour) {
    selectedHour = hour;
    emit(AppUpdateTimeState());
  }

  void updateMinute(int minute) {
    selectedMinute = minute;
    emit(AppUpdateTimeState());
  }

  void resetTimer() {
    selectedHour = savedHour;
    selectedMinute = savedMinute;

    hourController.jumpToItem(selectedHour);
    minuteController.jumpToItem(selectedMinute);

    emit(TimerResetState());
  }



  int currentIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    TimerScreen(),
    ScanScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];



  final List<String> svgIcons = [
    'assets/icons/home.svg',
    'assets/icons/timer.svg',
    'assets/icons/scan.svg',
    'assets/icons/history.svg',
    'assets/icons/settings.svg',
  ];

  final List<String> labels = ['Home', 'Timer', '', 'History', 'Settings'];

  void changeNavBarIndex(int index) {
    currentIndex = index;
    emit(AppBottomNavState());
  }

  List<BottomNavigationBarItem> get bottomItems {
    return List.generate(svgIcons.length, (index) {
      final bool isSelected = currentIndex == index;

      return BottomNavigationBarItem(
        icon: index == 2
            ? currentIndex == 2
                ? Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            color: ColorManager.greenColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              svgIcons[index],
              width: 24,
              height: 24,
            ),
          ),
        )
                : Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: ColorManager.greenColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              svgIcons[index],
              width: 24,
              height: 24,
            ),
          ),
        )
            : SvgPicture.asset(
                svgIcons[index],
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isSelected ? ColorManager.greenColor : const Color(0xFF484C52),
                  BlendMode.srcIn,
                ),
              ),
        label: labels[index],
      );
    });
  }


  List<PotReportModel> potReports = [];

  bool isRefreshing = false;

  Future<void> loadReports({
    required int farmId,
    required int page,
    required int pageSize,
    bool refresh = false,
  }) async {
    if (!refresh) emit(ReportsLoading());
    isRefreshing = refresh;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final api = ApiService(token);
      final newReports = await api.fetchPotReports(
        farmId: farmId,
        page: page,
        pageSize: pageSize,
      );

      if (page == 1) {
        potReports = newReports;
      } else {
        potReports.addAll(newReports);
      }

      hasLoadedReportsOnce = true; // ✅ أهو
      emit(ReportsLoaded());
    } catch (e) {
      print('Errorrrr is : $e');
      emit(ReportsError(e.toString()));
    } finally {
      isRefreshing = false;
    }
  }

  bool isFilterApplied = false;
  List<PotReportModel> filteredReports = [];


  // void clearReports() {
  //   currentPage = 1;
  //   potReports.clear();
  //   emit(ReportsLoaded());
  // }

  void applyFilters() {
    List<PotReportModel> tempFiltered = List.from(potReports);

    // فلترة حسب الزر الرئيسي (تاريخ مثل Today, Yesterday...)
    if (selectedButton.isNotEmpty) {
      DateTime now = DateTime.now();
      tempFiltered = tempFiltered.where((report) {
        DateTime reportDate = DateTime(report.dateTime.year, report.dateTime.month, report.dateTime.day);
        switch (selectedButton) {
          case "Today":
            return reportDate == DateTime(now.year, now.month, now.day);

          case "Yesterday":
            return reportDate == DateTime(now.year, now.month, now.day - 1);

          case "Last 7 Days":
            return reportDate.isAfter(now.subtract(Duration(days: 7)));

          case "This Month":
            return reportDate.month == now.month && reportDate.year == now.year;

          case "Previous Month":
            DateTime previousMonth = DateTime(now.year, now.month - 1);
            return reportDate.month == previousMonth.month && reportDate.year == previousMonth.year;

          default:
            return true;
        }
      }).toList();
    }


    // فلترة حسب المدى الزمني
    if (selectedDateRange != null) {
      tempFiltered = tempFiltered.where((report) {
        return report.dateTime.isAfter(selectedDateRange!.start.subtract(Duration(seconds: 1))) &&
            report.dateTime.isBefore(selectedDateRange!.end.add(Duration(days: 1)));
      }).toList();
    }

    // فلترة حسب الصحة
    if (selectedButton2.isNotEmpty) {
      tempFiltered = tempFiltered.where((report) {
        int health = report.avgHealth;
        switch (selectedButton2) {
          case "Healthy":
            return health >= 75;
          case "Medium":
            return health >= 50 && health < 75;
          case "Bad":
            return health < 50;
          default:
            return true;
        }
      }).toList();
    }

    // هنا نتحقق من الفلترة النهائية
    filteredReports = tempFiltered;
    isFilterApplied = true;

    emit(FilteredReportsState());
  }




  int currentPage = 1;
  int pageSize = 0;

  String selectedChartType = 'Health';


}
