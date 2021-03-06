import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mynotes/repositories/notes/firebase_notes_repository.dart';
import 'package:mynotes/repositories/notes/notes_repository.dart';
import 'package:mynotes/repositories/settings/hive_settings_repository.dart';
import 'package:mynotes/repositories/settings/settings_repository.dart';

GetIt getIt = GetIt.instance;

class App {
  static Future initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    getIt.registerSingleton<SettingsRepository>(HiveSettingsRepository());

    initializeLogging();

    await getIt.get<SettingsRepository>().initialize();

    getIt.registerSingleton<NotesRepository>(
        FirestoreNotesRepository(),
        signalsReady: true);

    await getIt<NotesRepository>().initialize();
  }

  static void initializeLogging() {}
}
