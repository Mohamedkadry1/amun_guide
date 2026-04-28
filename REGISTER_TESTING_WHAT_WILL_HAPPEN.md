# 🎯 Task 1.7: Register Screen - Live Testing Guide

## 📌 ما الذي سيحدث عند التيست

### 🟢 **الحالة الحالية:**
```
✅ لا توجد أخطاء في الكود
✅ جميع الملفات موجودة وكاملة
✅ AuthProvider جاهز
✅ ApiService جاهز
✅ ValidationRules جاهزة
✅ UI Components جاهزة
```

---

## 🧪 **الاختبارات الفعلية - خطوة بخطوة**

### **الخطوة 1️⃣: تشغيل التطبيق**

```bash
cd d:\project\amun_guide
flutter run -d windows
```

**ما الذي سيحدث:**
```
✅ شاشة Loading ستظهر
✅ بعد 10-15 ثانية، التطبيق يفتح
✅ تشاهد LoginScreen
```

---

### **الخطوة 2️⃣: الذهاب لـ RegisterScreen**

**في LoginScreen:**
```
أنت تشاهد:
├─ Amun Guide Logo
├─ Title: "Welcome Back"
├─ Email field
├─ Password field
├─ Forgot Password link
├─ Login button
└─ "Don't have account?" → "Sign Up" ✅ اضغط هنا

بعد الضغط على "Sign Up":
✅ ستنتقل إلى RegisterScreen
```

---

### **الخطوة 3️⃣: في RegisterScreen**

**ستشاهد:**
```
┌─────────────────────────────────┐
│  ← Create Account               │
├─────────────────────────────────┤
│                                 │
│  Join Amun Guide Community      │
│                                 │
│  [🎒 Tourist]  [🗺️ Guide]     │
│                                 │
│  First Name                     │
│  [_____________ John]           │
│                                 │
│  Last Name                      │
│  [_____________ Doe]            │
│                                 │
│  Email Address                  │
│  [_____________ john@ex...]     │
│                                 │
│  Password                       │
│  [_____________ ••••••] 👁️    │
│                                 │
│  Confirm Password               │
│  [_____________ ••••••] 👁️    │
│                                 │
│  [   Create Account   ]         │
│                                 │
│  Already have account? Log In   │
└─────────────────────────────────┘
```

---

## 🧪 **Test Case 1: Empty Form**

```
❌ الخطوة: اضغط "Create Account" بدون ملء أي حقل

✅ النتيجة:
├─ ستشاهد رسائل خطأ تحت كل حقل:
│  ├─ "First name is required"
│  ├─ "Last name is required"
│  ├─ "Email is required"
│  ├─ "Password is required"
│  └─ "Confirm password is required"
├─ الزر يبقى أزرق (لم يتفعل)
├─ لا يحدث navigation
└─ تبقى في RegisterScreen ✅

الكود اللي يحدث:
→ _formKey.currentState!.validate()
  → كل Validator يشتغل
  → جميعهم يرجعوا error message
  → Form.validate() returns false
  → _handleRegister() يرجع بدون API call
```

---

## 🧪 **Test Case 2: Invalid Email**

```
✅ الخطوة:
├─ First Name: John
├─ Last Name: Doe
├─ Email: not-an-email ❌ (خطأ)
├─ Password: password123
├─ Confirm Password: password123
└─ اضغط "Create Account"

✅ النتيجة:
├─ رسالة خطأ تحت Email field:
│  "Enter a valid email" ❌
├─ الزر لا يستجيب
├─ لا يحدث API call
└─ تبقى في RegisterScreen

الكود اللي يحدث:
→ Email validator شيك:
  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
    .hasMatch(value!)) {
    return 'Enter a valid email';
  }
  → Returns error message
  → Form validation fails
  → No API call
```

---

## 🧪 **Test Case 3: Password Mismatch**

```
✅ الخطوة:
├─ First Name: John
├─ Last Name: Doe
├─ Email: john@example.com ✅
├─ Password: password123 ✅
├─ Confirm Password: different456 ❌ (مختلف)
└─ اضغط "Create Account"

✅ النتيجة:
├─ Form validation تمام ✅
├─ لكن في _handleRegister():
│  if (password != confirmPassword) {
│    // Show error SnackBar
│    return; // No API call
│  }
├─ SnackBar يظهر بـ:
│  ├─ Red background 🔴
│  ├─ White text
│  └─ Message: "Passwords do not match"
├─ SnackBar يختفي بعد 3 ثوان
└─ تبقى في RegisterScreen

الشاشة اللي تشاهدها:
┌─────────────────────────────┐
│        RegisterScreen        │
├─────────────────────────────┤
│   [Form fields...]          │
│                             │
│  [   Create Account   ]     │
└─────────────────────────────┘
        ↓↓↓
┌─────────────────────────────┐
│ 🔴 Passwords do not match   │ ← SnackBar
└─────────────────────────────┘
        (3 seconds)
        ↓↓↓
┌─────────────────────────────┐
│        RegisterScreen        │ ← تبقى هنا
└─────────────────────────────┘
```

