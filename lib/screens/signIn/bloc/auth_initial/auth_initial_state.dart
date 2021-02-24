part of 'auth_initial_bloc.dart';

abstract class AuthInitialState extends Equatable {
  const AuthInitialState();

  @override
  List<Object> get props => [];
}

class AuthInitialInitial extends AuthInitialState {}

class AuthInitialLoading extends AuthInitialState {}
