import 'dart:convert';

import 'package:clima/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const kApi = '2bb2540570ac7ba53d8c0cf08dade579';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Future<void> getLocationWeather() async {
    var url;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    url = Uri.http('api.openweathermap.org', '/data/2.5/weather', {
      'lat': '${position.latitude}',
      'lon': '${position.longitude}',
      'appid': '$kApi'
    });
    var response = await http.get(url);
    if (response.statusCode != 200) {
      temp = 0;
      cityName = '';
      condition = 1000;
      return;
    } else {
      var data = await jsonDecode(response.body);
      double temperature = data['main']['temp'] - 273.15;
      temp = temperature.toInt();
      cityName = data['name'];
    }
  }

  Future<void> getCityWeather(String cityN) async {
    var url = Uri.http('api.openweathermap.org', '/data/2.5/weather',
        {'q': '$cityN', 'appid': '$kApi'});
    var response = await http.get(url);
    if (response.statusCode == 400) {
      temp = 0;
      cityName = 'error';
      condition = 1000;
      return;
    } else {
      var data = await jsonDecode(response.body);
      double temperature = data['main']['temp'] - 273.15;
      temp = temperature.toInt();
      cityName = data['name'];
      condition = data['weather'][0]['id'];
    }
  }

  int condition = 0;
  String cityName = 'no city';
  int temp = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getLocationWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black38,
        body: SafeArea(
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/weather_background.jpg'),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          getLocationWeather();
                        });
                      },
                      child: Icon(
                        Icons.near_me,
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          var cityName = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return City();
                              },
                            ),
                          );
                          setState(() {
                            if (cityName != null) {
                              getCityWeather(cityName);
                            }
                          });
                        },
                        child: Icon(Icons.location_city,
                            color: Colors.white, size: 50.0)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    '${getWeatherIcon(condition)} $temp° in $cityName',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Text(
                    getMessage(temp),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getWeatherIcon(int condition) {
    if (condition == 1000) {
      return 'there is an error';
    } else if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp == 0) {
      return 'no temp';
    } else if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
