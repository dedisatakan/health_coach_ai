import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/hive_service.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

  void loadHistory() {
    final sessions = HiveService.sessionsBox.values.toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    emit(HistoryLoaded(sessions));
  }
}
