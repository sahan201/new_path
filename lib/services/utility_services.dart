// lib/services/utility_services.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Weather Service
class WeatherService {
  static final WeatherService _instance = WeatherService._internal();
  factory WeatherService() => _instance;
  WeatherService._internal();

  // Replace with actual API key
  static const String _apiKey = 'YOUR_OPENWEATHER_API_KEY';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<WeatherData?> getCurrentWeather(String location) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/weather?q=$location&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        return WeatherData.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching weather: $e');
      return null;
    }
  }

  Future<List<ForecastData>> getForecast(String location, {int days = 5}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/forecast?q=$location&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list = data['list'] as List;
        return list
            .take(days * 8) // 8 forecasts per day (3-hour intervals)
            .map((item) => ForecastData.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching forecast: $e');
      return [];
    }
  }
}

class WeatherData {
  final double temperature;
  final String description;
  final String icon;
  final double feelsLike;
  final int humidity;
  final double windSpeed;

  WeatherData({
    required this.temperature,
    required this.description,
    required this.icon,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}

class ForecastData {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;

  ForecastData({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}

// Currency Converter Service
class CurrencyService {
  static final CurrencyService _instance = CurrencyService._internal();
  factory CurrencyService() => _instance;
  CurrencyService._internal();

  // Replace with actual API key
  static const String _apiKey = 'YOUR_EXCHANGERATE_API_KEY';
  static const String _baseUrl = 'https://v6.exchangerate-api.com/v6';

  Map<String, double> _exchangeRates = {};
  DateTime? _lastUpdate;

  Future<bool> updateRates(String baseCurrency) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$_apiKey/latest/$baseCurrency'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _exchangeRates = Map<String, double>.from(
          data['conversion_rates'].map((k, v) => MapEntry(k, v.toDouble())),
        );
        _lastUpdate = DateTime.now();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating exchange rates: $e');
      return false;
    }
  }

  double convert({
    required double amount,
    required String from,
    required String to,
  }) {
    if (_exchangeRates.isEmpty) {
      return amount; // Return original if rates not loaded
    }

    final fromRate = _exchangeRates[from] ?? 1.0;
    final toRate = _exchangeRates[to] ?? 1.0;

    return (amount / fromRate) * toRate;
  }

  Map<String, double> get exchangeRates => Map.from(_exchangeRates);
  DateTime? get lastUpdate => _lastUpdate;

  // Popular currencies
  static const List<String> popularCurrencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'CNY', 'AUD', 'CAD', 'CHF', 'INR', 'SGD'
  ];
}

// Translation Service
class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  // Replace with actual API key (Google Translate API)
  static const String _apiKey = 'YOUR_GOOGLE_TRANSLATE_API_KEY';
  static const String _baseUrl = 'https://translation.googleapis.com/language/translate/v2';

  Future<String?> translate({
    required String text,
    required String targetLanguage,
    String sourceLanguage = 'auto',
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'q': text,
          'target': targetLanguage,
          if (sourceLanguage != 'auto') 'source': sourceLanguage,
          'key': _apiKey,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['translations'][0]['translatedText'];
      }
      return null;
    } catch (e) {
      debugPrint('Error translating: $e');
      return null;
    }
  }

  Future<String?> detectLanguage(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/detect'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'q': text,
          'key': _apiKey,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['detections'][0][0]['language'];
      }
      return null;
    } catch (e) {
      debugPrint('Error detecting language: $e');
      return null;
    }
  }

  // Common language codes
  static const Map<String, String> languages = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'it': 'Italian',
    'pt': 'Portuguese',
    'zh': 'Chinese',
    'ja': 'Japanese',
    'ko': 'Korean',
    'ar': 'Arabic',
    'hi': 'Hindi',
    'ru': 'Russian',
  };
}

// Emergency Contacts Service
class EmergencyService {
  static final EmergencyService _instance = EmergencyService._internal();
  factory EmergencyService() => _instance;
  EmergencyService._internal();

  EmergencyContacts getContactsByCountry(String countryCode) {
    return _emergencyContacts[countryCode] ?? _emergencyContacts['default']!;
  }

  // Emergency contacts by country
  static final Map<String, EmergencyContacts> _emergencyContacts = {
    'default': EmergencyContacts(
      police: '911',
      ambulance: '911',
      fire: '911',
      touristPolice: null,
      embassy: null,
    ),
    'US': EmergencyContacts(
      police: '911',
      ambulance: '911',
      fire: '911',
      touristPolice: null,
      embassy: null,
    ),
    'UK': EmergencyContacts(
      police: '999',
      ambulance: '999',
      fire: '999',
      touristPolice: null,
      embassy: null,
    ),
    'ID': EmergencyContacts(
      police: '110',
      ambulance: '118',
      fire: '113',
      touristPolice: '1500',
      embassy: null,
    ),
    'JP': EmergencyContacts(
      police: '110',
      ambulance: '119',
      fire: '119',
      touristPolice: null,
      embassy: null,
    ),
    'FR': EmergencyContacts(
      police: '17',
      ambulance: '15',
      fire: '18',
      touristPolice: null,
      embassy: null,
    ),
  };
}

class EmergencyContacts {
  final String police;
  final String ambulance;
  final String fire;
  final String? touristPolice;
  final String? embassy;

  EmergencyContacts({
    required this.police,
    required this.ambulance,
    required this.fire,
    this.touristPolice,
    this.embassy,
  });
}

// Common phrases for travelers
class CommonPhrases {
  static const Map<String, Map<String, String>> phrases = {
    'greetings': {
      'hello': 'Hello',
      'goodbye': 'Goodbye',
      'thank_you': 'Thank you',
      'please': 'Please',
      'yes': 'Yes',
      'no': 'No',
    },
    'directions': {
      'where_is': 'Where is...?',
      'how_far': 'How far is...?',
      'left': 'Left',
      'right': 'Right',
      'straight': 'Straight ahead',
    },
    'emergency': {
      'help': 'Help!',
      'emergency': 'Emergency!',
      'doctor': 'I need a doctor',
      'police': 'Call the police',
    },
    'dining': {
      'menu': 'Menu please',
      'bill': 'Check please',
      'water': 'Water',
      'vegetarian': 'I am vegetarian',
    },
  };
}