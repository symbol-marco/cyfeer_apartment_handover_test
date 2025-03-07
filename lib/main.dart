import 'package:cyfeer_apartment_handover/services/handover/handover_Schedule_service.dart';
import 'package:cyfeer_apartment_handover/services/user/user_service.dart';
import 'package:cyfeer_apartment_handover/view_models/login_viewmodel.dart';
import 'package:cyfeer_apartment_handover/views/login/login_view.dart';
import 'package:cyfeer_apartment_handover/views/handover_apartment/handover_apartment_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  final container = ProviderContainer(overrides: [
    sharedPreferencesProvider.overrideWithValue(sharedPreferences),
  ]);
  await container.read(handoverScheduleServiceProvider).init();

  runApp(UncontrolledProviderScope(
      container: container, child: const Application()));
}

class Application extends ConsumerWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    return MaterialApp(
      title: 'Cyfeer Apartment Handover',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) =>
            loginState?.user != null ? HandoverApartmentView() : LoginView(),
      },
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff223343)),
          fontFamily: 'SFPro'),
    );
  }
}
