
class User {
  final int id;
  final String name;
  final String password;
  final String? phoneNumber;
  final String? address;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.password,
    this.phoneNumber,
    this.address,
    this.isActive = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      isActive: json['isActive'] ?? true,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, password: $password, phoneNumber: $phoneNumber, address: $address, isActive: $isActive}';
  }
}
