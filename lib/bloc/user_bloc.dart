import 'package:flutter_bloc/flutter_bloc.dart';

import '../Apis/apis.dart';
import '../models/user_model.dart';

class UserBloc extends Cubit<List<UserModel>> {
  final APIs userRepository = APIs();

  UserBloc() : super([]);

  void fetchUsers() async {
    final users = await userRepository.fetchUsers();
    emit(users);
  }
}
