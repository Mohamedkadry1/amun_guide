# 📊 ملخص شامل للمشروع و API Integration Plan

**تاريخ الإنشاء**: 24 أبريل 2026  
**المشروع**: Amun Guide - Flutter Tourism App  
**الفرع**: marwa  
**الحالة**: جاهز للبدء بالتطوير 🚀

---

## 📌 البيانات الأساسية

### معلومات الـ API
| المعلومة | القيمة |
|---------|--------|
| Base URL | https://amun-guide-application.up.railway.app/api |
| الإصدار | v1 |
| إجمالي الـ Endpoints | 77 endpoint |
| إجمالي الوحدات | 10 modules |
| نمط المصادقة | Bearer Token (JWT) |
| الـ Language | Dart/Flutter |

### إحصائيات الـ Endpoints
| النوع | العدد |
|------|------|
| Public Endpoints | ~30 |
| Protected Endpoints | ~47 |
| Admin Only | ~15 |
| Get Requests | ~45 |
| Post Requests | ~20 |
| Put/Patch Requests | ~10 |
| Delete Requests | ~2 |

---

## 🗺️ خريطة الـ Modules

```
┌─────────────────────────────────────────────────────────────┐
│                    AMUN GUIDE API v1                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1️⃣  Authentication (6)                                     │
│      ├─ Login/Register                                      │
│      ├─ Password Reset                                      │
│      └─ User Profile                                        │
│                                                              │
│  2️⃣  Places (8)                                             │
│      ├─ List/Search/Filter                                  │
│      ├─ Details                                             │
│      └─ Admin CRUD                                          │
│                                                              │
│  3️⃣  Tours (9)                                              │
│      ├─ Browse/Search/Filter                                │
│      ├─ Details                                             │
│      ├─ Guide Management                                    │
│      └─ My Tours                                            │
│                                                              │
│  4️⃣  Comments (8)                                           │
│      ├─ Read Comments                                       │
│      ├─ Add/Edit/Delete                                     │
│      └─ Get by User                                         │
│                                                              │
│  5️⃣  Likes (6)                                              │
│      ├─ Toggle Like                                         │
│      ├─ Get Count                                           │
│      └─ My Likes                                            │
│                                                              │
│  6️⃣  Analysis (2)                                           │
│      ├─ User Activity                                       │
│      └─ All Users (Admin)                                   │
│                                                              │
│  7️⃣  Payments (9)                                           │
│      ├─ Create Payment                                      │
│      ├─ My Payments                                         │
│      ├─ Admin Management                                    │
│      └─ Statistics                                          │
│                                                              │
│  8️⃣  Tour Bookings (9)                                      │
│      ├─ Create Booking                                      │
│      ├─ My Bookings                                         │
│      ├─ Management                                          │
│      └─ Statistics                                          │
│                                                              │
│  9️⃣  Conversations (6)                                      │
│      ├─ AI Chat                                             │
│      ├─ Messages                                            │
│      └─ Generated Images                                    │
│                                                              │
│  🔟 Plans (5)                                               │
│      ├─ Create Plan                                         │
│      ├─ My Plans                                            │
│      └─ Management                                          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Sprint Breakdown

### **Sprint 1: Authentication & Core Setup** (13.5 ساعة)
```
Task 1.1: Http Client Setup (2h)
Task 1.2: Auth Models (1.5h)
Task 1.3: Auth Repository (2h)
Task 1.4: Splash Screen (1h)
Task 1.5: Login Screen (2h)
Task 1.6: Register Screen (1.5h)
Task 1.7: Password Recovery (2h)
Task 1.8: Secure Storage (1h)
────────────────────────
Total: 13.5 ساعة
```

### **Sprint 2: Places & Explore** (13 ساعة)
```
Task 2.1: Place Models (1h)
Task 2.2: Places Repository (2h)
Task 2.3: Explore Screen (2h)
Task 2.4: Place Details (2h)
Task 2.5: Saved Places (1.5h)
Task 2.6: Dashboard (1.5h)
Task 2.7: Pagination (1.5h)
────────────────────────
Total: 13 ساعة
```

### **Sprint 3: Tours & Bookings** (13.5 ساعة)
```
Task 3.1: Tour Models (1h)
Task 3.2: Tours Repository (2h)
Task 3.3: Tour Details (1.5h)
Task 3.4: Booking Models & Repository (1.5h)
Task 3.5: Booking Flow (2h)
Task 3.6: My Bookings (1.5h)
Task 3.7: Booking Management (2h)
────────────────────────
Total: 13.5 ساعة
```

### **Sprint 4: Payments, AI & Community** (15.5 ساعة)
```
Task 4.1: Payment Models & Repository (1.5h)
Task 4.2: Payment Receipts (1.5h)
Task 4.3: Payment Upload (1.5h)
Task 4.4: Conversation Models (1.5h)
Task 4.5: AI Chat Screen (2h)
Task 4.6: Comments/Likes Models (1.5h)
Task 4.7: Community Screen (2h)
Task 4.8: Admin Panel (2.5h)
────────────────────────
Total: 15.5 ساعة
```

### **الإجمالي**: 55.5 ساعة (حوالي 7 أسابيع بـ 8 ساعات/يوم)

---

## 📦 المكتبات المطلوبة

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # HTTP & API
  http: ^1.1.0
  dio: ^5.3.0  # (اختياري - أفضل من http)
  
  # State Management
  provider: ^6.0.0
  # أو: riverpod, bloc, getx
  
  # Storage
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.0
  
  # File Handling
  image_picker: ^1.0.0
  file_picker: ^5.3.0
  
  # UI
  cupertino_icons: ^1.0.8
  
  # Utilities
  intl: ^0.19.0  # التواريخ والأوقات
  uuid: ^4.0.0   # Generate IDs
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

---

## 🏗️ البنية المعمارية الموصى بها

### 1. **Folder Structure**
```
lib/
├── models/
│   ├── auth_models.dart
│   ├── place_models.dart
│   ├── tour_models.dart
│   ├── booking_models.dart
│   ├── payment_models.dart
│   ├── conversation_models.dart
│   ├── social_models.dart
│   └── plan_models.dart
│
├── repositories/
│   ├── auth_repository.dart
│   ├── places_repository.dart
│   ├── tours_repository.dart
│   ├── bookings_repository.dart
│   ├── payments_repository.dart
│   ├── conversations_repository.dart
│   ├── social_repository.dart
│   └── plans_repository.dart
│
├── services/
│   ├── api_service.dart
│   └── secure_storage.dart
│
├── providers/ (State Management)
│   ├── auth_provider.dart
│   ├── places_provider.dart
│   ├── tours_provider.dart
│   └── ... (باقي Providers)
│
├── core/
│   ├── constants/
│   ├── widgets/
│   ├── utils/
│   └── exceptions/
│
└── screens/ (كما هي بالفعل)
    ├── auth/
    ├── tourist/
    ├── explore/
    ├── ai/
    ├── payment/
    ├── admin/
    └── general/
