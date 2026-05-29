# تذكر - تطبيق أذكار وأدعية

تطبيق **تذكر** للأذكار والأدعية، مبني بـ Flutter ويدعم العربية بالكامل RTL.

## المميزات
- أقسام الأذكار والأدعية مع عداد وتتبع تقدم لكل ذكر.
- نظام المفضلة.
- زر حفظ/نسخ نص الذكر بجانب زر المفضلة.
- الوضع الليلي / النهاري.
- البحث والفلترة حسب المجموعة.
- إحصائيات الإنجاز.
- تغيير حجم الخط داخل التطبيق.
- تغيير نوع الخط من الإعدادات.
- إشعارات وتنبيهات محلية:
  - إرسال إشعار ذكر عام فورًا.
  - تحديد وقت يومي لأذكار الصباح.
  - تحديد وقت يومي لأذكار المساء.
  - منبه يومي للاستيقاظ لصلاة الفجر.
- صفحة تواصل معنا.
- خيار تقييم التطبيق.
- خيار مشاركة التطبيق.
- واجهة بأيقونات Material أبسط وأكثر احترافية.
- حفظ الحالة والإعدادات محليًا.

## صورة الإشعارات
تمت إضافة الصورة `1.jpg` كـ asset، ويستخدمها التطبيق داخل الإشعارات كصورة كبيرة/أيقونة كبيرة، مع اسم التطبيق **تذكر**.

## صوت الأذان لمنبه الفجر
كود منبه الفجر مجهز لاستخدام صوت مخصص باسم `adhan`.
لجعل صوت الأذان يعمل فعليًا على Android، أضف ملف الأذان هنا:

```text
android/app/src/main/res/raw/adhan.mp3
```

ثم ابنِ التطبيق من جديد.

## متطلبات البناء
- Flutter SDK حديث متوافق مع الحزم المستخدمة.
- Android SDK مع compileSdk 34.
- Java JDK 11+.

## خطوات البناء

### 1. إنشاء مشروع فلاتر جديد عند الحاجة
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
- `android/app/src/main/res/raw/` → مجلد صوت الأذان عند توفره
- `1.jpg` → صورة الإشعارات

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
```text
build/app/outputs/flutter-apk/app-release.apk
```

## هيكل المشروع
```text
lib/
├── main.dart
├── models/
│   ├── dhikr_model.dart
│   └── app_data.dart
├── screens/
│   ├── home_screen.dart
│   ├── dhikr_screen.dart
│   ├── favorites_screen.dart
│   ├── settings_screen.dart
│   ├── notifications_screen.dart
│   └── contact_screen.dart
├── widgets/
│   ├── category_card.dart
│   ├── dhikr_card.dart
│   ├── filter_chips.dart
│   └── stats_bar.dart
├── services/
│   ├── storage_service.dart
│   └── notification_service.dart
└── utils/
    ├── app_theme.dart
    └── icon_mapper.dart
```

## ملاحظات
- بيانات الأذكار محفوظة داخل التطبيق.
- الحالة، المفضلة، إعدادات الخط، وأوقات التنبيهات تحفظ محليًا على الجهاز.
- إذا كان التطبيق سيُنشر على المتجر، حدّث رابط المشاركة وبيانات التواصل حسب بياناتك الرسمية.
