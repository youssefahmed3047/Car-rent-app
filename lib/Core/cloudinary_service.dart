import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  final String cloudName = "ds5krnrdy";
  final String uploadPreset = "Booking Car app";

  Future<String?> uploadToCloudinary(XFile imageFile) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest("POST", url);

    request.fields['upload_preset'] = uploadPreset;

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final imageUrl = RegExp(
        r'"secure_url":"(.*?)"',
      ).firstMatch(res.body)?.group(1);

      return imageUrl;
    } else {
      return null;
    }
  }

  Future<List<String>> uploadImages(List<XFile> images) async {
    List<String> urls = [];

    for (XFile img in images) {
      final url = await uploadToCloudinary(img);

      if (url != null) {
        urls.add(url);
      }
    }

    return urls;
  }
}
