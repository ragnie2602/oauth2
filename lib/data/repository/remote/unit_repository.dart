import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter/data/model/wrapper.dart';
import 'package:my_flutter/data/repository/local/local_data_access.dart';
import 'package:my_flutter/data/repository/remote/auth_repository.dart';
import 'package:my_flutter/di/di.dart';

class UnitRepository {
  final authRepository = getIt.get<AuthRepository>();
  final dio = getIt.get<Dio>();
  final localDataAccess = getIt.get<LocalDataAccess>();

  String accessToken = '';

  UnitRepository();

  Future<ResponseWrapper<int>> getUnitCount({int retry = 10}) async {
    accessToken = await localDataAccess.getAccessToken();

    try {
      final response = await dio.get(
          'https://work-api-dev.eztek.net/unit/get-All-Unit-ByUserId',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200) {
        return ResponseWrapper.success(
            List.from((response.data as Map<String, dynamic>)['data']).length);
      } else {
        debugPrint('Fuckkkkk');
        return ResponseWrapper.error(
            response.statusCode ?? 500, response.statusMessage ?? '');
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await authRepository.refreshLogin();

        if (retry > 0) {
          return getUnitCount(retry: retry - 1);
        } else {
          return ResponseWrapper.error(
              e.response?.statusCode ?? 500, e.response?.statusMessage ?? '');
        }
      } else {
        debugPrint('Lỗi éo gì thế nàyyyyyyy ${e.message}');
        return ResponseWrapper.error(500, 'Lỗi không xác định');
      }
    }
  }
}
