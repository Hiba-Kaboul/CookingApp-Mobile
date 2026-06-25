// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VerifyEmailRequestModel {
  final String? email;
  final String? code;
  VerifyEmailRequestModel({
    this.email,
    this.code,
  });

 

  VerifyEmailRequestModel copyWith({
    String? email,
    String? code,
  }) {
    return VerifyEmailRequestModel(
      email: email ?? this.email,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'code': code,
    };
  }

  factory VerifyEmailRequestModel.fromMap(Map<String, dynamic> map) {
    return VerifyEmailRequestModel(
      email: map['email'] != null ? map['email'] as String : null,
      code: map['code'] != null ? map['code'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VerifyEmailRequestModel.fromJson(String source) => VerifyEmailRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'VerifyEmailRequestModel(email: $email, code: $code)';

  @override
  bool operator ==(covariant VerifyEmailRequestModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email &&
      other.code == code;
  }

  @override
  int get hashCode => email.hashCode ^ code.hashCode;
}
