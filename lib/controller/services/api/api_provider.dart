import 'package:flutter/material.dart';
import 'package:trade_with_shaw/model/user.dart';
import 'package:trade_with_shaw/model/feed.dart';
import 'package:trade_with_shaw/model/signal.dart';
import 'api_service.dart';

class ApiProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  User? _user;
  List<Feed> _feed = [];
  List<Signal> _signals = [];
  bool _loading = false;
  String? _error;

  // Caching
  DateTime? _feedCacheTime;
  DateTime? _signalsCacheTime;
  static const Duration _cacheDuration = Duration(minutes: 1);

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
    _feedCacheTime = null;
    _signalsCacheTime = null;
    _apiService.updateToken(null);
    notifyListeners();
  }

  Future<void> fetchFeed({bool forceRefresh = false}) async {
    final now = DateTime.now();
    if (!forceRefresh &&
        _feed.isNotEmpty &&
        _feedCacheTime != null &&
        now.difference(_feedCacheTime!) < _cacheDuration) {
      // Use cache
      return;
    }
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final newFeed = await _apiService.fetchFeed();
      if (newFeed != _feed) {
        _feed = newFeed;
        _feedCacheTime = now;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshFeed() async {
    await fetchFeed(forceRefresh: true);
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

  Future<void> fetchSignals({bool forceRefresh = false}) async {
    final now = DateTime.now();
    if (!forceRefresh &&
        _signals.isNotEmpty &&
        _signalsCacheTime != null &&
        now.difference(_signalsCacheTime!) < _cacheDuration) {
      // Use cache
      return;
    }
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final newSignals = await _apiService.fetchSignals();
      if (newSignals != _signals) {
        _signals = newSignals;
        _signalsCacheTime = now;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshSignals() async {
    await fetchSignals(forceRefresh: true);
  }

  Future<void> postComment(String feedId, String text) async {
    try {
      final updated = await _apiService.postComment(feedId, text);
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

  // Simulate payment and upgrade to premium
  Future<void> upgradeToPremium() async {
    if (_user != null) {
      _user = User(id: _user!.id, email: _user!.email, isPremium: true);
      notifyListeners();
    }
  }
}
