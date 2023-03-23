import 'dart:io';

import 'package:http_parser/http_parser.dart';

import 'config_service.dart';
import 'package:http/http.dart' as http;
// import 'package:cloudinary_public/cloudinary_public.dart';

class FileUploadService {
  final String _baseUrl = ConfigService.baseUrl;
  uploadFile(file, folder, name, {onDone, onProg}) async {
    var url = '${_baseUrl}fileupload/$folder/$name';
    bool iscloud =
        RegExp(r'(.jpg|.png|.jpeg)$', caseSensitive: false).hasMatch(file.path);
    // if (iscloud) {
    //   url = 'https://api.cloudinary.com/v1_1/echeckout/image/upload';
    //   final cloudinary =
    //       CloudinaryPublic('echeckout', 'zbxotydn', cache: false);
    //   final res = await cloudinary.uploadFile(
    //     CloudinaryFile.fromFile(
    //       file.path,
    //     ),
    //     // onProgress: (count, total) {
    //     //   onProg(count, total);
    //     //   // setState(() {
    //     //   //   _uploadingPercentage = (count / total) * 100;
    //     //   // });
    //     // },
    //   );
    //   onDone(res);
    //   return;
    // }
    var postUri = Uri.parse(url);
    var request = http.MultipartRequest("POST", postUri);
    // if (iscloud) {
    //   request.fields['api_key'] = '294546853684684';
    //   request.fields['upload_preset'] = 'zbxotydn';
    // }
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      await File(file.path).readAsBytes(),
      filename: name,
    ));
    request.send().then((response) async {
      var res = await http.Response.fromStream(response);
      if (res.statusCode == 200) {
        onDone(res.body);
      } else {
        print(res.body);
      }
    });
  }
}
