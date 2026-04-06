import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../../features/coaches/data/models/coach.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _remoteConfig.fetchAndActivate();
  }

  List<Coach> getCoaches() {
    return [
      Coach(
        id: 'dietitian',
        name: 'Dr. Ayşe',
        specialty: 'Dietitian',
        persona: _remoteConfig.getString('dietitian_prompt'),
        avatarEmoji: '🥗',
      ),
      Coach(
        id: 'fitness',
        name: 'Coach Mert',
        specialty: 'Fitness Coach',
        persona: _remoteConfig.getString('fitness_coach_prompt'),
        avatarEmoji: '💪',
      ),
      Coach(
        id: 'pilates',
        name: 'İnstructor Selin',
        specialty: 'Pilates Instructor',
        persona: _remoteConfig.getString('pilates_instructor_prompt'),
        avatarEmoji: '🧘',
      ),
      Coach(
        id: 'yoga',
        name: 'Guru Deniz',
        specialty: 'Yoga Teacher',
        persona: _remoteConfig.getString('yoga_teacher_prompt'),
        avatarEmoji: '🪷',
      ),
    ];
  }
}
