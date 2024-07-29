import 'package:equatable/equatable.dart';

class Beneficiary extends Equatable {
  final String name;
  final String phoneNumber;
  final bool isActive;
  final String? photo;
  final double balance;

  const Beneficiary({
    required this.name,
    required this.phoneNumber,
    required this.balance,
    this.isActive = true,
    this.photo,
  });

  Beneficiary copyWith({
    String? name,
    String? phoneNumber,
    bool? isActive,
    String? photo,
    double? balance,
  }) {
    return Beneficiary(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isActive: isActive ?? this.isActive,
      balance: balance ?? this.balance,
      photo: photo ?? this.photo,
    );
  }

  @override
  List<Object> get props => [name, phoneNumber, isActive, balance];
}
