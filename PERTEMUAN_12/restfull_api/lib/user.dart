class User {
  final int? id;
  final String? name;
  final String? email;
  final DateTime? createdAt;

  User({this.id, this.name, this.email, this.createdAt});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      email: _parseString(json['email']),
      createdAt: _parseDateTime(
        // Mencoba membaca dari 'created_at' (snake_case) atau 'createdAt' (camelCase)
        json['created_at'] ?? json['createdAt'],
      ),
    );
  }

  // Helper statis untuk mem-parsing nilai menjadi int?
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is num) return value.toInt();
    return null;
  }

  // Helper statis untuk mem-parsing nilai menjadi String?
  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }
  
  // Helper statis untuk mem-parsing nilai menjadi DateTime? (diperbarui dengan try-catch)
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Method toJson (Konversi Objek Dart menjadi Map/JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt?.toIso8601String(), // Convert DateTime ke String
    };
  }

  // Method copyWith (Membuat salinan objek dengan perubahan opsional)
  User copyWith({int? id, String? name, String? email, DateTime? createdAt}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Getter untuk validasi data minimum
  bool get isValid => id != null && name != null && name!.isNotEmpty;

  // Overrides untuk Debugging dan Perbandingan Objek
  
  @override
  String toString() {
    return 'SafeUser{id: $id, name: $name, email: $email, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) => 
      identical(this, other) ||
      other is User &&
      runtimeType == other.runtimeType &&
      id == other.id &&
      name == other.name &&
      email == other.email &&
      createdAt == other.createdAt;

  @override
  int get hashCode => 
      id.hashCode ^ name.hashCode ^ email.hashCode ^ createdAt.hashCode;
}