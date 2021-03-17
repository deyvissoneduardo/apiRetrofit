import 'package:apiretrofit/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'user_respository.g.dart';

@RestApi(baseUrl: 'https://60520671fb49dc00175b75e4.mockapi.io/api/')
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @GET('/users')
  Future<List<UserModel>> findAll();

  @GET('/users/{id}')
  Future<UserModel> findById(@Path('id') String id);

  @POST('/users')
  Future<void> save(@Body() UserModel user);
}
