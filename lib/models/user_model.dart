class UserModel {
  final String email;
  final String fname;
  final String lname;
  final String address;
  final String dateofbirth;

  UserModel({required this.fname, required this.lname, required this.address, required this.dateofbirth, required this.email,});

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'],
      fname: data['fname'],
      lname: data['lname'],
      address: data['address'],
      dateofbirth: data['dateofbirth'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fname': fname,
      'lname': lname,
      'address': address,
      'dateofbirth': dateofbirth,
    };
  }
}
