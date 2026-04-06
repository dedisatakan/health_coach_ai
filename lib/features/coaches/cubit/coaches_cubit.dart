import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/remote_config_service.dart';
import 'coaches_state.dart';

class CoachesCubit extends Cubit<CoachesState> {
  final RemoteConfigService _remoteConfigService;

  CoachesCubit(this._remoteConfigService) : super(CoachesInitial());

  Future<void> loadCoaches() async {
    try {
      emit(CoachesLoading());
      final coaches = _remoteConfigService.getCoaches();
      emit(CoachesLoaded(coaches));
    } catch (e) {
      emit(CoachesError(e.toString()));
    }
  }
}
