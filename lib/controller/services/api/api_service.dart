import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trade_with_shaw/model/user.dart';
import 'package:trade_with_shaw/model/feed.dart';
import 'package:trade_with_shaw/model/signal.dart';

class ApiService {
  // IMPORTANT: Replace with your machine's local IP address so your device/emulator can reach the backend
  static const String baseUrl =
      'http://192.168.18.116:3000/api'; // <-- Set your local IP here

  String? _token;
  String? get token => _token;

  void updateToken(String? token) {
    _token = token;
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // Auth
  Future<User> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/user/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      updateToken(data['token']);
      return User.fromJson(data['user']);
    } else {
      throw Exception(jsonDecode(res.body)['error'] ?? 'Login failed');
    }
  }

  Future<User> register(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/user/signup'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      updateToken(data['token']);
      return User.fromJson(data['user']);
    } else {
      throw Exception(jsonDecode(res.body)['error'] ?? 'Registration failed');
    }
  }

  // Feed
  Future<List<Feed>> fetchFeed() async {
    final res = await http.get(Uri.parse('$baseUrl/feed'), headers: _headers);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Feed.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch feed');
    }
  }

  Future<Feed> likeFeed(String feedId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/feed/$feedId/like'),
      headers: _headers,
    );
    if (res.statusCode == 200) {
      return Feed.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to like feed');
    }
  }

  // Post a comment to a feed post
  Future<Feed> postComment(String feedId, String text) async {
    final res = await http.post(
      Uri.parse('$baseUrl/feed/$feedId/comment'),
      headers: _headers,
      body: jsonEncode({'text': text}),
    );
    if (res.statusCode == 200) {
      return Feed.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to post comment');
    }
  }

  // Signals
  Future<List<Signal>> fetchSignals() async {
    final res = await http.get(
      Uri.parse('$baseUrl/signals'),
      headers: _headers,
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Signal.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch signals');
    }
  }
}
