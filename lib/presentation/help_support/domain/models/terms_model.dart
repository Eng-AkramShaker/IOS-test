class TermsModel {
  final bool? success;
  final Data? data;
  final String? message;

  TermsModel({this.success, this.data, this.message});

  factory TermsModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return TermsModel(
      success: json['success'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data?.toJson(), 'message': message};
  }
}

class Data {
  final String? title;
  final String? content;

  Data({this.title, this.content});

  factory Data.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Data(title: json['title'], content: json['content']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'content': content};
  }
}
