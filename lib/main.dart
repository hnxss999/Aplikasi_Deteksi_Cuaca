import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? true;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cuaca Pro',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0),
      ),
      themeMode: _themeMode,
      home: WeatherScreen(onThemeChanged: _toggleTheme),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  final VoidCallback onThemeChanged;

  const WeatherScreen({super.key, required this.onThemeChanged});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String apiKey = '46907330d53b8f64b36c40e863777c44';
  String city = 'Jakarta';
  Map<String, dynamic>? currentWeatherData;
  List<dynamic> forecastData = [];
  bool isLoading = false;
  String? errorMessage;
  List<String> favoriteCities = [];
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _getCurrentLocation();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteCities = prefs.getStringList('favorites') ?? [];
    });
    _checkIfFavorite();
  }

  void _checkIfFavorite() {
    setState(() {
      isFavorite = favoriteCities
          .any((element) => element.toLowerCase() == city.toLowerCase());
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (isFavorite) {
        favoriteCities
            .removeWhere((item) => item.toLowerCase() == city.toLowerCase());
        isFavorite = false;
      } else {
        favoriteCities.add(city);
        isFavorite = true;
      }
      prefs.setStringList('favorites', favoriteCities);
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _fetchWeatherByCity('Jakarta');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _fetchWeatherByCity('Jakarta');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _fetchWeatherByCity('Jakarta');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _fetchWeatherByCoordinates(position.latitude, position.longitude);
    } catch (e) {
      _fetchWeatherByCity('Jakarta');
    }
  }

  Future<void> _fetchWeatherByCoordinates(double lat, double lon) async {
    final weatherUrl = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=id');
    final forecastUrl = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=id');

    await _performFetch(weatherUrl, forecastUrl);
  }

  Future<void> _fetchWeatherByCity(String cityName) async {
    // URL untuk mencari berdasarkan NAMA KOTA (pakai q=...)
    final weatherUrl = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric&lang=id');
        
    final forecastUrl = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric&lang=id');

    await _performFetch(weatherUrl, forecastUrl);
  }

  Future<void> _performFetch(Uri weatherUrl, Uri forecastUrl) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final weatherRes = await http.get(weatherUrl);
      final forecastRes = await http.get(forecastUrl);

      if (weatherRes.statusCode == 200 && forecastRes.statusCode == 200) {
        final wData = json.decode(weatherRes.body);
        final fData = json.decode(forecastRes.body);
        final List fList = fData['list'];

        setState(() {
          currentWeatherData = wData;
          city = wData['name'];
          forecastData = fList.where((item) {
            return item['dt_txt'].toString().contains('12:00:00');
          }).toList();
          isLoading = false;
          _checkIfFavorite();
        });
      } else {
        throw Exception('Gagal memuat data. Cek nama kota / koneksi.');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('HH:mm').format(DateTime.now());
    String formattedDate =
        DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // DEFINISI WARNA GRADASI
    List<Color> bgGradient = isDark
        ? [const Color(0xFF0f2027), const Color(0xFF203a43), const Color(0xFF2c5364)]
        : [const Color(0xFF4FACFE), const Color(0xFF00F2FE)];

    Color glassColor = isDark ? Colors.black38 : Colors.white30;
    // PERBAIKAN 1: Variabel textColor dihapus karena tidak digunakan
    Color subTextColor = Colors.white70;

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: _buildDrawer(isDark),
      appBar: AppBar(
        title: Text(city, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            color: isFavorite ? Colors.pinkAccent : Colors.white,
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            color: Colors.white,
            onPressed: widget.onThemeChanged,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: bgGradient,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          child: Column(
            children: [
              // INPUT PENCARIAN
              Container(
                decoration: BoxDecoration(
                  color: glassColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white24),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari kota...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.my_location, color: Colors.white),
                      onPressed: _getCurrentLocation,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (value) => _fetchWeatherByCity(value),
                ),
              ),

              const SizedBox(height: 30),

              // KONTEN UTAMA
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : errorMessage != null
                        ? Center(
                            child: Text(errorMessage!,
                                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)))
                        : currentWeatherData == null
                            ? const Center(
                                child: Text('Cari kota untuk mulai',
                                    style: TextStyle(color: Colors.white)))
                            : ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  // INFO UTAMA
                                  Column(
                                    children: [
                                      Text(formattedDate,
                                          style: TextStyle(color: subTextColor, fontSize: 16)),
                                      const SizedBox(height: 5),
                                      Text(formattedTime,
                                          style: const TextStyle(
                                            fontSize: 45,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          )),
                                      
                                      // Icon Cuaca
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              // PERBAIKAN 2: Menggunakan .withValues() sebagai pengganti .withOpacity()
                                              color: Colors.white.withValues(alpha: 0.2), 
                                              blurRadius: 50,
                                              spreadRadius: 10,
                                            )
                                          ]
                                        ),
                                        child: Image.network(
                                          'https://openweathermap.org/img/wn/${currentWeatherData!['weather'][0]['icon']}@4x.png',
                                          scale: 0.6,
                                        ),
                                      ),

                                      Text(
                                        '${currentWeatherData!['main']['temp'].toStringAsFixed(1)}°',
                                        style: const TextStyle(
                                          fontSize: 80,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 0.8
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        currentWeatherData!['weather'][0]['description']
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.w500,
                                            color: subTextColor),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 40),
                                  
                                  // Detail Tambahan
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildInfoItem(Icons.water_drop, "${currentWeatherData!['main']['humidity']}%", "Kelembapan"),
                                      _buildInfoItem(Icons.air, "${currentWeatherData!['wind']['speed']} m/s", "Angin"),
                                    ],
                                  ),

                                  const SizedBox(height: 40),

                                  // LABEL FORECAST
                                  const Text("Prediksi 5 Hari (12:00)",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  
                                  const SizedBox(height: 15),

                                  // LIST PREDIKSI HORIZONTAL
                                  SizedBox(
                                    height: 160,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: forecastData.length,
                                      itemBuilder: (context, index) {
                                        final dayData = forecastData[index];
                                        final dateObj = DateTime.parse(dayData['dt_txt']);
                                        final dayName = DateFormat('EEE', 'id_ID').format(dateObj); 
                                        final temp = dayData['main']['temp'].toStringAsFixed(0);
                                        final icon = dayData['weather'][0]['icon'];

                                        return Container(
                                          width: 90,
                                          margin: const EdgeInsets.only(right: 12),
                                          decoration: BoxDecoration(
                                            color: glassColor, 
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: Colors.white12),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(dayName,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white, fontSize: 16)),
                                              const SizedBox(height: 5),
                                              Image.network(
                                                  'https://openweathermap.org/img/wn/$icon.png', scale: 0.8,),
                                              const SizedBox(height: 5),
                                              Text('$temp°',
                                                  style: const TextStyle(
                                                      fontSize: 20, 
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 28),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildDrawer(bool isDark) {
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1c1c1c) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark 
                  ? [const Color(0xFF0f2027), const Color(0xFF2c5364)]
                  : [const Color(0xFF4FACFE), const Color(0xFF00F2FE)]
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_circle, size: 60, color: Colors.white),
                SizedBox(height: 10),
                Text("Lokasi Favorit",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (favoriteCities.isEmpty)
             ListTile(
               leading: const Icon(Icons.info_outline),
               title: Text("Belum ada kota favorit", style: TextStyle(color: isDark ? Colors.white : Colors.black))
             ),
          ...favoriteCities.map((savedCity) => ListTile(
                leading: Icon(Icons.location_city, color: isDark ? Colors.blueAccent : Colors.blue),
                title: Text(savedCity, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _fetchWeatherByCity(savedCity);
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      favoriteCities.remove(savedCity);
                      prefs.setStringList('favorites', favoriteCities);
                      if (city == savedCity) isFavorite = false;
                    });
                  },
                ),
              )),
        ],
      ),
    );
  }
}