import 'package:dio/dio.dart';
import 'package:ministore/dio/baseDio.dart';
import 'package:ministore/dio/models/category_model.dart';
import 'package:ministore/dio/models/category_resp_model.dart';
import 'package:retrofit/retrofit.dart';

part 'categories_service.g.dart';

@RestApi()
abstract class CategoryService {
  factory CategoryService({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _CategoryService(dio, baseUrl: baseUrl ?? BaseDio.baseUrl);
  }

  @GET("/categories")
  Future<CategoryListResp> getCategories();

  @GET("/categories/{id}")
  Future<Category> getCategoryById(@Path("id") String id);

  @POST("/categories")
  Future<Category> createCategory(@Body() Map<String, dynamic> body);

  @PUT("/categories/{id}")
  Future<Category> updateCategory(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE("/categories/{id}")
  Future<void> deleteCategory(@Path("id") String id);
}
