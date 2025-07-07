import 'package:dio/dio.dart';
import 'package:ministore/dio/baseDio.dart';
import 'package:ministore/dio/models/shelf_model.dart';
import 'package:ministore/dio/models/shelve_model.dart';
import 'package:retrofit/retrofit.dart';

part 'shelves_service.g.dart';

@RestApi()
abstract class ShelvesService {
  factory ShelvesService({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ShelvesService(dio, baseUrl: baseUrl ?? BaseDio.baseUrl);
  }

  // List shelves, optional section_id param
  @GET("/shelves")
  Future<ShelvesListResp> getShelves(@Query("section_id") String? sectionId);

  // Get shelf details
  @GET("/shelves/{id}")
  Future<ShelveResp> getShelveById(@Path("id") String id);

  // Create shelf
  @POST("/shelves")
  Future<Shelf> createShelf(@Body() Map<String, dynamic> body);

  // Update shelf
  @PUT("/shelves/{id}")
  Future<Shelf> updateShelf(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  // Delete shelf
  @DELETE("/shelves/{id}")
  Future<void> deleteShelf(@Path("id") String id);
}
