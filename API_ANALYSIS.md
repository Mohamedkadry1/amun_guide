# 📋 تحليل API Endpoints و Sprint Planning

**التاريخ**: 24 أبريل 2026  
**الفرع**: marwa  
**الحالة**: قيد التحليل 📊

---

## 🔑 ملخص الـ API

### معلومات الخادم:
- **Base URL**: https://amun-guide-application.up.railway.app/api
- **الإصدار**: v1
- **نمط المصادقة**: Bearer Token

### إجمالي الـ Endpoints: 77 endpoint
### إجمالي الوحدات (Modules): 10 وحدات

---

## 🗂️ تفصيل الوحدات و Endpoints

### 1️⃣ **Authentication (المصادقة)** - 6 endpoints

| Endpoint | الطريقة | الصلاحيات | الوصف |
|----------|-------|---------|--------|
| `/login` | POST | Public | تسجيل دخول + الحصول على Token |
| `/register` | POST | Public | إنشاء حساب جديد |
| `/forgot-password` | POST | Public | طلب إعادة تعيين كلمة المرور |
| `/reset-password` | POST | Public | تعيين كلمة مرور جديدة |
| `/user` | GET | Bearer | الحصول على بيانات المستخدم الحالي |
| `/test-auth` | GET | Public | اختبار الاتصال |

**المتطلبات**:
- Login: `email`, `password`
- Register: `name`, `email`, `password`
- Forgot: `email`
- Reset: `token`, `email`, `password`

---

### 2️⃣ **Places (الأماكن السياحية)** - 8 endpoints

#### المسارات العامة (Public):
| Endpoint | الطريقة | الوصف |
|----------|-------|--------|
| `/v1/places/search?q={query}` | GET | البحث عن أماكن (min 3 chars) |
| `/v1/places/trending?limit={n}` | GET | الأماكن الشهيرة (default: 10) |
| `/v1/places/filter` | GET | تصفية حسب السعر/التقييم |
| `/v1/places?page={n}&per_page={n}` | GET | قائمة جميع الأماكن (مع pagination) |
| `/v1/places/{place}` | GET | تفاصيل مكان واحد |

#### المسارات المحمية (Admin):
| Endpoint | الطريقة | الوصف |
|----------|-------|--------|
| `/v1/places` | POST | إنشاء مكان جديد |
| `/v1/places/{place}` | PUT | تحديث مكان |
| `/v1/places/{place}` | DELETE | حذف مكان |

**معاملات البحث/التصفية**:
- `q`: استعلام البحث
- `min_price`, `max_price`: نطاق السعر
- `sort`: ترتيب النتائج
- `limit`: عدد النتائج

---

### 3️⃣ **Tours (الجولات)** - 9 endpoints

#### المسارات العامة (Public):
| Endpoint | الطريقة | الوصف |
|----------|-------|--------|
| `/v1/tours` | GET | قائمة الجولات النشطة (مع تصفية) |
| `/v1/tours/search?q={query}` | GET | البحث عن جولات |
| `/v1/tours/filter` | GET | تصفية الجولات |
| `/v1/tours/popular?limit={n}` | GET | أكثر الجولات حجزاً |
| `/v1/tours/{tour}` | GET | تفاصيل جولة |
| `/v1/tours/guide/{guide_id}` | GET | جولات مرشد معين |

#### المسارات المحمية (Bearer):
| Endpoint | الطريقة | الصلاحيات | الوصف |
|----------|-------|---------|--------|
| `/v1/tours` | POST | Guide | إنشاء جولة جديدة |
| `/v1/tours/{tour}` | PUT | Owner | تحديث جولة |
| `/v1/tours/{tour}` | DELETE | Owner/Admin | حذف جولة |
| `/v1/my-tours` | GET | Guide | جولاتي (المرشد) |

**معاملات التصفية**:
- `guide_id`, `min_price`, `max_price`
- `plan_id`, `sort`, `per_page`
- `start_date`

---

