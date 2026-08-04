# AGENTS.md — CookingApp-Mobile

مرجع دائم لأي Agent يعمل داخل هذا المشروع. يجب الرجوع إليه قبل تنفيذ أي مهمة.

---

## 1. ملخص Architecture

- **Feature-first**: كل ميزة داخل `lib/features/<feature>/`.
- **طبقتان فقط**: `data` + `presentation`.
- **لا يوجد** Repository layer.
- **لا يوجد** Domain layer / Use Cases.
- **إدارة الحالة**: `flutter_bloc` فقط (BLoC + Cubit للثيم).
- **مسار البيانات**:
  ```
  UI → Event → BLoC → *Api class → Model → State → UI
  ```
- BLoC يستدعي الـ API مباشرة (بدون Repository).
- HTTP: `package:http` لـ Auth، و `dio` لباقي الميزات.
- التوكن: `TokenStorage` عبر SharedPreferences (`Bearer` في الـ headers).
- Base URL الأساسي: `ApiUrl.baseUrl` في `lib/core/constants/api_url.dart` → `http://127.0.0.1:8000/api`.

---

## 2. Structure المشروع

```
lib/
├── main.dart
├── core/
│   ├── constants/     # ApiUrl, AppColors, AppTheme, AppStrings, ThemeCubit, TextStyles
│   ├── theme/         # ثيم قديم/بديل (غير المستخدم الأساسي في main)
│   └── utils/         # TokenStorage, AppRouter
└── features/
    ├── splash/
    ├── onboarding/          # data + domain(entities) + presentation
    ├── auth/                # data (api + models) + presentation (bloc/pages/widgets)
    ├── main_navigation/     # Bottom Nav shell + BLoC providers
    ├── community/           # أكبر feature: posts + recipes + comments + likes + saves
    ├── add_recipe/          # إنشاء Post عبر multipart
    ├── recipe_detail/       # تفاصيل عبر GET /posts/{id}
    ├── profile/             # ملف شخصي + محفوظاتي + وصفاتي
    └── setting/             # إعدادات + عرض البروفايل + تسجيل خروج
```

داخل كل feature عادةً:
- `data/api/` أو `data/*_api.dart`
- `data/models/` أو `data/model/`
- `presentation/bloc/` (أو مجلدات bloc منفصلة)
- `presentation/pages/`
- `presentation/widgets/` أو `widget/`

---

## 3. أسلوب كتابة الكود المستخدم

- تعليقات عربية مختلطة داخل الكود.
- رسائل الأخطاء والـ UI غالباً بالعربية.
- BLoC pattern: `*_bloc.dart` + `*_event.dart` + `*_state.dart`.
- States شائعة: `Initial` → `Loading` → `Success/Loaded` | `Error/Failure`.
- إنشاء الـ API داخل أو عبر constructor الـ BLoC (`AuthApi()`, أو `UsersPostsBloc(UsersPostsApi())`).
- Dio غالباً يُنشأ داخل كلاس الـ API (`final Dio dio = Dio();`) بدون Dio client مشترك.
- الـ Navigation غالباً عبر `Navigator.push` / `pushReplacement` + `MaterialPageRoute` (ليس go_router).
- `AppRouter` موجود لكنه محدود (`/login`, `/register`) وغير مستخدم كمسار أساسي للتطبيق.
- لا يوجد Dependency Injection مركزي (get_it / injectable).
- الـ BLoCs تُوفَّر غالباً في `MainNavigationPage` عبر `BlocProvider` / `MultiBlocProvider`.

---

## 4. Naming Convention

