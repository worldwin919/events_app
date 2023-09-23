  import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> searchEvents(String query) async {
  final response = await http.get(Uri.parse(
      'https://sde-007.api.assignment.theinternetfolks.works/v1/event?search=$query'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    List<dynamic> events = data['content']['data'];
    return events;
  } else {
    throw Exception('Failed to search events');
  }
}

class EventSearch extends StatefulWidget {
  @override
  _EventSearchState createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  void _performSearch() async {
    String query = _searchController.text;
    if (query.isNotEmpty) {
      var results = await searchEvents(query);
      setState(() {
        _searchResults =
            results; // Wrap the result in a list for ListView builder
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Events',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchResults.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      var event = _searchResults[index];
                      return ListTile(
                        title: Text(event['title']),
                        subtitle: Text(event['description']),
                        leading: event['banner_image'] != null
                            ? Image.network(event['banner_image'])
                            : Placeholder(), // Provide a default image or widget if the URL is null
                        trailing: event['organiser_icon'] != null
                            ? Image.network(event['organiser_icon'])
                            : Placeholder(), // Provide a default image or widget if the URL is null
                      );
                    },
                  )
                : Center(child: Text('No events found')),
          ),
        ],
      ),
    );
  }
}