---

## 🧪 **Test Case 4: Successful Registration - Tourist**

```
✅ الخطوة:
├─ User Type: Tourist ✅ (already selected)
├─ First Name: John
├─ Last Name: Doe
├─ Email: john.tourist@example.com ✅ (unique)
├─ Password: SecurePass123 ✅
├─ Confirm Password: SecurePass123 ✅
└─ اضغط "Create Account"

✅ النتيجة - الخطوة بالخطوة:

1️⃣ Form validation ✅ يمر بنجاح

2️⃣ Password matching ✅ يمر بنجاح

3️⃣ ظهور Loading Spinner:
   └─ الزر يصير disabled (رمادي)
   └─ Spinner دوار يظهر في الزر
   └─ مش قادر تضغط مرة ثانية

4️⃣ API Call يحدث:
   AuthProvider.register() يشتغل:
   
   const body = {
     "first_name": "John",
     "last_name": "Doe",
     "email": "john.tourist@example.com",
     "password": "SecurePass123",
     "password_confirmation": "SecurePass123",
     "user_type": "tourist"
   };
   
   ApiService.post('/auth/register', body):
   ├─ Headers:
   │  ├─ Content-Type: application/json
   │  └─ Authorization: (empty - تسجيل جديد)
   ├─ Timeout: 30 seconds
   ├─ Request goes to API server
   └─ Waiting for response...

5️⃣ بعد 2-3 ثواني - API Response:
   Server returns 200 OK:
   {
     "status": "success",
     "message": "User registered successfully",
     "data": {
       "user": {
         "id": 12345,
         "first_name": "John",
         "last_name": "Doe",
         "email": "john.tourist@example.com",
         "user_type": "tourist",
         ...
       },
       "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
     }
   }

6️⃣ Token Storage:
   ├─ FlutterSecureStorage.write('access_token', token)
   └─ Token محفوظ بشكل آمن ✅

7️⃣ AuthProvider Update:
   ├─ _status = authenticated
   ├─ _user = User object
   ├─ _isLoading = false
   ├─ notifyListeners() → UI rebuild
   └─ return true

8️⃣ Navigation:
   ├─ Navigator.pushReplacementNamed(context, '/home')
   ├─ RegisterScreen يختفي
   ├─ HomeScreen يظهر
   └─ User data يظهر في Profile ✅

9️⃣ في Home Screen:
   ├─ تشاهد:
   │  ├─ "Welcome, John!" ✅
   │  ├─ Profile data
   │  ├─ User type: "tourist" ✅
   │  └─ Navigation menu
   └─ تم تسجيل التطبيق بنجاح! 🎉

الكود اللي حدث:
→ _handleRegister() 
  → authProvider.register(
      firstName: "John",
      lastName: "Doe",
      email: "john.tourist@example.com",
      password: "SecurePass123",
      passwordConfirmation: "SecurePass123",
      userType: "tourist"
    )
    → AuthRepository.register(...)
      → ApiService.post('/auth/register', body)
        → HTTP POST request
        → Response: 200 OK
        → Parse JSON to AuthResponse
        → Save token
        → Return AuthResponse
      → _user = response.user
      → _status = authenticated
      → notifyListeners()
      → return true
  → success == true
  → Navigator.pushReplacementNamed(context, '/home')
  → HomeScreen يظهر ✅
```

---

## 🧪 **Test Case 5: Email Already Exists**

