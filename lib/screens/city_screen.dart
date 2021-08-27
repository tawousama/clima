import 'package:clima/screens/location_screen.dart';
import 'package:flutter/material.dart';

class City extends StatefulWidget {
  const City({Key? key}) : super(key: key);

  @override
  _CityState createState() => _CityState();
}

class _CityState extends State<City> {
  String? cityName;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black38,
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('images/city_background.jpg'),
            ),
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) {
                  cityName = value;
                },
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.location_city,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Enter City Name',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20.0,
                  ),
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black38),
                  ),
                  onPressed: () {
                    Navigator.pop(context, cityName);
                  },
                  child: Text('Get Weather')),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black38),
                  ),
                  onPressed: () {
                    Navigator.pop(context, '');
                  },
                  child: Text('Weather of My Current City'))
            ],
          ),
        ),
      ),
    );
  }
}