### 4️⃣ **Comments (التعليقات)** - 8 endpoints

#### المسارات العامة (Public):
| Endpoint | الطريقة | الوصف |
|----------|-------|--------|
| `/v1/comments/{type}/{id}` | GET | الحصول على تعليقات (tours/places/plans) |
| `/v1/{type}/{id}/comments` | GET | الحصول على تعليقات (صيغة بديلة) |
| `/v1/{type}/{id}/comments/count` | GET | عدد التعليقات |
| `/v1/comments/{comment}` | GET | تعليق واحد |
| `/v1/user/{userId}/comments` | GET | تعليقات المستخدم |

#### المسارات المحمية (Bearer):
| Endpoint | الطريقة | الصلاحيات | الوصف |
|----------|-------|---------|--------|
| `/v1/comments` | POST | Bearer | إضافة تعليق |
| `/v1/comments/{id}` | PUT | Owner | تعديل تعليق |
| `/v1/comments/{comment}` | DELETE | Owner/Admin | حذف تعليق |

---

### 5️⃣ **Likes (الإعجابات)** - 6 endpoints

#### المسارات العامة (Public):
| Endpoint | الطريقة | الوصف |
|----------|-------|--------|
| `/v1/{type}/{id}/likes` | GET | الحصول على الإعجابات |
| `/v1/{type}/{id}/likes/count` | GET | عدد الإعجابات |

#### المسارات المحمية (Bearer):
| Endpoint | الطريقة | الصلاحيات | الوصف |
|----------|-------|---------|--------|
| `/v1/user/likes` | GET | Bearer | إعجاباتي |
| `/v1/likes` | POST | Bearer | إضافة إعجاب |
| `/v1/likes/toggle` | POST | Bearer | تبديل الإعجاب |
| `/v1/likes/{like}` | DELETE | Owner | حذف إعجاب |

---

### 6️⃣ **Analysis (التحليلات)** - 2 endpoints

| Endpoint | الطريقة | الصلاحيات | الوصف |
|----------|-------|---------|--------|
| `/v1/analysis/user_activity` | POST | Bearer | تحليل نشاطي |
| `/v1/analysis/users-all` | GET | Admin | تحليل جميع المستخدمين |

---

### 7️⃣ **Payments (المدفوعات)** - 9 endpoints

#### مسارات المستخدم (Bearer):
| Endpoint | الطريقة | الوصف |
|----------|-------|--------|
| `/v1/payments/my-payments` | GET | مدفوعاتي |
| `/v1/payments` | POST | إنشاء دفعة جديدة |
| `/v1/payments/{id}` | GET | تفاصيل الدفعة |

#### مسارات المدير (Admin):
| Endpoint | الطريقة | الوصف |
|----------|-------|--------|
| `/v1/payments` | GET | قائمة جميع المدفوعات |
| `/v1/payments/{payment}` | PUT/PATCH | تحديث حالة الدفعة |
| `/v1/payments/{id}` | DELETE | حذف دفعة |
| `/v1/payments/statistics` | GET | إحصائيات المدفوعات |
| `/v1/payments/{id}/approve` | POST | الموافقة على دفعة |
| `/v1/payments/{id}/reject` | POST | رفض دفعة |
| `/v1/payments/bulk-approve` | POST | الموافقة على عدة دفعات |

**معاملات المدفوعات**:
- `amount` (إلزامي), `payable_type`, `payable_id`
- `payment_method`, `transaction_id`
- `receipt_image`, `notes`
- `status` (approved/failed/pending)

---

### 8️⃣ **Tour Bookings (حجوزات الجولات)** - 9 endpoints

#### مسارات السائح (Tourist):
| Endpoint | الطريقة | الوصف |
|----------|-------|--------|
| `/v1/tour-bookings/my-bookings` | GET | حجوزاتي |
| `/v1/tour-bookings` | POST | إنشاء حجز جديد |
| `/v1/tour-bookings/{id}` | DELETE | إلغاء الحجز |

