import 'package:payflex/features/user/models/user.dart';

abstract class UserRepository {
  Future<User?> getUser(String userId);
}

class MockUserRepository implements UserRepository {
  final Map<String, User> _users = {
    '1': const User(
      id: '1',
      name: 'John Doe',
      picture: 'assets/user_photo.png',
      phoneNumber: '123-456-7890',
      email: 'john.doe@example.com',
      balance: 1000.0,
      isVerified: true,
    ),
    '2': const User(
      id: '2',
      name: 'Jane Smith',
      picture: 'assets/udin.png',
      phoneNumber: '098-765-4321',
      email: 'jane.smith@example.com',
      balance: 500.0,
      isVerified: false,
    ),
  };

  @override
  Future<User?> getUser(String userId) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return _users[userId];
  }
}
