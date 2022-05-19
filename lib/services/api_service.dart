import 'package:water_tracker/network/api_client.dart';

const String postsPath = '/posts';

class ApiService {
  late ApiClient _apiClient;

  ApiService(String baseApiUrl) {
    _apiClient = ApiClient(baseApiUrl: baseApiUrl);
  }

  /// Example HTTP request usage with params:
  ///       final res = await _apiClient.get('/comments', params: {
  ///         'postId': '1',
  ///       });
}
