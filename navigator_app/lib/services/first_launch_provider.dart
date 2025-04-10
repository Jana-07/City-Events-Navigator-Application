import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'first_launch_provider.g.dart';

@riverpod
Future<bool> firstLaunch(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('hasLaunched') ?? true;
}

@riverpod
Future<void> markAppLaunched(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('hasLaunched', false);
}