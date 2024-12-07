part of 'pages.dart';

class CostPage extends StatefulWidget {
  const CostPage({super.key});

  @override
  State<CostPage> createState() => _CostPageState();
}

class _CostPageState extends State<CostPage> {
  HomeViewmodel homeViewmodel = HomeViewmodel();

  @override
  void initState() {
    homeViewmodel.getProvinceList();
    homeViewmodel.getProvinceListDestination();
    super.initState();
  }

  dynamic selectedProvince;
  dynamic selectedCity;
  dynamic selectedProvinceDestination;
  dynamic selectedCityDestination;
  dynamic selectedExpedition;
  dynamic itemWeight;

  List<String> expeditions = ['jne', 'pos', 'tiki'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Calculate Cost"),
          centerTitle: true,
        ),
        body: ChangeNotifierProvider<HomeViewmodel>(
          create: (BuildContext context) => homeViewmodel,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                Flexible(
                    flex: 5,
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(children: [
                              Expanded(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedExpedition,
                                  hint: const Text('Select Expedition'),
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 30,
                                  elevation: 2,
                                  style: const TextStyle(color: Colors.black),
                                  items: expeditions
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedExpedition = newValue;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                  width: 16), // Space between dropdowns
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Berat (Gram)',
                                    border: UnderlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      itemWeight = value;
                                    });
                                  },
                                ),
                              )
                            ]),
                            const SizedBox(
                                height: 24), // Space between dropdowns
                            Column(
                              children: [
                                const Align(
                                  alignment: Alignment
                                      .centerLeft, // Aligns the text to the left
                                  child: Text('Origin',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Consumer<HomeViewmodel>(
                                          builder: (context, value, _) {
                                        switch (value.provinceList.status) {
                                          case Status.loading:
                                            return const Align(
                                              alignment: Alignment.center,
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          case Status.error:
                                            return Align(
                                              alignment: Alignment.center,
                                              child: Text(value
                                                  .provinceList.message
                                                  .toString()),
                                            );
                                          case Status.completed:
                                            return DropdownButton(
                                                isExpanded: true,
                                                value: selectedProvince,
                                                icon: const Icon(
                                                    Icons.arrow_drop_down),
                                                iconSize: 30,
                                                elevation: 2,
                                                hint: const Text(
                                                    'Pilih provinsi'),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                items: value.provinceList.data!
                                                    .map<
                                                            DropdownMenuItem<
                                                                Province>>(
                                                        (Province value) {
                                                  return DropdownMenuItem(
                                                    value: value,
                                                    child: Text(value.province
                                                        .toString()),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selectedProvince =
                                                        newValue as Province;
                                                    selectedCity = null;
                                                    homeViewmodel.getCityList(
                                                        selectedProvince
                                                            .provinceId);
                                                  });
                                                });
                                          default:
                                        }
                                        return Container();
                                      }),
                                    ),
                                    const SizedBox(
                                        width: 16), // Space between dropdowns
                                    Expanded(
                                      child: Consumer<HomeViewmodel>(
                                          builder: (context, value, _) {
                                        switch (value.cityList.status) {
                                          case Status.notStarted:
                                            return DropdownButton(
                                              isExpanded: false,
                                              value: null,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              iconSize: 30,
                                              elevation: 2,
                                              hint: const Text('Pilih Kota'),
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              items: const [],
                                              onChanged: null, // Disabled
                                            );
                                          case Status.loading:
                                            return const Align(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                height: 30,
                                                width: 30,
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          case Status.error:
                                            return Align(
                                              alignment: Alignment.center,
                                              child: Text(value.cityList.message
                                                  .toString()),
                                            );
                                          case Status.completed:
                                            return DropdownButton(
                                              isExpanded: true,
                                              value: selectedCity,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              iconSize: 30,
                                              elevation: 2,
                                              hint: const Text('Pilih kota'),
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              items: value.cityList.data!
                                                  .map<DropdownMenuItem<City>>(
                                                      (City value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value.cityName
                                                      .toString()),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedCity =
                                                      newValue as City;
                                                });
                                              },
                                            );
                                          default:
                                        }
                                        return Container();
                                      }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                                height: 8), // Space between dropdowns
                            Column(
                              children: [
                                const Align(
                                  alignment: Alignment
                                      .centerLeft, // Aligns the text to the left
                                  child: Text('Destination',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Consumer<HomeViewmodel>(
                                          builder: (context, value, _) {
                                        switch (value
                                            .provinceListDestination.status) {
                                          case Status.loading:
                                            return const Align(
                                              alignment: Alignment.center,
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          case Status.error:
                                            return Align(
                                              alignment: Alignment.center,
                                              child: Text(value
                                                  .provinceListDestination
                                                  .message
                                                  .toString()),
                                            );
                                          case Status.completed:
                                            return DropdownButton(
                                                isExpanded: true,
                                                value:
                                                    selectedProvinceDestination,
                                                icon: const Icon(
                                                    Icons.arrow_drop_down),
                                                iconSize: 30,
                                                elevation: 2,
                                                hint: const Text(
                                                    'Pilih provinsi'),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                items: value
                                                    .provinceListDestination
                                                    .data!
                                                    .map<
                                                            DropdownMenuItem<
                                                                Province>>(
                                                        (Province value) {
                                                  return DropdownMenuItem(
                                                    value: value,
                                                    child: Text(value.province
                                                        .toString()),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selectedProvinceDestination =
                                                        newValue as Province;
                                                    selectedCityDestination =
                                                        null;
                                                    homeViewmodel
                                                        .getCityListDestination(
                                                            selectedProvinceDestination
                                                                .provinceId);
                                                  });
                                                });
                                          default:
                                        }
                                        return Container();
                                      }),
                                    ),
                                    const SizedBox(
                                        width: 16), // Space between dropdowns
                                    Expanded(
                                      child: Consumer<HomeViewmodel>(
                                          builder: (context, value, _) {
                                        switch (
                                            value.cityListDestination.status) {
                                          case Status.notStarted:
                                            return DropdownButton(
                                              isExpanded: false,
                                              value: null,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              iconSize: 30,
                                              elevation: 2,
                                              hint: const Text('Pilih Kota'),
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              items: const [],
                                              onChanged: null, // Disabled
                                            );
                                          case Status.loading:
                                            return const Align(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                height: 30,
                                                width: 30,
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          case Status.error:
                                            return Align(
                                              alignment: Alignment.center,
                                              child: Text(value
                                                  .cityListDestination.message
                                                  .toString()),
                                            );
                                          case Status.completed:
                                            return DropdownButton(
                                                isExpanded: true,
                                                value: selectedCityDestination,
                                                icon: const Icon(
                                                    Icons.arrow_drop_down),
                                                iconSize: 30,
                                                elevation: 2,
                                                hint: const Text('Pilih kota'),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                items: value
                                                    .cityListDestination.data!
                                                    .map<
                                                            DropdownMenuItem<
                                                                City>>(
                                                        (City value) {
                                                  return DropdownMenuItem(
                                                    value: value,
                                                    child: Text(value.cityName
                                                        .toString()),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selectedCityDestination =
                                                        newValue as City;
                                                  });
                                                });
                                          default:
                                        }
                                        return Container();
                                      }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (selectedCity == null ||
                                    selectedCityDestination == null ||
                                    selectedExpedition == null) {
                                  // Check if any of the required fields are null (not selected)
                                  _showErrorDialog(context,
                                      'Please select a city, destination, and expedition.');
                                } else if (itemWeight.isEmpty ||
                                    int.tryParse(itemWeight) == null) {
                                  // Validate that the itemWeight is a valid number
                                  _showErrorDialog(
                                      context, 'Please enter a valid weight.');
                                } else {
                                  // Convert itemWeight to integer and validate its value
                                  int weight = int.parse(itemWeight);
                                  if (weight <= 0 || weight > 30000) {
                                    // Check if weight is within the valid range (1 - 30,000 grams)
                                    _showErrorDialog(context,
                                        'Weight must be a valid number between 1g and 30,000g.');
                                  } else {
                                    // Show the loading dialog
                                    _showLoadingDialog(context);

                                    // Call the function to get costs
                                    homeViewmodel
                                        .getCosts(
                                      origin: selectedCity.cityId,
                                      destination:
                                          selectedCityDestination.cityId,
                                      weight: weight,
                                      courier: selectedExpedition,
                                    )
                                        .then((_) {
                                      // Dismiss the loading dialog once the costs are loaded
                                      Navigator.of(context)
                                          .pop(); // Close the loading dialog
                                    }).catchError((error) {
                                      // Handle errors, dismiss loading dialog, and show error dialog
                                      Navigator.of(context)
                                          .pop(); // Close the loading dialog
                                      _showErrorDialog(context,
                                          'Failed to fetch costs: ${error.toString()}');
                                    });
                                  }
                                }
                              },
                              child: const Text('Get Costs'),
                            ),
                          ],
                        ),
                      ),
                    )),
                Flexible(
                  flex: 4,
                  child: Consumer<HomeViewmodel>(
                    builder: (context, value, _) {
                      // Check if costsList is null or if the costs list is empty
                      if (value.costsList.data == null ||
                          value.costsList.data!.costs!.isEmpty) {
                        if (value.costsList.status == Status.loading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (value.costsList.status ==
                            Status.notStarted) {
                          return const Center(child: Text("No Cost Available"));
                        } else if (value.costsList.status == Status.error) {
                          return Center(
                            child: Text(
                              value.costsList.message ?? 'Failed to load costs',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else {
                          return const Center(
                              child: Text('No costs available'));
                        }
                      } else {
                        return ListView(
                          children:
                              value.costsList.data!.costs!.map((costModel) {
                            return Card(
                              color: Colors.white,
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 4),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              costModel.service ??
                                                  'Unknown Service',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          costModel.description ??
                                              'No description available',
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 8),
                                        // First map for cost (value)
                                        ...costModel.cost!.map((cost) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue[600],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Text(
                                                    'Rp ${(cost.value ?? 0)}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ],
                                    ),

                                    // Position the ETD at the top right corner using Positioned widget
                                    ...costModel.cost!.map((cost) {
                                      return cost.etd != null &&
                                              cost.etd!.isNotEmpty
                                          ? Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  'ETD: ${cost.etd} days',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          : Container(); // Empty container if ETD is not available
                                    }),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent the user from dismissing the dialog
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Loading..."),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
