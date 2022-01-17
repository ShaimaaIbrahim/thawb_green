// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResultModel _$LoginResultModelFromJson(Map<String, dynamic> json) {
  return LoginResultModel(
    mobile: json['phone'] as String,
    name: json['name'] as String,
    id: json['id'] as int,
    tokenType: json['token_type'],
    balance: json['balance'],
    credit: json['credit'],
    debit: json['debit'],
    expiresAt: json['expires_at'],
    // mobileActive: json['phone_verified'],
    otpCode: json['otp_code'],
    photo: json['photo'],
    status: json['status'].toString(),
    phone: json['phone'],
    aboutMe: json['about_me'],
    address: json['address'],
    accessToken: json['access_token'],
    email: json['email'],
  );
}

Map<String, dynamic> _$LoginResultModelToJson(LoginResultModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'photo': instance.photo,
      'status': instance.status,
      'phone': instance.mobile,
      'otp_code': instance.otpCode,
      'address': instance.address,
      // 'phone': instance.phone,
      'about_me': instance.aboutMe,
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'expires_at': instance.expiresAt,
      'credit': instance.credit,
      'debit': instance.debit,
      'balance': instance.balance,
    };
