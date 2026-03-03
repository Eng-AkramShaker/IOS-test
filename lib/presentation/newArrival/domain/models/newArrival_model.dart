import 'package:buynuk/core/constants/app_constants.dart';

class NewArrivalModel {
  final bool? success;
  final NewArrivalData? data;

  NewArrivalModel({this.success, this.data});

  factory NewArrivalModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return NewArrivalModel(
      success: json['success'],
      data: json['data'] != null ? NewArrivalData.fromJson(json['data']) : null,
    );
  }
}

class NewArrivalItem {
  final String? name;
  final String? desc;
  final String? image;
  final String? url;

  NewArrivalItem({this.name, this.desc, this.image, this.url});

  factory NewArrivalItem.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return NewArrivalItem(
      name: json['name'],
      desc: json['desc'],
      image: json['image'],
      url: json['url'],
    );
  }

  String get fullImageUrl => "${AppConstants.img}${image ?? ''}";
}

class NewArrivalData {
  final NewArrivalItem? big;
  final NewArrivalItem? medium;
  final NewArrivalItem? smallSpeakers;
  final NewArrivalItem? smallPerfume;

  NewArrivalData({this.big, this.medium, this.smallSpeakers, this.smallPerfume});

  factory NewArrivalData.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return NewArrivalData(
      big: json['big'] != null ? NewArrivalItem.fromJson(json['big']) : null,
      medium: json['medium'] != null ? NewArrivalItem.fromJson(json['medium']) : null,
      smallSpeakers: json['small_speakers'] != null
          ? NewArrivalItem.fromJson(json['small_speakers'])
          : null,
      smallPerfume: json['small_perfume'] != null
          ? NewArrivalItem.fromJson(json['small_perfume'])
          : null,
    );
  }
}
