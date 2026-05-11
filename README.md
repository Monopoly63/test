# حصن المسلم - تطبيق فلاتر

تطبيق حصن المسلم للأذكار والأدعية - مبني بـ Flutter

## المميزات
- 33 قسم من الأذكار والأدعية
- عداد لكل ذكر مع تتبع التقدم
- نظام المفضلة
- الوضع الليلي / النهاري
- البحث في الأذكار
- فلترة حسب المجموعة
- إحصائيات الإنجاز
- حفظ الحالة محلياً

## متطلبات البناء
- Flutter SDK >= 3.0.0
- Android SDK
- Java JDK 11+

## خطوات البناء

### 1. إنشاء مشروع فلاتر جديد
```bash
flutter create hisn_almuslim --org com.hisnalmuslim
```

### 2. استبدال الملفات
انسخ محتويات المجلدات التالية إلى المشروع الجديد:
- `lib/` → استبدل مجلد lib بالكامل
- `pubspec.yaml` → استبدل الملف
- `analysis_options.yaml` → استبدل الملف
- `android/app/build.gradle` → استبدل الملف
- `android/app/src/main/AndroidManifest.xml` → استبدل الملف

### 3. تثبيت الحزم
```bash
cd hisn_almuslim
flutter pub get
```

### 4. بناء APK
```bash
flutter build apk --release
```

### 5. مسار ملف APK
```
build/app/outputs/flutter-apk/app-release.apk
```

## هيكل المشروع
```
lib/
├── main.dart                    # نقطة البداية
├── models/
│   ├── dhikr_model.dart        # نماذج البيانات
│   └── app_data.dart           # بيانات الأذكار كاملة
├── screens/
│   ├── home_screen.dart        # الشاشة الرئيسية
│   ├── dhikr_screen.dart       # شاشة الأذكار
│   └── favorites_screen.dart   # شاشة المفضلة
├── widgets/
│   ├── category_card.dart      # بطاقة القسم
│   ├── dhikr_card.dart         # بطاقة الذكر
│   ├── filter_chips.dart       # أزرار الفلترة
│   └── stats_bar.dart          # شريط الإحصائيات
├── services/
│   └── storage_service.dart    # خدمة التخزين المحلي
└── utils/
    └── app_theme.dart          # ثيم التطبيق
```

## ملاحظات
- التطبيق يعمل بدون إنترنت (offline)
- البيانات محفوظة محلياً على الجهاز
- يدعم اللغة العربية بالكامل (RTL)