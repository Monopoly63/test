import 'package:flutter/material.dart';
import '../models/dhikr_model.dart';

IconData iconForCategory(DhikrCategory category) {
  final name = category.category;
  final group = category.group;

  if (name.contains('الصباح') || name.contains('الاستيقاظ')) return Icons.wb_sunny_outlined;
  if (name.contains('المساء') || name.contains('النوم') || group == 'نوم') return Icons.nights_stay_outlined;
  if (name.contains('صلاة') || group == 'صلاة' || name.contains('المسجد') || name.contains('الأذان')) return Icons.mosque_outlined;
  if (name.contains('الوضوء') || name.contains('الخلاء')) return Icons.water_drop_outlined;
  if (name.contains('المنزل')) return Icons.home_outlined;
  if (name.contains('السفر') || group == 'سفر') return Icons.flight_takeoff_outlined;
  if (name.contains('الطعام') || name.contains('الإفطار')) return Icons.restaurant_outlined;
  if (name.contains('المريض')) return Icons.local_hospital_outlined;
  if (name.contains('الميت') || name.contains('القبور')) return Icons.volunteer_activism_outlined;
  if (name.contains('السوق')) return Icons.storefront_outlined;
  if (name.contains('المطر') || name.contains('الريح')) return Icons.thunderstorm_outlined;
  if (name.contains('الهلال')) return Icons.brightness_2_outlined;
  if (name.contains('الخوف') || name.contains('الحصن')) return Icons.shield_outlined;
  if (name.contains('القرآن') || name.contains('التلاوة')) return Icons.menu_book_outlined;
  if (name.contains('الاستخارة') || group == 'دعاء') return Icons.front_hand_outlined;
  if (group == 'يومي') return Icons.today_outlined;
  return Icons.auto_awesome_outlined;
}
