class Restaurant {
  final String id;
  final String name;
  final String nit;
  final String phone;
  final String address;
  final String logoUrl;
  final double latitude;
  final double longitude;
  final String email;
  final String website;
  final Map<String, String> socialMedia;
  final List<String> openingHours;

  Restaurant({
    required this.id,
    required this.name,
    required this.nit,
    required this.phone,
    required this.address,
    required this.logoUrl,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.email = '',
    this.website = '',
    this.socialMedia = const {},
    this.openingHours = const [],
  });

  Restaurant copyWith({
    String? id,
    String? name,
    String? nit,
    String? phone,
    String? address,
    String? logoUrl,
    double? latitude,
    double? longitude,
    String? email,
    String? website,
    Map<String, String>? socialMedia,
    List<String>? openingHours,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      nit: nit ?? this.nit,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      logoUrl: logoUrl ?? this.logoUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      email: email ?? this.email,
      website: website ?? this.website,
      socialMedia: socialMedia ?? this.socialMedia,
      openingHours: openingHours ?? this.openingHours,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nit': nit,
      'phone': phone,
      'address': address,
      'logoUrl': logoUrl,
      'latitude': latitude,
      'longitude': longitude,
      'email': email,
      'website': website,
      'socialMedia': socialMedia,
      'openingHours': openingHours,
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'],
      name: map['name'],
      nit: map['nit'],
      phone: map['phone'],
      address: map['address'],
      logoUrl: map['logoUrl'],
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      email: map['email'] ?? '',
      website: map['website'] ?? '',
      socialMedia: Map<String, String>.from(map['socialMedia'] ?? {}),
      openingHours: List<String>.from(map['openingHours'] ?? []),
    );
  }
}
