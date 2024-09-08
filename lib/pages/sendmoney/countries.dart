import 'package:banktest/pages/sendmoney/sendmoneoptions.dart';
import 'package:banktest/pages/sendmoney/wallettowallet.dart';
import 'package:flutter/material.dart';

class Countries extends StatefulWidget {
  const Countries({Key? key});

  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  final List<Map<String, dynamic>> countryData = [
    {'name': 'Walet to Wallet (No cost)', 'route': '/sendmoneyuganda'},
    {'name': 'Kenya', 'route': '/sendmoneyuganda'},
    {'name': 'Uganda', 'route': '/sendmoneyuganda'},
    {'name': 'Tanzania', 'route': '/sendmoney'},
    {'name': 'Ivory Coast', 'route': '/sendmoneyuganda'},
    {'name': 'Cameroon', 'route': '/sendmoneyuganda'},
    {'name': 'Senegal', 'route': '/sendmoneyuganda'},
    {'name': 'Guinée Conakry', 'route': '/sendmoneyuganda'},
    {'name': 'Togo', 'route': '/sendmoneyuganda'},
    {'name': 'Benin', 'route': '/sendmoneyuganda'},
    {'name': 'Burkina Faso', 'route': '/sendmoneyuganda'},
    {'name': 'Mali', 'route': '/sendmoneyuganda'},
    {'name': 'Gabon', 'route': '/sendmoneyuganda'},
  ];

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredCountryData = [];

  @override
  void initState() {
    filteredCountryData = countryData;
    super.initState();
  }

  void filterCountries(String query) {
    setState(() {
      filteredCountryData = countryData
          .where((country) =>
              country['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 70, // Adjust the height as needed
              width: MediaQuery.of(context).size.width /
                  1.04, // Adjust the width as needed
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: searchController,
                  onChanged: filterCountries,
                  decoration: const InputDecoration(
                    labelText: 'Search Countries',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey), // Set border color to grey

                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCountryData.length,
                itemBuilder: (context, index) {
                  final country = filteredCountryData[index];
                  return Card(
                    elevation: 2,
                    shadowColor: const Color.fromRGBO(158, 158, 158, 1),
                    margin:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Wallet2wallet();
                          }));
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SendOptions();
                          }));
                        }
                      },
                      title: Text(
                        country['name']!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.black,
                        size: 18,
                      ),
                      subtitle: country['subtitle'] != null
                          ? Text(country['subtitle']!)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
