part of 'create_password_bloc.dart';

abstract class CreatePasswordState extends Equatable {
  const CreatePasswordState();
  
  @override
  List<Object> get props => [];
}

class CreatePasswordInitial extends CreatePasswordState {}


class CreatePasswordLoading extends CreatePasswordState {}
