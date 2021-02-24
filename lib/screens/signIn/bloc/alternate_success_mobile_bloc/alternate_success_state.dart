part of 'alternate_success_bloc.dart';

abstract class AlternateSuccessState extends Equatable {
  const AlternateSuccessState();

  @override
  List<Object> get props => [];
}

class AlternateSuccessInitial extends AlternateSuccessState {}

class AlternateSuccessLoading extends AlternateSuccessState {}

class AlternateSuccessFailed extends AlternateSuccessState {
  final String mobileNo;

  AlternateSuccessFailed(this.mobileNo);
}
