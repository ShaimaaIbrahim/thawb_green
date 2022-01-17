import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ojos_app/features/profile/domin/entities/profile_entity.dart';

class UpdateProfileImagePageArgs {
  final XFile? image;
  final ProfileEntity? profile;

  UpdateProfileImagePageArgs({this.image, this.profile});
}
