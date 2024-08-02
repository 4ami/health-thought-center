import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_web/auth/auth_bloc.dart';
import 'package:ht_web/conf/routes/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBLOC>(create: (context) => AuthBLOC()),
      ],
      child: MaterialApp.router(
        title: 'Health Thought Center',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.instance.router,
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1A5319)),
        ),
      ),
    );
  }
}
