// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResultModel _$RegisterResultModelFromJson(Map<String, dynamic> json) {
  return RegisterResultModel(
    phone: json['phone'],
    name: json['name'],
    id: json['id'],
    expires_at: json['expires_at'],
    balance: json['balance'],
    credit: json['credit'],
    debit: json['debit'],
    phone_verified: json['phone_verified'],
    email: json['email'],
    address: json['address'],
    about_me: json['about_me'],
    status: json['status'],
    otpCode: json['otp_code'],
    access_token: json['access_token'],
    photo: json['photo'],
    token_type: json['token_type'],
  );
}

Map<String, dynamic> _$RegisterResultModelToJson(
        RegisterResultModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'otp_code': instance.otpCode,
      'photo': instance.photo,
      'id': instance.id,
      'credit': instance.credit,
      'debit': instance.debit,
      'balance': instance.balance,
    };
