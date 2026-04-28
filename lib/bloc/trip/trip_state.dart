import 'package:equatable/equatable.dart';
import '../../model/trip_model.dart';

abstract class TripState extends Equatable {
  const TripState();
  @override
  List<Object?> get props => [];
}

class TripInitial extends TripState {
  const TripInitial();
}

class TripLoading extends TripState {
  const TripLoading();
}

class TripsLoaded extends TripState {
  final TripListResult result;
  const TripsLoaded(this.result);
  @override
  List<Object?> get props => [result.totalCount];
}

class TripError extends TripState {
  final String message;
  const TripError(this.message);
  @override
  List<Object?> get props => [message];
}
