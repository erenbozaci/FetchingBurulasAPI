
import 'package:equatable/equatable.dart';
import 'package:fetchingburulasapi/storage/favorites_db.dart';

enum FavStatus {init,  add, remove, success, error, loading }

extension FavStatusBool on FavStatus {
  bool get isInit => this == FavStatus.init;
  bool get isAdd => this == FavStatus.add;
  bool get isRemove => this == FavStatus.remove;
  bool get isSuccess => this == FavStatus.success;
  bool get isError => this == FavStatus.error;
  bool get isLoading => this == FavStatus.loading;
}

class FavState extends Equatable {
  final FavoritesList? favList;
  final FavoriteBus? favBus;
  final FavStatus status;

  const FavState({ this.favBus, this.favList, this.status = FavStatus.init});

  @override
  List<Object?> get props => [favList, favBus, status];

  FavState copyWith({FavoritesList? favList, FavoriteBus? favBus, FavStatus? status}) {
    return FavState(
      favList: favList ?? this.favList,
      favBus: favBus ?? this.favBus,
      status: status ?? this.status,
    );
  }
}