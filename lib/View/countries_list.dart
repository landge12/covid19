import 'package:covid_19_tracker_app/Services/states_services.dart';
import 'package:covid_19_tracker_app/View/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({super.key});

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> countries = [];
  List<dynamic> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    StatesServices statesServices = StatesServices();
    List<dynamic> data = await statesServices.countriesListApi();
    setState(() {
      countries = data;
      filteredCountries = data;
    });
  }

  void filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCountries = countries;
      } else {
        filteredCountries = countries
            .where((country) => (country['country'] as String)
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
                onChanged: filterCountries,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: 'Search with country name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: filteredCountries.isEmpty
                  ? FutureBuilder<List<dynamic>>(
                future: StatesServices().countriesListApi(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade700,
                          highlightColor: Colors.grey.shade100,
                          child: ListTile(
                            title: Container(
                                height: 10, width: 89, color: Colors.white),
                            subtitle: Container(
                                height: 10, width: 89, color: Colors.white),
                            leading: Container(
                                height: 50, width: 50, color: Colors.white),
                          ),
                        );
                      },
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var country = snapshot.data![index];
                        return ListTile(
                          title: Text(country['country']),
                          subtitle: Text(country['cases'].toString()),
                          leading: Image.network(
                            country['countryInfo']['flag'],
                            height: 50,
                            width: 50,
                          ),
                        );
                      },
                    );
                  }
                },
              )
                  : ListView.builder(
                itemCount: filteredCountries.length,
                itemBuilder: (context, index) {
                  var country = filteredCountries[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            name: country['country'],
                            image: country['countryInfo']['flag'],
                            active: country['active'],
                            critical: country['critical'],
                            test: country['tests'],
                            totalCases: country['cases'],
                            todayRecovered: country['todayRecovered'],
                            totalDeaths: country['deaths'],
                            totalRecovered: country['recovered'],
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(country['country']),
                      subtitle: Text(country['cases'].toString()),
                      leading: Image.network(
                        country['countryInfo']['flag'],
                        height: 50,
                        width: 50,
                      ),
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
