import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:mywine/shelf.dart';

class RekognizeProvider {
  static Future<AutoRefreshingAuthClient> _client =
      CredentialsProvider().client;

  static Future<BatchAnnotateImagesResponse> search(String image) async {
    var _vision = VisionApi(await _client);
    var _api = _vision.images;
    var _response = await _api.annotate(BatchAnnotateImagesRequest.fromJson({
      "requests": [
        {
          "image": {"content": image},
          "features": [
            {
              "type": "DOCUMENT_TEXT_DETECTION",
            }
          ]
        }
      ]
    }));

    return _response;
  }
}