#### مسارات المرشد/المدير:
| Endpoint | الطريقة | الصلاحيات | الوصف |
|----------|-------|---------|--------|
| `/v1/tour-bookings/statistics` | GET | Bearer | إحصائيات الحجوزات |
| `/v1/tour-bookings` | GET | Bearer | قائمة الحجوزات (حسب الدور) |
| `/v1/tour-bookings/{id}` | GET | Bearer | تفاصيل الحجز |
| `/v1/tour-bookings/{booking}` | PUT/PATCH | Bearer | تحديث الحجز |
| `/v1/tours/{tourId}/bookings` | GET | Guide/Admin | حجوزات جولة |
| `/v1/tour-bookings/{id}/approve` | POST | Guide/Admin | الموافقة على الحجز |
| `/v1/tour-bookings/{id}/reject` | POST | Guide/Admin | رفض الحجز |

---

### 9️⃣ **Conversations (المحادثات/الذكاء الاصطناعي)** - 6 endpoints

| Endpoint | الطريقة | الصلاحيات | الوصف |
|----------|-------|---------|--------|
| `/v1/conversations` | POST | Bearer | بدء محادثة جديدة |
| `/v1/conversations` | GET | Bearer | قائمة المحادثات |
| `/v1/conversations/statistics` | GET | Bearer | إحصائيات المحادثات |
| `/v1/conversations/{id}` | GET | Owner | الحصول على محادثة |
| `/v1/conversations/{id}` | DELETE | Owner | حذف محادثة |
| `/v1/conversations/{id}/messages` | POST/GET | Bearer | إرسال/الحصول على الرسائل |
| `/v1/conversations/{id}/images` | GET | Owner | الحصول على الصور |

**أنواع السياق**:
- `image_generation` - توليد صور
- `travel_plan` - خطة سفر
- `info_request` - طلب معلومات
- `general` - عام
- `place_inquiry` - استفسار عن مكان
- `tour_inquiry` - استفسار عن جولة

---

### 🔟 **Plans (الخطط)** - 5 endpoints

| Endpoint | الطريقة | الصلاحيات | الوصف |
|----------|-------|---------|--------|
| `/plans/my` | GET | Bearer | خططي |
| `/plans` | GET | Bearer | قائمة الخطط |
| `/plans` | POST | Bearer | إنشاء خطة جديدة |
| `/plans/{plan}` | GET | Bearer | تفاصيل الخطة |
| `/plans/{plan}` | PUT/PATCH/DELETE | Owner | تحديث/حذف الخطة |

---

## 📊 إحصائيات الـ API

```
┌─ 10 Modules
│  ├─ Authentication: 6 endpoints
│  ├─ Places: 8 endpoints
│  ├─ Tours: 9 endpoints
│  ├─ Comments: 8 endpoints
│  ├─ Likes: 6 endpoints
│  ├─ Analysis: 2 endpoints
│  ├─ Payments: 9 endpoints
│  ├─ Tour Bookings: 9 endpoints
│  ├─ Conversations: 6 endpoints
│  └─ Plans: 5 endpoints
│
├─ Public Endpoints: ~30 endpoints (بدون مصادقة)
├─ Protected Endpoints: ~47 endpoints (تتطلب Bearer Token)
│
└─ Total: 77 Endpoints ✅
```

---

## 🔐 مستويات الصلاحيات

### 1. **Public** (عام)
- لا يتطلب مصادقة
- البحث، العرض، المتصفح

### 2. **Bearer** (مسجل دخول)
- يتطلب Token في الـ Header
- `Authorization: Bearer {token}`

### 3. **Owner** (المالك)
- يمكن فقط تعديل/حذف بياناتك الخاصة

### 4. **Admin** (مدير)
- صلاحيات كاملة
- إدارة المستخدمين والدفعات والجولات

### 5. **Guide** (مرشد)
- إنشاء وإدارة الجولات

### 6. **Tourist** (سائح)
- الحجز والتعليقات

---

## 🚀 الآن: Sprint Planning

