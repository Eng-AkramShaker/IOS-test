class BannersModel {
  final List<String> images;

  BannersModel({required this.images});

  factory BannersModel.fromJson(Map<String, dynamic>? json) {
    final banners = json?['data']?['banners'] as List? ?? [];

    final images = banners
        .map((e) => e['image_url'] as String? ?? '')
        .where((url) => url.isNotEmpty)
        .toList();

    return BannersModel(images: images);
  }
}
