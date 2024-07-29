import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

class Helper {
  static String getRandomId() {
    var uuid = const Uuid();
    return uuid.v6(
        config: V6Options(0x1234, DateTime.now().millisecondsSinceEpoch, 5678,
            [0x01, 0x23, 0x45, 0x67, 0x89, 0xab], null));
  }

  String getImagePathForMobileNumber(String mobileNumber) {
    try {
      // Remove any non-numeric characters from the mobile number
      final cleanedNumber = mobileNumber.replaceAll(RegExp(r'\D'), '');

      // Extract the country code and mobile code
      final countryCode = cleanedNumber.substring(0, 2);
      final mobileCode = cleanedNumber.substring(2, 5);

      // Define a map to associate mobile code prefixes with image paths
      final operatorImageMap = {
        '97150': 'assets/etisalat_logo.png',
        '97154': 'assets/etisalat_logo.png',
        '97156': 'assets/etisalat_logo.png',
        '97152': 'assets/du_logo.png',
        '97155': 'assets/du_logo.png',
        '97158': 'assets/du_logo.png',
      };

      // Return the image path based on the mobile code
      return operatorImageMap[countryCode + mobileCode] ??
          'assets/du_logo.png'; // Default image if not found
    } catch (e) {
      return 'assets/etisalat_logo.png';
    }
  }
}
