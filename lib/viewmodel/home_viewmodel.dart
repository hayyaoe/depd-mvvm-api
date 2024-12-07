import 'package:mvvm/data/response/api_response.dart';
import 'package:mvvm/model/costs/cost_results.dart';
import 'package:mvvm/model/model.dart';
import 'package:mvvm/repository/home_repository.dart';
import 'package:flutter/material.dart';

class HomeViewmodel with ChangeNotifier {
  final _homeRepo = HomeRepository();

  // Initialize states to notStarted
  ApiResponse<List<Province>> provinceList = ApiResponse.loading();
  ApiResponse<List<Province>> provinceListDestination = ApiResponse.loading();
  ApiResponse<List<City>> cityList = ApiResponse.notStarted();
  ApiResponse<List<City>> cityListDestination = ApiResponse.notStarted();
  ApiResponse<CostResults> costsList = ApiResponse.notStarted();

  void setCosts(ApiResponse<CostResults> response) {
    costsList = response;
    notifyListeners();
  }

  // Setter for province list
  void setProvinceList(ApiResponse<List<Province>> response) {
    provinceList = response;
    notifyListeners();
  }

  void setProvinceListDestination(ApiResponse<List<Province>> response) {
    provinceListDestination = response;
    notifyListeners();
  }

  // Fetch province list
  Future<void> getProvinceList() async {
    setProvinceList(ApiResponse.loading());
    try {
      final value = await _homeRepo.fetchProvinceList();
      setProvinceList(ApiResponse.completed(value));
    } catch (error) {
      setProvinceList(ApiResponse.error(error.toString()));
    }
  }

  Future<void> getProvinceListDestination() async {
    setProvinceList(ApiResponse.loading());
    try {
      final value = await _homeRepo.fetchProvinceList();
      setProvinceListDestination(ApiResponse.completed(value));
    } catch (error) {
      setProvinceListDestination(ApiResponse.error(error.toString()));
    }
  }

  // Setter for city list (origin)
  void setCityList(ApiResponse<List<City>> response) {
    cityList = response;
    notifyListeners();
  }

  // Fetch city list for origin
  Future<void> getCityList(dynamic provId) async {
    setCityList(ApiResponse.loading());
    try {
      final value = await _homeRepo.fetchCityList(provId);
      setCityList(ApiResponse.completed(value));
    } catch (error) {
      setCityList(ApiResponse.error(error.toString()));
    }
  }

  // Setter for city list (destination)
  void setCityListDestination(ApiResponse<List<City>> response) {
    cityListDestination = response;
    notifyListeners();
  }

  // Fetch city list for destination
  Future<void> getCityListDestination(dynamic provId) async {
    setCityListDestination(ApiResponse.loading());
    try {
      final value = await _homeRepo.fetchCityList(provId);
      setCityListDestination(ApiResponse.completed(value));
    } catch (error) {
      setCityListDestination(ApiResponse.error(error.toString()));
    }
  }

  Future<void> getCosts(
      {required String origin,
      required String destination,
      required int weight,
      required String courier}) async {
    setCosts(ApiResponse.loading());
    try {
      final value = await _homeRepo.fetchCostsList(
          origin: origin,
          destination: destination,
          weight: weight,
          courier: courier);
      setCosts(ApiResponse.completed(value));
    } catch (error) {
      setCosts(ApiResponse.error(error.toString()));
    }
  }
}
