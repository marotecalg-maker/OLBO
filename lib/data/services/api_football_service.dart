import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/match.dart';
import '../models/standing.dart';
import '../models/league.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiFootballService {
  final Dio _dio = DioClient.instance;

  Future<List<Match>> _fetchMatches(String path) async {
    try {
      final response = await _dio.get(path);
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ApiException(body['message'] as String? ?? 'Request failed');
      }
      final raw = body['data'] as List<dynamic>? ?? [];
      return raw
          .map((e) => Match.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<Match>> getLiveMatches() => _fetchMatches(ApiConstants.live);
  Future<List<Match>> getTodayMatches() => _fetchMatches(ApiConstants.today);
  Future<List<Match>> getYesterdayMatches() =>
      _fetchMatches(ApiConstants.yesterday);
  Future<List<Match>> getTomorrowMatches() =>
      _fetchMatches(ApiConstants.tomorrow);

  Future<List<LeagueStandings>> getStandings() async {
    try {
      final response = await _dio.get(ApiConstants.standings);
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ApiException(body['message'] as String? ?? 'Request failed');
      }
      final raw = body['data'] as List<dynamic>? ?? [];
      return raw
          .map((e) => LeagueStandings.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<LeagueStandings?> getLeagueStandings(int leagueId, int season) async {
    try {
      final response =
          await _dio.get(ApiConstants.standingsByLeague(leagueId, season));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ApiException(body['message'] as String? ?? 'Request failed');
      }
      final raw = body['data'] as List<dynamic>? ?? [];
      if (raw.isEmpty) return null;
      return LeagueStandings.fromJson(raw.first as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<League>> getLeagues() async {
    try {
      final response = await _dio.get(ApiConstants.leagues);
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ApiException(body['message'] as String? ?? 'Request failed');
      }
      final raw = body['data'] as List<dynamic>? ?? [];
      return raw
          .map((e) => League.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get(ApiConstants.health);
      final body = response.data as Map<String, dynamic>;
      return body['success'] == true;
    } catch (_) {
      return false;
    }
  }

  ApiException _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException('Request timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const ApiException(
            'No internet connection. Please check your network.');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        return ApiException(
          'Server error (${code ?? 'unknown'}). Please try again later.',
          statusCode: code,
        );
      default:
        return const ApiException('Something went wrong. Please try again.');
    }
  }
}
