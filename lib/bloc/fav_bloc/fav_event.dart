
import 'package:equatable/equatable.dart';
import 'package:fetchingburulasapi/storage/favorites_db.dart';

class FavEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavAdd extends FavEvent {
  final FavoriteBus favBus;

  FavAdd({required this.favBus});

  @override
  List<Object?> get props => [ favBus ];
}

class FavRemove extends FavEvent {
  final FavoriteBus favBus;

  FavRemove({required this.favBus});

  @override
  List<Object?> get props => [ favBus ];
}

class FavChangeOrder extends FavEvent {
  final List orderList;

  FavChangeOrder({required this.orderList });

  @override
  List<Object?> get props => [ orderList ];
}
