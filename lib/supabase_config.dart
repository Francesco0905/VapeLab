import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://orqhkgvywrdztwdtsjzz.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ycWhrZ3Z5d3JkenR3ZHRzanp6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1MDgxMzcsImV4cCI6MjA3NjA4NDEzN30.Sc7MmJo5Rz6D6sq4fJx8_7GBoVDsPg-xEWDm5PnI5eQ';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}