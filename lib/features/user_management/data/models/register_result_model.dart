import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ojos_app/core/models/base_model.dart';
import 'package:ojos_app/features/user_management/domain/entities/register_result.dart';

part 'register_result_model.g.dart';

@JsonSerializable()
class RegisterResultModel extends BaseModel<RegisterResult> {
  final String? name;
  final String? phone;
  @JsonKey(name: 'api_token')
  final String? email;
  @JsonKey(name: 'otp_code')
  final int? otpCode;
  final String? address;
  final String? about_me;
  final String? photo;
  final String? access_token;
  final String? token_type;
  final String? expires_at;
  final int? id;
  final String? credit;
  final String? debit;
  final String? balance;
  final bool? phone_verified;
  final bool? status;

  // final String msg;

  RegisterResultModel({
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

  factory RegisterResultModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResultModelFromJson(json);

  @override
  RegisterResult toEntity() => RegisterResult(
        phone: this.phone ?? '',
        name: this.name ?? '',
        id: this.id ?? 0,
        expires_at: this.expires_at ?? '',
        balance: this.balance ?? '',
        credit: this.credit ?? '',
        debit: this.debit ?? '',
        phone_verified: this.phone_verified ?? false,
        email: this.email ?? '',
        address: this.address ?? '',
        about_me: this.about_me ?? '',
        status: this.status,
        otpCode: this.otpCode ?? 0,
        access_token: this.access_token ?? '',
        photo: this.photo ?? '',
        token_type: this.token_type ?? '',
      );
}
