import 'package:equatable/equatable.dart';

class BusDirectionEvent extends Equatable {

  const BusDirectionEvent();

  @override
  List<Object> get props => [];
}

class BusDirectionFetch extends BusDirectionEvent {
  final String busId;
  final String direction;

  const BusDirectionFetch({required this.busId, this.direction = "G"});

  @override
  List<Object> get props => [busId, direction];
}