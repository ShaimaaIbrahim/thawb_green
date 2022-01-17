import 'package:ojos_app/core/entities/base_entity.dart';

class ProfileEntity extends BaseEntity {
  final int? id;
  final String? name;
  final String? email;
  final String? photo;
  final String? address;
  final String? phone;
  final String? about_me;
  ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.about_me,
    required this.photo,
    required this.phone,
  });

  @override
  List<Object> get props => [
        id ?? 0,
        name!,
        email!,
        address!,
        about_me!,
        photo!,
        phone!,
      ];
}
