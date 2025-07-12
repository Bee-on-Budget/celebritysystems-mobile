import 'package:jwt_decoder/jwt_decoder.dart';

class TokenService {
  final String token;

  TokenService(this.token);

  Map<String, dynamic> get claims => JwtDecoder.decode(token);

  /*
  If the token has a valid format, you will get a Map<String, dynamic>
  Your decoded token can look like:
  {
     "sub": "1234567890",
     "name": "Gustavo",
     "iat": 1516239022,
     "exp": 1516239022,
     "randomKey": "something else"
  }
  */

  bool get isExpired => JwtDecoder.isExpired(token);
  // You will get a true / false response
  // true: if the token is already expired
  // false: if the token is not expired

  String? get userId => claims['sub'];
  String? get username => claims['username'];
  String? get role => claims['role'];

  DateTime get expirationDate => JwtDecoder.getExpirationDate(token);
  //Get expiration date like 2025-01-13 13:04:18.000

  //You can know how old your token is
  // Token payload must include an 'iat' field
  Duration get tokenTime => JwtDecoder.getTokenTime(token);
  // 15
  // print(tokenTime.inDays);
}
