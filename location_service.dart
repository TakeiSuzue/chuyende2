import 'package:geolocator/geolocator.dart';

class LocationService {
  // Hàm lấy vị trí hiện tại
  static Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Kiểm tra xem GPS của máy có đang bật không
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return "GPS đang tắt";
    }

    // 2. Kiểm tra quyền truy cập
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return "Quyền bị từ chối";
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return "Quyền bị từ chối vĩnh viễn";
    }

    // 3. Lấy tọa độ
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );
      return "${position.latitude.toStringAsFixed(3)}, ${position.longitude.toStringAsFixed(3)}";
    } catch (e) {
      return "Không thể lấy vị trí";
    }
  }
}