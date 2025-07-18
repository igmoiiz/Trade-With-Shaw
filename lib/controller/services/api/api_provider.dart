import 'package:flutter/material.dart';
import 'package:trade_with_shaw/model/user.dart';
import 'package:trade_with_shaw/model/feed.dart';
import 'package:trade_with_shaw/model/signal.dart';
import 'api_service.dart';

// Usage:
// Wrap your app with ChangeNotifierProvider(
//   create: (_) => ApiProvider(),
//   child: MyApp(),
// )
//
// Access with: Provider.of<ApiProvider>(context, listen: false)
//
// Add provider to pubspec.yaml: provider: ^6.0.0
//
// import 'package:provider/provider.dart';

class ApiProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  User? _user;
  List<Feed> _feed = [];
  List<Signal> _signals = [];
  bool _loading = false;
  String? _error;

  User? get user => _user;
  List<Feed> get feed => _feed;
  List<Signal> get signals => _signals;
  bool get loading => _loading;
  String? get error => _error;
  bool get isPremium => _user?.isPremium ?? false;

  Future<void> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _apiService.login(email, password);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _apiService.register(email, password);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    _feed = [];
    _signals = [];
    _apiService.updateToken(null);
    notifyListeners();
  }

  Future<void> fetchFeed() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _feed = await _apiService.fetchFeed();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> likeFeed(String feedId) async {
    try {
      final updated = await _apiService.likeFeed(feedId);
      final idx = _feed.indexWhere((f) => f.id == feedId);
      if (idx != -1) {
        _feed[idx] = updated;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchSignals() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _signals = await _apiService.fetchSignals();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Simulate payment and upgrade to premium
  Future<void> upgradeToPremium() async {
    if (_user != null) {
      _user = User(id: _user!.id, email: _user!.email, isPremium: true);
      notifyListeners();
    }
  }
}
