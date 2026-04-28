import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/trip_repository.dart';
import 'trip_event.dart';
import 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final TripRepository _repo;

  TripBloc(this._repo) : super(const TripInitial()) {
    on<LoadTrips>(_onLoad);
    on<RefreshTrips>(_onRefresh);
  }

  Future<void> _onLoad(LoadTrips event, Emitter<TripState> emit) async {
    emit(const TripLoading());
    await _fetch(emit);
  }

  Future<void> _onRefresh(RefreshTrips event, Emitter<TripState> emit) async {
    await _fetch(emit);
  }

  Future<void> _fetch(Emitter<TripState> emit) async {
    try {
      final result = await _repo.getTripList();
      debugPrint('=== Trips loaded: upcoming=${result.upcoming.length}, '
          'ongoing=${result.ongoing.length}, completed=${result.completed.length}, '
          'rejected=${result.rejected.length} ===');
      emit(TripsLoaded(result));
    } catch (e) {
      debugPrint('TripBloc fetch error: $e');
      emit(TripError('Failed to load trips. Check your connection.'));
    }
  }
}
