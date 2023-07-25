import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictorService {
  final predictorUrl = 'https://eightballapi.com/api';

  Future<String?> getPrediction() async {
    String? prediction;
    try {
      final http.Response response = await http.get(
        Uri.parse(predictorUrl),
      );
      switch (response.statusCode) {
        case 200:
          final result = json.decode(response.body);

          prediction = result['reading'];
        default:
          return prediction;
      }
    } catch (e) {
      return prediction;
    }

    return prediction;
  }
}
