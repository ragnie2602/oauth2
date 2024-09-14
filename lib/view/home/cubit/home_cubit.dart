import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter/data/repository/local/local_data_access.dart';
import 'package:my_flutter/data/repository/remote/unit_repository.dart';
import 'package:my_flutter/di/di.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final _unitRepository = getIt.get<UnitRepository>();
  LocalDataAccess localDataAccess = getIt.get();

  HomeCubit() : super(HomeInitialState());

  getCount() async {
    final response = await _unitRepository.getUnitCount();

    if (response.statusCode == 200) {
      emit(HomeGetCountSuccessState(response.data ?? 0));
    } else {
      emit(HomeGetCountFailedState());
    }
  }
}
