import 'package:fetchingburulasapi/api/burulas_api.dart';
import 'package:fetchingburulasapi/bloc/bus_direction_bloc/bus_direction_event.dart';
import 'package:fetchingburulasapi/bloc/bus_direction_bloc/bus_direction_state.dart';
import 'package:fetchingburulasapi/models/bus_stop.dart';
import 'package:fetchingburulasapi/utils/cache_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusDirectionBloc extends Bloc<BusDirectionEvent, BusDirectionState> {
  BusDirectionBloc() : super(BusDirectionState()) {
    on<BusDirectionFetch>(_mapDirectonFetchToState);
  }

  void _mapDirectonFetchToState(BusDirectionFetch event, Emitter<BusDirectionState> emit) async {
    emit(state.copyWith(status: "loading"));
    try {
      final cacheBusStops = CacheManager.getDirections();
      List<BusStop> busStops = [];
      if (cacheBusStops.isNotEmpty && CacheManager.getHatId() == event.busId && busStops.map((element) => element.routeDirection).contains(event.direction)) {
        busStops = cacheBusStops.firstWhere((element) => element.direction == event.direction).busStops;
      } else {
        final busStopsAll = (await BurulasApi.getBusStopsFromBus(event.busId));
        CacheManager.setDirections([
          Direction(
              direction: "G",
              busId: event.busId,
              busStops: busStopsAll.where((element) => element.routeDirection == "G").toList()
          ),
          Direction(
              direction: "D",
              busId: event.busId,
              busStops: busStopsAll.where((element) => element.routeDirection == "D").toList()
          ),
        ]);
        busStops = busStopsAll.where((element) => element.routeDirection == event.direction).toList();
        CacheManager.setHatId(event.busId);
      }
      emit(state.copyWith(
          direction: event.direction,
          kalkisDurak: busStops.first.stopName,
          status: "success"
      ));
    } catch (e) {
      state.copyWith(status: "error");
    }
  }
}