```

### 2. **State Management Pattern**
```dart
// المثال: استخدام Provider
final placesProvider = FutureProvider.autoDispose<List<Place>>((ref) async {
  return await ref.watch(placesRepositoryProvider).getPlaces();
});

// في الـ Widget:
Consumer(
  builder: (context, ref, child) {
    final placesAsync = ref.watch(placesProvider);
    return placesAsync.when(
      data: (places) => PlacesListWidget(places: places),
      loading: () => LoadingWidget(),
      error: (err, st) => ErrorWidget(error: err),
    );
  },
);
```

---

## 🔐 Security Best Practices

### 1. **Token Management**
```dart
// حفظ آمن للـ Token
await secureStorage.saveToken(token);

// استرجاع الـ Token
final token = await secureStorage.getToken();

// حذف الـ Token (Logout)
await secureStorage.deleteToken();
```

### 2. **Request Interceptor**
```dart
// إضافة Token تلقائياً لكل الطلبات
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onError: (error, handler) {
      if (error.response?.statusCode == 401) {
        // Token منتهي الصلاحية - تحديث أو Logout
      }
      return handler.next(error);
    },
  ),
);
```

### 3. **Error Handling**
```dart
try {
  final result = await repository.fetchData();
} on UnauthorizedException {
  // التوجيه إلى Login
} on NetworkException {
  // عرض رسالة خطأ اتصال
} catch (e) {
  // خطأ عام
}
```

---

## 🧪 Testing Strategy

### Unit Tests
```dart
test('login should return token', () async {
  final repo = AuthRepository();
  final result = await repo.login('email', 'password');
  expect(result.token, isNotEmpty);
});
```

### Widget Tests
```dart
testWidgets('Login form validation', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  await tester.enterText(find.byType(TextField), 'invalid');
  await tester.tap(find.byType(ElevatedButton));
  expect(find.text('Invalid email'), findsOneWidget);
});
```

### Integration Tests
```dart
testWidgets('Complete login flow', (WidgetTester tester) async {
  // 1. افتح التطبيق
  // 2. أدخل البيانات
  // 3. اضغط تسجيل دخول
  // 4. تحقق من الـ Home Screen
});
```

---

## 📱 Screen-by-Screen Integration Checklist

### Authentication Screens
- [ ] Splash: اختبار Token + توجيه
- [ ] Welcome: عرض خيارات المستخدم
- [ ] Login: ربط API + حفظ Token
- [ ] Register: التحقق والتسجيل
- [ ] Forgot/Reset: العمل الكامل

### Tourist Screens
- [ ] Dashboard: أماكن شهيرة + فنادق
- [ ] Explore: بحث + تصفية
- [ ] Place Details: معلومات كاملة
- [ ] Tour Details: معلومات الجولة
- [ ] Profile: بيانات المستخدم
- [ ] Saved Places: الأماكن المحفوظة
- [ ] Notifications: الإشعارات

### Booking & Payment
- [ ] Booking Confirmation: معلومات الحجز
- [ ] My Bookings: الحجوزات السابقة
- [ ] Payment Upload: رفع الإيصالات
- [ ] Payment Receipts: سجل الدفعات
- [ ] Payment Success: رسالة النجاح

### AI & Community
- [ ] AI Chat: المحادثة مع Amun
- [ ] AI Plan Details: عرض الخطة
- [ ] Community: المشاركات والتعليقات
- [ ] Post Details: تفاصيل المشاركة

### Admin Panel
- [ ] Dashboard: إحصائيات
- [ ] Manage Tours: CRUD للجولات
- [ ] Manage Users: إدارة المستخدمين
- [ ] Approve Payments: الموافقة على الدفع

---

## 🔄 Data Flow مثال كامل

### سيناريو: سائح يحجز جولة

```
1. Explore Screen
   ├─ جلب Tours من API (GET /v1/tours)
   └─ عرض القائمة