```
✅ الخطوة:
├─ Email: john@example.com (موجود بالفعل في الـ database)
├─ باقي البيانات صحيح
└─ اضغط "Create Account"

✅ النتيجة - الخطوة بالخطوة:

1️⃣ Form validation ✅ يمر

2️⃣ Password matching ✅ يمر

3️⃣ Loading Spinner يظهر

4️⃣ API Call:
   POST /auth/register
   {
     "email": "john@example.com",
     ...
   }

5️⃣ Server Response - 400 Bad Request:
   {
     "status": "error",
     "message": "The email has already been taken"
   }

6️⃣ ApiService catches 400:
   if (response.statusCode == 400) {
     final errorBody = jsonDecode(response.body);
     throw ApiException(
       message: errorBody['message'],
       statusCode: 400,
     );
   }

7️⃣ AuthProvider catches ApiException:
   on ApiException catch (e) {
     _status = AuthStatus.error;
     _errorMessage = e.message; // "The email has already been taken"
     _isLoading = false;
     notifyListeners();
     return false; // ← هذا يرجع false
   }

8️⃣ RegisterScreen receives success = false:
   if (success) {
     Navigator.pushReplacementNamed(context, '/home');
   } else {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text(
           authProvider.errorMessage ?? 'Registration failed',
           // Shows: "The email has already been taken"
         ),
         backgroundColor: Colors.red[700], // 🔴 Red
         duration: const Duration(seconds: 3),
       ),
     );
   }

9️⃣ النتيجة الفعلية:
   ├─ Loading spinner يختفي
   ├─ SnackBar يظهر بـ:
   │  ├─ Red background 🔴
   │  ├─ Message: "The email has already been taken"
   │  └─ Duration: 3 ثواني
   ├─ بعد 3 ثواني، SnackBar يختفي
   └─ تبقى في RegisterScreen (no navigation) ✅

الشاشة:
┌────────────────────────────────┐
│     RegisterScreen              │
├────────────────────────────────┤
│  [Loading spinner visible]      │ ← Waiting...
│                                 │
│  [   Create Account   ]         │
└────────────────────────────────┘
        (API responding...)
        ↓↓↓
┌────────────────────────────────┐
│     RegisterScreen              │
├────────────────────────────────┤
│  [Form fields]                  │
│                                 │
│  [   Create Account   ]         │
└────────────────────────────────┘
  🔴 The email has already been taken (3s)
        (disappears)
        ↓↓↓
┌────────────────────────────────┐
│     RegisterScreen              │ ← تبقى هنا
├────────────────────────────────┤
│  [Form fields cleared?]         │ ← No, form keeps data
│                                 │
│  [   Create Account   ]         │
└────────────────────────────────┘
```

---

## 🧪 **Test Case 6: Network Error (No Internet)**

```
❌ الخطوة:
├─ أوقف الإنترنت (Airplane Mode)
├─ ملأ البيانات الصحيح
└─ اضغط "Create Account"

✅ النتيجة - الخطوة بالخطوة:

1️⃣ Form validation ✅ يمر

2️⃣ Loading Spinner يظهر

3️⃣ API Call attempts:
   try {
     await http.post(
       url,
       timeout: Duration(seconds: 30),
     );
   } catch (e) {
     // Socket error because no internet
     throw ApiException(
       message: "Network error: ${e.message}",
     );
   }

4️⃣ بعد 30 ثانية - Timeout/Network Error:
   ├─ SocketException thrown
   ├─ ApiService catches it
   ├─ ApiException thrown with message
   └─ AuthProvider catches it

5️⃣ AuthProvider sets:
   ├─ _status = error
   ├─ _errorMessage = "Network error" (or timeout)
   ├─ _isLoading = false
   └─ return false

6️⃣ SnackBar يظهر:
   ├─ Red background 🔴
   ├─ Message: "Network error"
   └─ Duration: 3 ثواني

الشاشة:
┌────────────────────────────────┐
│     RegisterScreen              │
├────────────────────────────────┤
│  [Loading spinner...]           │ ← Waiting 30 sec
│                                 │
│  [   Create Account   ]         │
└────────────────────────────────┘
     (30 seconds pass...)
     (No response from API)
        ↓↓↓
┌────────────────────────────────┐
│     RegisterScreen              │
├────────────────────────────────┤
│  [Form fields]                  │
│                                 │
│  [   Create Account   ]         │
└────────────────────────────────┘
  🔴 Network error (3s)
        (disappears)
        ↓↓↓
┌────────────────────────────────┐
│     RegisterScreen              │ ← تبقى هنا
├────────────────────────────────┤
│  [Form fields]                  │
│                                 │
│  [   Create Account   ]         │
└────────────────────────────────┘
```

---

## 🧪 **Test Case 7: Password Visibility Toggle**

