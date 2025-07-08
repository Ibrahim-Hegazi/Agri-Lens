import 'package:dio/dio.dart';

import '../../../models/PotReportModel.dart';
import '../../../models/SensorDataModel.dart';
import '../../../models/pot_preview_model.dart';

class ApiService {
  final Dio _dio;

  ApiService(String token)
      : _dio = Dio(
    BaseOptions(
      baseUrl: 'http://agri-lens.runasp.net/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ),
  );

  Future<Response> updateDelayTime({
    required int farmId,
    required int newDelayTime,
  }) async {
    return await _dio.put(
      'api/Setting/$farmId',
      queryParameters: {
        'newDelayTime': newDelayTime,
      },
    );
  }

  Future<SensorDataModel> fetchSensorData(int farmId) async {
    final response = await _dio.get('api/SensorDatas/average/$farmId');
    return SensorDataModel.fromJson(response.data);
  }

  Future<PotPreviewModel> fetchPotPreview(int potId) async {
    final response = await _dio.get('api/Farms/preview/$potId');


    print("📦 Raw response: ${response.data}"); // اطبع كل البيانات
    print("🧪 Raw avgTemperature key exists? ${response.data.containsKey('avgTemperature')}");
    print("📄 Response status code: ${response.statusCode}");
    print("📄 Response headers: ${response.headers}");
    print("🖼️ Base64 image: ${response.data['file']}");
    print("🧪 Base64 processedImage: ${response.data['processedFile']}");
    print("💫 Temp from potStatics: ${response.data['potStatics']?['avgTemperature']}");


    return PotPreviewModel.fromJson(response.data);
  }

  Future<List<PotReportModel>> fetchPotReports({
    required int farmId,
    required int page,
    required int pageSize,
  }) async {
    final response = await _dio.get(
      'api/Farms/all-pots-reports/$farmId',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );
    print('Response data: ${response.data}');
    final data = response.data as List;
    // for (int i = 0; i < data.length; i++) {
    //   final report = data[i];
    //   final potStatics = report['potStatics'] ?? {};
    //   final temp = potStatics['avgTemperature'];
    //   final soil = potStatics['avgSoil'];
    //   final potN = report['potNumber'];
    //
    //   print("🧡 Avg Temp [Report ${i+1}]: ${temp ?? 'N/A'}");
    //   print("💚 Avg Soil [Report ${i+1}]: ${soil ?? 'N/A'}");
    //   print("💜 Pot Number [Report ${i+1}]: ${potN ?? 'N/A'}");
    // }




    return data.map((item) => PotReportModel.fromJson(item)).toList();
  }




}


