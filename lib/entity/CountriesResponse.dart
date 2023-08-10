import 'dart:convert';

CountriesResponse countriesResponseFromJson(String str) =>
    CountriesResponse.fromJson(json.decode(str));

class CountriesResponse {
  CountriesResponse({
    required this.status,
    required this.data,
  });

  final int? status;
  final List<CountriesList> data;

  factory CountriesResponse.fromJson(Map<String, dynamic> json) {
    return CountriesResponse(
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<CountriesList>.from(
              json["data"]!.map((x) => CountriesList.fromJson(x))),
    );
  }
}

class CountriesList {
  CountriesList({
    required this.id,
    required this.countryName,
  });

  final int? id;
  final String? countryName;

  factory CountriesList.fromJson(Map<String, dynamic> json) {
    return CountriesList(
      id: json["id"],
      countryName: json["country_name"],
    );
  }
}