| النوع | النمط | مثال |
|--------|--------|------|
| Feature folder | snake_case | `add_recipe`, `recipe_detail` |
| API class | PascalCase + Api | `CreatePostApi`, `UsersPostsApi` |
| API file | snake_case `_api.dart` | `create_post_api.dart` |
| Model | PascalCase + Model | `RecipeDetailModel`, `PostModel` |
| BLoC | PascalCase + Bloc | `AuthBloc`, `UsersPostsBloc` |
| Event | PascalCase + Event/Submitted | `GetUsersPostsEvent`, `LoginSubmitted` |
| State | PascalCase + State suffix | `UsersPostsSuccess`, `AuthFailure` |
| Page | PascalCase + Page/Screen | `LoginPage`, `AddRecipeScreen` |
| Models folder | `models` أو `model` (community تستخدم `model`) | |

لا تغيّر أسماء الملفات/الكلاسات/المتغيرات الموجودة.

---

## 5. قواعد استخدام flutter_bloc

- استخدم **flutter_bloc فقط** لإدارة الحالة.
- ممنوع إدخال Provider / Riverpod / GetX / MobX / setState كـ state management أساسي للميزات.
- `ThemeCubit` موجود للثيم فقط — لا توسّع نمط Cubit لميزات جديدة إلا إذا طُلب صراحة أو كان مطابقاً لنمط موجود.
- كل عملية شبكة تمر عبر Event → BLoC → API → emit State.
- حدّث القوائم محلياً عبر Events مخصصة عند الحاجة (مثل `UpdatePostLikeEvent`) كما هو موجود في community.
- لا تعدّل بنية الـ BLoC الموجودة إلا للمطلوب فقط.

---

## 6. قواعد التعامل مع API

- ضع استدعاءات الشبكة في كلاس `*Api` داخل `data/`.
- استخدم `ApiUrl.baseUrl` للمسارات (إلا إذا كان الملف الحالي يستخدم نمطاً مختلفاً بالفعل — لا توحّد من نفسك).
- أضف `Authorization: Bearer $token` من `TokenStorage.getToken()` للمسارات المحمية.
- Auth يستخدم `package:http`؛ باقي الميزات تستخدم `dio` — حافظ على نفس الأسلوب في الميزة التي تعدّلها.
- لا تنشئ Dio interceptor مشترك أو Repository إلا بطلب صريح.
- معالجة الأخطاء: `throw Exception('...')` ثم الـ BLoC يعمل `emit(...Failure/Error)`.

---

## 7. قواعد Models و Repositories

### Models
- Model واحد (أو مجموعة models) لكل response/request حسب الموجود.
- `fromJson` / `toJson` (أو `toMap`) حسب أسلوب الملف الحالي.
- لا تُدخل freezed / json_serializable إلا بطلب صريح.
- حافظ على أسماء الحقول كما يتوقعها الـ Backend.

### Repositories
- **المشروع حالياً بدون Repositories.**
- لا تنشئ Repository من نفسك.
- إذا طُلب لاحقاً، اسأل أولاً وانتظر التأكيد.

---

## 8. Features الحالية (مرجع سريع)

| Feature | الوظيفة |
|---------|---------|
| splash | فحص الجلسة + refresh token ثم توجيه |
| onboarding | 3 صفحات تعريفية محلية (بدون API) |
| auth | تسجيل / OTP / دخول / نسيان كلمة المرور / Google / تغيير كلمة المرور / logout |
| main_navigation | 5 تبويبات + توفير الـ BLoCs |
| community | الرئيسية (recipes) + المجتمع (posts) + إعجاب/حفظ/تعليق/بحث/تصنيفات |
| add_recipe | إنشاء Post (multipart) + اختيار تصنيفات |
| recipe_detail | تفاصيل عنصر عبر `/posts/{id}` |
| profile | بروفايل + محفوظاتي + وصفاتي المعتمدة + تعديل الملف |
| setting | إعدادات + ثيم + تسجيل خروج |

### غير موجود حالياً
- نظام أدمن (Admin)
- نظام شات (Chat) — أيقونة التعليقات فقط
- Repository / Domain / UseCase layers
- تبويب «المطبخ الذكي» = placeholder فقط

