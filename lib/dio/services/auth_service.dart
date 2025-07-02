import 'package:dio/dio.dart';
import 'package:ministore/dio/baseDio.dart';
import 'package:ministore/dio/models/auth_model.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _AuthService(dio, baseUrl: baseUrl ?? BaseDio.baseUrl);
  }

  @POST("/login")
  Future<LoginResp> login(@Body() LoginReq body);

  @POST("/register")
  Future<LoginResp> register(@Body() Map<String, dynamic> body);

  @GET("/user")
  Future<User> getUser(@Header("Authorization") String token);

  @POST("/logout")
  Future<void> logout(@Header("Authorization") String token);
}
