part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitialState extends HomeState {}

class HomeGetCountSuccessState extends HomeState {
  final int count;

  const HomeGetCountSuccessState(this.count);
  @override
  List<Object?> get props => [count];
}

class HomeGetCountFailedState extends HomeState {}