```
✅ الخطوة:
├─ في Password field أدخل: "MySecurePass123"
├─ Password يظهر كنقط: "••••••••••••••"
└─ اضغط على Eye Icon 👁️

✅ النتيجة - الخطوة بالخطوة:

1️⃣ قبل الضغط:
   ├─ Password field يظهر: ••••••••••••••
   ├─ Eye icon يظهر
   └─ _obscurePassword = true

2️⃣ عند الضغط على Eye Icon:
   ├─ setState(() {
   │    _obscurePassword = !_obscurePassword; // true → false
   │  });
   ├─ Widget rebuild
   └─ TextFormField.obscureText = false

3️⃣ بعد الضغط:
   ├─ Password field يظهر: MySecurePass123 ✅ (واضح)
   ├─ Eye icon يتغير (قد يكون closed eye)
   └─ _obscurePassword = false

4️⃣ عند الضغط مرة ثانية:
   ├─ setState(() {
   │    _obscurePassword = !_obscurePassword; // false → true
   │  });
   ├─ Password field يعود يظهر: ••••••••••••••
   └─ _obscurePassword = true

الكود:
TextFormField(
  controller: _passwordController,
  obscureText: _obscurePassword, ← يتغير
  decoration: InputDecoration(
    suffixIcon: IconButton(
      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
    ),
  ),
)

نفس الشيء لـ Confirm Password field ✅
```

---

## 🧪 **Test Case 8: User Type Selection**

```
✅ الخطوة:
├─ في البداية "Tourist" button مختار (gold)
├─ اضغط على "Guide" button
└─ لاحظ التغيير

✅ النتيجة - الخطوة بالخطوة:

1️⃣ قبل الضغط:
   ├─ Tourist button: Gold (#C5A358) ✅ selected
   ├─ Guide button: Gray (unselected)
   └─ _selectedUserType = "tourist"

2️⃣ عند الضغط على "Guide":
   ├─ setState(() {
   │    _selectedUserType = "guide";
   │  });
   ├─ Widget rebuild
   └─ Colors update

3️⃣ بعد الضغط:
   ├─ Tourist button: Gray (unselected)
   ├─ Guide button: Gold (#C5A358) ✅ selected
   └─ _selectedUserType = "guide"

4️⃣ عند الضغط على "Tourist" مرة ثانية:
   ├─ setState(() {
   │    _selectedUserType = "tourist";
   │  });
   ├─ Colors update again
   └─ Tourist button يرجع gold

الكود:
Row(
  children: [
    // Tourist Button
    Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedUserType = 'tourist';
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: _selectedUserType == 'tourist'
              ? AppColors.primary // Gold (#C5A358)
              : AppColors.bgCard, // Gray
          ),
          child: Text('🎒 Tourist'),
        ),
      ),
    ),
    SizedBox(width: 16),
    // Guide Button
    Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedUserType = 'guide';
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: _selectedUserType == 'guide'
              ? AppColors.primary // Gold (#C5A358)
              : AppColors.bgCard, // Gray
          ),
          child: Text('🗺️ Guide'),
        ),
      ),
    ),
  ],
)

النتيجة:
- عند التسجيل، _selectedUserType تُرسل إلى API
- user_type = "tourist" أو "guide"
- في API response، يظهر نفس القيمة
```

---

## 📊 **ملخص ما الذي سيحدث**

| Test Case | Input | Expected Output |
|-----------|-------|-----------------|
| **1. Empty Form** | No data | Validation errors |
| **2. Invalid Email** | Email: "bad" | Email error |
| **3. Password Mismatch** | Pass ≠ Confirm | SnackBar error |
| **4. Success - Tourist** | Valid data | Navigate to /home ✅ |
| **5. Success - Guide** | Valid data | Navigate to /home ✅ |
| **6. Email Exists** | Existing email | SnackBar error |
| **7. Network Error** | No internet | SnackBar error |
| **8. Password Toggle** | Click eye icon | Password visibility changes |
| **9. User Type Toggle** | Click buttons | Color/selection changes |
| **10. Navigation** | Click back | Go to LoginScreen |

---

## 🎯 **Success Criteria**

```
✅ جميع الـ Test Cases تمر بنجاح
✅ لا توجد أخطاء في Console
✅ UI responsive وسلس
✅ API integration يعمل
✅ Tokens تحفظ بشكل آمن
✅ Navigation يحدث بشكل صحيح
✅ Error messages واضح ومفيد

عندما تتحقق من جميع هذه:
→ Task 1.7 ✅ COMPLETE
→ انتقل إلى Task 1.8
```

---

**الآن أنت جاهز للتيست! 🚀**

```bash
cd d:\project\amun_guide
flutter run -d windows
```

Good Luck! 💪
