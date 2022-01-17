// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_app_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AboutAppResultModel _$AboutAppResultModelFromJson(Map<String, dynamic> json) {
  return AboutAppResultModel(
    email: json['email'],
    phone: json['phone'],
    mobile: json['mobile'],
    address: json['address'],
    facebook: json['facebook'],
    instagram: json['instagram'],
    fax: json['fax'],
    twitter: json['twitter'],
    site_desc: json['site_desc'],
    site_name: json['site_name'],
    whatsapp: json['whatsapp'],
    videoHome: VideoHomeResultModel.fromJson(json['videoHome']),
    youtube: json['youtube'],
    settings: SettingsAppResultModel.fromJson(json['settings']),
  );
}

Map<String, dynamic> _$AboutAppResultModelToJson(
        AboutAppResultModel instance) =>
    <String, dynamic>{
      'site_name': instance.site_name,
      'site_desc': instance.site_desc,
      'address': instance.address,
      'mobile': instance.mobile,
      'phone': instance.phone,
      'email': instance.email,
      'fax': instance.fax,
      'facebook': instance.facebook,
      'twitter': instance.twitter,
      'youtube': instance.youtube,
      'instagram': instance.instagram,
      'whatsapp': instance.whatsapp,
      'videoHome': instance.videoHome,
      'settings': instance.settings,
    };

VideoHomeResultModel _$VideoHomeResultModelFromJson(Map<String, dynamic> json) {
  return VideoHomeResultModel(
    title: json['title'],
    details: json['details'],
    link_url: json['link_url'],
    video_link: json['video_link'],
  );
}

Map<String, dynamic> _$VideoHomeResultModelToJson(
        VideoHomeResultModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'details': instance.details,
      'video_link': instance.video_link,
      'link_url': instance.link_url,
    };

SettingsAppResultModel _$SettingsAppResultModelFromJson(
    Map<String, dynamic> json) {
  return SettingsAppResultModel(
    //currency_right: json['currency_right'],
    default_currency: json['default_currency'],
    default_tax: json['default_tax'],
    // enable_paypal: json['enable_paypal'],
    // enable_stripe: json['enable_stripe'],
    fee_delivery: json['fee_delivery'],
    google_maps_key: json['google_maps_key'],
  );
}

Map<String, dynamic> _$SettingsAppResultModelToJson(
        SettingsAppResultModel instance) =>
    <String, dynamic>{
      // 'enable_stripe': instance.enable_stripe,
      'default_tax': instance.default_tax,
      'default_currency': instance.default_currency,
      //'enable_paypal': instance.enable_paypal,
      'google_maps_key': instance.google_maps_key,
      'fee_delivery': instance.fee_delivery,
      //'currency_right': instance.currency_right,
    };
