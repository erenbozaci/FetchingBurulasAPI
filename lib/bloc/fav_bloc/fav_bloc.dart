
import 'package:fetchingburulasapi/bloc/fav_bloc/fav_event.dart';
import 'package:fetchingburulasapi/bloc/fav_bloc/fav_state.dart';
import 'package:fetchingburulasapi/models/bus_route.dart';
import 'package:fetchingburulasapi/storage/favorites_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavBloc extends Bloc<FavEvent, FavState> {
  final FavoritesDB favDB;
  FavBloc({ required this.favDB }) : super(const FavState()) {
    on<FavAdd>(_mapFavAddEventToState);
    on<FavRemove>(_mapFavRemoveEventState);
    on<FavChangeOrder>(_mapFavChangeOrderEventToState);
  }

  void _mapFavAddEventToState(FavAdd event, Emitter<FavState> emit) async {
    emit(state.copyWith(status: FavStatus.loading));
    try {
      await favDB.addFavorite(BusRoute.fromFavBus(event.favBus));
      emit(
        state.copyWith(
          status: FavStatus.success,
          favList: (await favDB.getFavoritesAllList())
        ),
      );
    } catch (error, stacktrace) {
      emit(state.copyWith(status: FavStatus.error));
    }
  }

  void _mapFavRemoveEventState(FavRemove event, Emitter<FavState> emit) async {
    emit(state.copyWith(status: FavStatus.loading));
    try {
      await favDB.deleteFavorite(BusRoute.fromFavBus(event.favBus).hatId);
      emit(
        state.copyWith(
            status: FavStatus.success,
            favList: (await favDB.getFavoritesAllList())
        ),
      );
    } catch (error, stacktrace) {
      emit(state.copyWith(status: FavStatus.error));
    }
  }

  void _mapFavChangeOrderEventToState(FavChangeOrder event, Emitter<FavState> emit) async {
    emit(state.copyWith(status: FavStatus.loading));
    try {
      await favDB.updateOrders(event.orderList);
      emit(
        state.copyWith(
            status: FavStatus.success,
            favList: (await favDB.getFavoritesAllList())
        ),
      );
    } catch (error, stacktrace) {
      emit(state.copyWith(status: FavStatus.error));
    }
  }

}