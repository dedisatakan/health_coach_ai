import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/remote_config_service.dart';
import 'features/coaches/cubit/coaches_cubit.dart';
import 'features/coaches/presentation/coaches_page.dart';

class App extends StatelessWidget {
  final RemoteConfigService remoteConfigService;
  const App({super.key, required this.remoteConfigService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Coach AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => CoachesCubit(remoteConfigService)..loadCoaches(),
        child: const CoachesPage(),
      ),
    );
  }
}
