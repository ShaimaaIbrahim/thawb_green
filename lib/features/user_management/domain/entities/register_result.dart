import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/entities/base_entity.dart';

class RegisterResult extends BaseEntity {
  final String name;
  final String phone;
  final String email;
  final int otpCode;
  final String? address;
  final String about_me;
  final String? photo;
  final String? access_token;
  final String? token_type;
  final String? expires_at;
  final int id;
  final String credit;
  final String debit;
  final String balance;
  final bool? phone_verified;
  final bool? status;

  RegisterResult({
    required this.phone,
    required this.name,
    required this.id,
    required this.expires_at,
    required this.balance,
    required this.credit,
    required this.debit,
    required this.phone_verified,
    required this.email,
    required this.address,
    required this.about_me,
    required this.status,
    required this.otpCode,
    required this.access_token,
    required this.photo,
    required this.token_type,
  });

  @override
  List<Object> get props => [
        phone,
        name,
        id,
        token_type ?? '',
        address ?? '',
        about_me,
        status ?? false,
        phone_verified ?? '',
        balance,
        credit,
        debit,
        otpCode,
      ];
}
