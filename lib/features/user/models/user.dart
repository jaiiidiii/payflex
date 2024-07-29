import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String picture;
  final String phoneNumber;
  final String email;
  final double balance;
  final bool isVerified;

  const User({
    required this.id,
    required this.name,
    required this.picture,
    required this.phoneNumber,
    required this.email,
    required this.balance,
    required this.isVerified,
  });

  User copyWith({
    String? id,
    String? name,
    String? picture,
    String? phoneNumber,
    String? email,
    double? balance,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      balance: balance ?? this.balance,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  List<Object?> get props => [id, name, picture, phoneNumber, email, balance, isVerified];
}
