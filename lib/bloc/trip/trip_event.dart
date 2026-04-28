import 'package:equatable/equatable.dart';

abstract class TripEvent extends Equatable {
  const TripEvent();
  @override
  List<Object?> get props => [];
}

class LoadTrips extends TripEvent {
  const LoadTrips();
}

class RefreshTrips extends TripEvent {
  const RefreshTrips();
}
