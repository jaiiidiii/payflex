import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflex/features/user/models/user.dart';
import 'package:payflex/features/user/repositories/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit(this._userRepository) : super(UserInitial());

  void loginUser(String userId) async {
    emit(UserLoading());

    final user = await _userRepository.getUser(userId);
    if (user != null) {
      emit(UserLoaded(user));
    } else {
      emit(const UserError('User not found.'));
    }
  }

void updateUserBalance(double amount) {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      final updatedUser = currentUser.copyWith(balance: currentUser.balance + amount);
      emit(UserLoaded(updatedUser));
    }
  }

  User get user => (state as UserLoaded).user;
}
