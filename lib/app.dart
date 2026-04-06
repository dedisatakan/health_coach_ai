import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/remote_config_service.dart';
import 'features/coaches/cubit/coaches_cubit.dart';
import 'features/coaches/presentation/coaches_page.dart';
import 'features/history/presentation/history_page.dart';

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
      home: _HomeShell(remoteConfigService: remoteConfigService),
    );
  }
}

class _HomeShell extends StatefulWidget {
  final RemoteConfigService remoteConfigService;
  const _HomeShell({required this.remoteConfigService});

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CoachesCubit(widget.remoteConfigService)..loadCoaches(),
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            CoachesPage(),
            HistoryPage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (i) => setState(() => _selectedIndex = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people),
              label: 'Coaches',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: 'History',
            ),
          ],
        ),
      ),
    );
  }
}
