import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

abstract class ApiClient {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});
  Future<dynamic> post(String path, {dynamic data});
}

class ApiClientImpl implements ApiClient {
  final Dio _dio;
  final Logger _logger;

  ApiClientImpl(this._dio, this._logger) {
    _configureDio();
  }

  void _configureDio() {
    _dio
      ..options.baseUrl = ApiConstants.baseUrl
      ..options.connectTimeout = ApiConstants.connectTimeout
      ..options.receiveTimeout = ApiConstants.receiveTimeout
      ..options.headers = ApiConstants.headers;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
          _logger.d('Query Parameters: ${options.queryParameters}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _logger.e('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          _logger.e('Error Response: ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );
  }

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      throw UnknownException(e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      throw UnknownException(e.toString(), stackTrace: stackTrace);
    }
  }

  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else if (response.statusCode == 400) {
      final errorMsg = response.data is Map
          ? response.data['message']?.toString() ?? response.data.toString()
          : response.data.toString();
      throw ServerException('API Error 400: $errorMsg', code: '400');
    } else {
      throw ServerException(
        'Server error: ${response.statusMessage}',
        code: response.statusCode.toString(),
      );
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please check your internet connection.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data is Map
            ? error.response?.data['message'] ?? 'Unknown error'
            : 'Unknown error';

        if (statusCode == 404) {
          return ServerException('Resource not found', code: '404');
        } else if (statusCode == 500) {
          return ServerException('Internal server error', code: '500');
        } else {
          return ServerException(message.toString(), code: statusCode.toString());
        }

      case DioExceptionType.cancel:
        return NetworkException('Request was cancelled');

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return NetworkException('No internet connection');
        }
        return UnknownException(error.message ?? 'Unknown error occurred');

      default:
        return UnknownException(error.message ?? 'Something went wrong');
    }
  }
}