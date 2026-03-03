class UserProfile {
  final int? userId;
  final String? name;
  final String? userName;
  final String? email;
  final String? phone;
  final String? mobile;
  final String? street;
  final String? city;
  final String? zip;
  final int? countryId;
  final String? countryName;
  final int? stateId;
  final String? stateName;

  UserProfile({
    this.userId,
    this.name,
    this.userName,
    this.email,
    this.phone,
    this.mobile,
    this.street,
    this.city,
    this.zip,
    this.countryId,
    this.countryName,
    this.stateId,
    this.stateName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] as Map<String, dynamic> : json;

    return UserProfile(
      userId: data['user_id'],
      name: data['name'],
      userName: data['user_name'],
      email: data['email'],
      phone: data['phone'],
      mobile: data['mobile'],
      street: data['street'],
      city: data['city'],
      zip: data['zip'],
      countryId: data['country_id'],
      countryName: data['country_name'],
      stateId: data['state_id'],
      stateName: data['state_name'],
    );
  }

  // ✅ إرسال كل الحقول بدون if
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'user_name': userName,
      'email': email,
      'phone': phone,
      'mobile': mobile,
      'street': street,
      'city': city,
      'zip': zip,
      'country_id': countryId,
      'country_name': countryName,
      'state_id': stateId,
      'state_name': stateName,
    };
  }

  UserProfile copyWith({
    int? userId,
    String? name,
    String? userName,
    String? email,
    String? phone,
    String? mobile,
    String? street,
    String? city,
    String? zip,
    int? countryId,
    String? countryName,
    int? stateId,
    String? stateName,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      mobile: mobile ?? this.mobile,
      street: street ?? this.street,
      city: city ?? this.city,
      zip: zip ?? this.zip,
      countryId: countryId ?? this.countryId,
      countryName: countryName ?? this.countryName,
      stateId: stateId ?? this.stateId,
      stateName: stateName ?? this.stateName,
    );
  }
}