### تفريق مهم: Posts vs Recipes
- **Posts**: `GET/POST /posts` — مجتمع + إنشاء محتوى المستخدم + تفاصيل `recipe_detail`
- **Recipes**: `GET /recipes` — فيد الرئيسية + like/save/comment على `/recipes/{id}/...`
- ميزة `add_recipe` تنشئ **post** عبر `POST /posts`.

---

## 9. قواعد صارمة للعمل داخل المشروع (ملزمة)

### ممنوع بدون طلب صريح من المستخدم
- أي Refactor
- حذف ملفات
- نقل ملفات
- إعادة تسمية ملفات / كلاسات / متغيرات / مجلدات
- تغيير Architecture
- إضافة Packages
- تطبيق Best Practices تلقائياً
- إصلاح Bugs غير مطلوبة
- تحسين الكود من تلقاء نفسك
- إنشاء ملفات جديدة إلا إذا طُلب ذلك
- إدخال State Management غير flutter_bloc
- إنشاء Repository / Domain layer من نفسك

### مطلوب دائماً
- استخدم نفس أسلوب الكود الموجود في الملفات المجاورة.
- حافظ على نفس Architecture الحالية (Feature → data/api + models → presentation/bloc + pages).
- عدّل أقل عدد ممكن من الأسطر.
- اجعل التعديلات محصورة بالمطلوب فقط.
- لا تلمس أي جزء لا يتعلق بالمهمة.
- قبل أي تعديل: اشرح ماذا ستفعل ولماذا.
- إذا احتجت تعديل أكثر من ملف: أخبر المستخدم أولاً بسبب ذلك.
- إذا كان هناك أكثر من حل: اعرض أفضل الخيارات واترك القرار للمستخدم.
- إذا لم تكن متأكداً بنسبة 100%: اسأل قبل التنفيذ.
- سجّل الملاحظات فقط — لا تصلح من نفسك.

### Git
- لا تعمل commit إلا إذا طلب المستخدم ذلك صراحة.

---

## 10. تدفق التطبيق الأساسي

```
main.dart (ThemeCubit)
  → SplashPage
      → logged in + refresh OK → MainNavigationPage
      → logged in + refresh fail → clear session → LoginPage
      → not logged in → OnboardingPage → Auth pages
```

تبويبات MainNavigation:
0. الرئيسية (HomePage / recipes)
1. المجتمع (UsersPage / posts)
2. إضافة (AddRecipeScreen)
3. المطبخ الذكي (placeholder)
4. الملف الشخصي (ProfilePage)

---

## 11. العلاقات بين الملفات المهمة

- `main.dart` → `ThemeCubit` + `SplashPage`
- `SplashPage` → `AuthApi.refreshToken` + `TokenStorage` → `MainNavigationPage` | `LoginPage` | `OnboardingPage`
- `MainNavigationPage` → يوفّر معظم الـ BLoCs للتبويبات
- `AuthBloc` → `AuthApi` → models → UI يحفظ الجلسة عبر `TokenStorage.saveSession`
- Community cards → like/save/comment BLoCs → تحديث عدّادات القائمة عبر Events على `UsersPostsBloc` / `RecipesBloc`
- `CommunityPostCard` → `RecipeDetailPage` + `RecipeDetailBloc` + `RecipeDetailApi`
- Profile يعتمد على `SettingsBloc`/`SettingsApi` لعرض البيانات، وعلى `SavedItemsBloc` و `MyPostsBloc` للتبويبات

---

## 12. Checklist قبل أي مهمة مستقبلية

1. اقرأ هذا الملف (`AGENTS.md`).
2. افحص الملفات المجاورة لنفس الـ feature لفهم الأسلوب.
3. اشرح الخطة للمستخدم قبل التعديل.
4. إذا أكثر من ملف أو أكثر من حل → انتظر القرار.
5. نفّذ أقل تغيير ممكن يحقق المطلوب فقط.
6. لا تعمل Refactor أو تنظيف جانبي.
)
