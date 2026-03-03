class LegalModel {
  final bool? success;
  final LegalData? data;
  final String? message;

  LegalModel({this.success, this.data, this.message});

  factory LegalModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return LegalModel(
      success: json['success'],
      data: json['data'] != null ? LegalData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class LegalData {
  final String? title;
  final String? content;

  LegalData({this.title, this.content});

  factory LegalData.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return LegalData(title: json['title'], content: json['content']);
  }
}
