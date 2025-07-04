import 'package:dio/dio.dart';
import 'package:ministore/dio/baseDio.dart';
import 'package:ministore/dio/models/section_model.dart';
import 'package:ministore/dio/models/shelf_model.dart';
import 'package:retrofit/retrofit.dart';

part 'section_service.g.dart';

@RestApi()
abstract class SectionService {
  factory SectionService({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SectionService(dio, baseUrl: baseUrl ?? BaseDio.baseUrl);
  }

  @GET("/sections")
  Future<SectionListResp> getSections();

  @GET("/sections/{id}")
  Future<Section> getSectionById(@Path("id") String id);

  @POST("/sections")
  Future<Section> createSection(@Body() Map<String, dynamic> body);

  @PUT("/sections/{id}")
  Future<Section> updateSection(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE("/sections/{id}")
  Future<void> deleteSection(@Path("id") String id);

  @POST("/sections/{id}/shelves")
  Future<Shelf> createShelfInSection(
    @Path("id") String sectionId,
    @Body() Map<String, dynamic> body,
  );
}
