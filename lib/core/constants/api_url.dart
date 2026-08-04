// class ApiUrl {
//   // static const String baseUrl = "http://localhost:8000/api";
//   // static const String photoUrl = "http://localhost:8000/";
//   // رن عال ويندوز
//   static const String baseUrl = 'http://127.0.0.1:8000/api';
//   // static const String photoUrl = "http://192.168.1.11/";

// }

class ApiUrl {
//   // 👇 استخدمي IP الكمبيوتر الفعلي على الشبكة المحلية، مش localhost/127.0.0.1
//   // لأنو الموبايل والكمبيوتر جهازين منفصلين على نفس الشبكة
  static const String baseUrl = 'http://192.168.1.108:8000/api';
//   static const String photoUrl = 'http://192.168.1.11:8000/';
}

//  لازم لشغل عالموبايل اعمل تعلمية 
//  ipconfig      باخد قبل اخر رقم+ php artisan serve --host=0.0.0.0 --port=8000