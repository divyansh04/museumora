part of 'create_password_bloc.dart';

abstract class CreatePasswordEvent extends Equatable {
  const CreatePasswordEvent();

  @override
  List<Object> get props => [];
}

class AddPasswordToUser extends CreatePasswordEvent {
  final String password;

  AddPasswordToUser(this.password);
}
