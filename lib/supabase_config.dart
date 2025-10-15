import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ycWhrZ3Z5d3JkenR3ZHRzanp6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1MDgxMzcsImV4cCI6MjA3NjA4NDEzN30.Sc7MmJo5Rz6D6sq4fJx8_7GBoVDsPg-xEWDm5PnI5eQeyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ycWhrZ3Z5d3JkenR3ZHRzanp6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1MDgxMzcsImV4cCI6MjA3NjA4NDEzN30.Sc7MmJo5Rz6D6sq4fJx8_7GBoVDsPg-xEWDm5PnI5eQ.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ycWhrZ3Z5d3JkenR3ZHRzanp6Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDUwODEzNywiZXhwIjoyMDc2MDg0MTM3fQ.dpoBb2b6afA3bfjJJL4jzC9DPU_3A3lOBPu-w_etyTo';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}