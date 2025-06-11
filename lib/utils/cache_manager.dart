
import 'package:fetchingburulasapi/api/burulas_api.dart';


class Direction {
  final String direction;
  final String busId;
  final BusStopList busStops;

  Direction({
    required this.direction,
    required this.busId,
    required this.busStops,
  });
}

class CacheManager {
  static String hatId = "";
  static List<Direction> directions = [];

  static void setDirections(List<Direction> newDirection) {
    directions = newDirection;
  }
  static List<Direction> getDirections() {
    return directions;
  }
  static void setHatId(String newHatId) {
    hatId = newHatId;
  }
  static String getHatId() {
    return hatId;
  }

}