2. Tour Details
   ├─ جلب تفاصيل الجولة (GET /v1/tours/{id})
   ├─ عرض الأماكن والسعر
   └─ المستخدم يضغط "احجز الآن"

3. Booking Screen
   ├─ إدخال عدد المشاركين
   └─ عرض السعر النهائي

4. Create Booking (POST /v1/tour-bookings)
   ├─ إرسال: tour_id + participants_count
   └─ الحصول على: booking_id + next_step

5. Payment Screen
   ├─ إدخال بيانات الدفع
   └─ رفع الإيصالة

6. Create Payment (POST /v1/payments)
   ├─ إرسال: amount + receipt_image
   ├─ الحصول على: payment_id
   └─ عرض "In Review"

7. Admin Panel
   ├─ جلب المدفوعات (GET /v1/payments)
   ├─ المدير يراجع الإيصالة
   └─ الموافقة (POST /v1/payments/{id}/approve)

8. Success
   ├─ تحديث حالة الدفعة والحجز
   ├─ إرسال تنبيه للمستخدم والمرشد
   └─ عرض "Booking Confirmed"
```

---

## ⚠️ نقاط مهمة للانتباه

### 1. **Pagination**
- كل endpoint قد يحتاج pagination
- استخدم `page` و `per_page`
- احفظ `last_page` لتحديد نهاية النتائج

### 2. **Error Messages**
- عرض رسائل خطأ واضحة للمستخدم
- Log الأخطاء للتطوير
- معالجة timeout و network errors

### 3. **Loading States**
- عرض skeleton loading
- منع double-click على الأزرار
- إظهار message عند عدم وجود نتيجة

### 4. **Image Handling**
- ضغط الصور قبل الرفع
- معالجة صور معطوبة
- عرض placeholder عند الخطأ

### 5. **Authentication**
- حفظ Token بشكل آمن
- تحديث Token عند انتهائه
- Logout وحذف Token عند عدم الصلاحية

---

## 🚀 الخطوات الأولى

### Day 1-2: Setup
```bash
# 1. إضافة المكتبات
flutter pub add http flutter_secure_storage provider

# 2. إنشاء ApiService
# 3. إنشاء Secure Storage Service
```

### Day 3: Authentication
```bash
# 1. إنشاء Auth Models
# 2. إنشاء Auth Repository
# 3. ربط Login/Register/Splash
```

### Day 4-5: Places
```bash
# 1. إنشاء Place Models
# 2. إنشاء Places Repository
# 3. ربط Explore Screen
```

### Day 6-7: Tours & Bookings
```bash
# 1. ربط Tour Details
# 2. إنشاء Booking System
```

### Week 2: Payments & Others
```bash
# 1. Payments Integration
# 2. AI Chat
# 3. Admin Panel
# 4. Testing & Polishing
```

---

## 📞 للمساعدة والاستفسارات

### أسئلة شائعة:

**س**: كيف أتعامل مع الأخطاء؟  
**ج**: استخدم try-catch وعرض رسالة واضحة للمستخدم

**س**: كيف أحفظ البيانات محلياً؟  
**ج**: استخدم SharedPreferences أو Hive للبيانات البسيطة و Secure Storage للـ Token

**س**: كيف أتعامل مع الـ Pagination؟  
**ج**: احفظ الصفحة الحالية وزيد الصفحة عند تمرير المستخدم

**س**: هل أحتاج State Management؟  
**ج**: نعم، استخدم Provider (سهل وفعّال)

---

## 📚 الملفات المرجعية

- `API_ANALYSIS.md` - تحليل مفصل للـ API
- `ENDPOINTS_DETAILED.md` - شرح كل endpoint
- `SPRINT_PLANNING.md` - خطة Sprints والتاسكات
- `PROJECT_OVERVIEW.md` - نظرة عامة على المشروع

---

**الحالة**: 🟢 جاهز للبدء  
**آخر تحديث**: 24 أبريل 2026  
**المسؤول**: فريق التطوير
