import 'package:cloud_firestore/cloud_firestore.dart';

class User1 {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final int age;
  final String sex;
  

  const User1({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.email,
    required this.sex,
    
  });

  toJson(){
    return {"First name": firstName, "LastName": lastName, "Email": email, "Age": age, "Sex": sex};
  }

  factory User1.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return User1(
      id: document.id,
      firstName: data["first name"],
      lastName: data["last name"],
      email: data["email"],
      age: data["age"],
      sex: data["sex"],
      
    );
  }

}
