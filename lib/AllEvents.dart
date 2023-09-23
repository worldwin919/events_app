import 'dart:convert';

import 'package:events_app/SearchEvents.dart';
import 'package:events_app/models/Event_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final response = await get(Uri.parse(
          'https://sde-007.api.assignment.theinternetfolks.works/v1/event'));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data != null &&
            data['content'] != null &&
            data['content']['data'] != null &&
            data['content']['data'].isNotEmpty) {
          setState(() {
            events = (data['content']['data'] as List<dynamic>)
                .map((event) => Event.fromJson(event))
                .toList();
            print('Number of events: ${events.length}');
          });
        } else if (data != null && data['content']['error'] != null) {
          // The API returned an error.
          print(
              'Error fetching events: ${data['content']['error']['message']}');
        } else {
          // Unexpected response.
          print('Unexpected response from API: ${response.body}');
        }
      } else {
        // HTTP error.
        print('HTTP error fetching events: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching events: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EventSearch()));
              },
              icon: const Icon(Icons.search)),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Text('Settings'),
                ),
                const PopupMenuItem<String>(
                  value: 'about',
                  child: Text('About'),
                ),
              ];
            },
          )
        ],
      ),
      body: events.isEmpty
          ? const Center(
              child: Text('No events to display'),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (context, index) {
                return EventItem(event: events[index]);
              },
            ),
    );
  }
}

class EventItem extends StatelessWidget {
  final Event event;

  EventItem({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formatedDateTime =
        DateFormat('EEE, MMM d · h:mm a').format(event.dateTime);

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Detail(
                      event_det: event,
                    )));
      },
      child: Card(
        margin: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey[400],
        //  elevation: 1.2,
        child: ListTile(
          tileColor: Colors.white,
          contentPadding: EdgeInsets.all(16),
          leading: Transform.scale(
            scale: 1.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                event.bannerImage,
                height: 192,
                width: 56,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 96,
                ),
                Text(
                  formatedDateTime,
                  style:
                      const TextStyle(fontSize: 14, color: Colors.blueAccent),
                ),
                Text(
                  event.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Flexible(
                      child: Text(
                        event.venueName,
                        overflow: TextOverflow.ellipsis,
                        //   maxLines: 1,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Flexible(
                      child: Text(
                        '${event.venueCity} ·',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Flexible(
                      child: Text(
                        event.venueCountry,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    /*Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(event.bannerImage ,
            height: 50, width: 50,),
            Text(event.title, style: Theme.of(context).textTheme.titleLarge),
            Text(event.description),
            Text('Date: ${event.dateTime}'),
            Text('Organiser: ${event.organiserName}'),
            Text(
              'Venue: ${event.venueName}, ${event.venueCity}, ${event.venueCountry}',
            ),
          ],
        ),
      ),
    );*/
  }
}

class Event {
  final int id;
  final String title;
  final String description;
  final String bannerImage;
  final DateTime dateTime;
  final String organiserName;
  final String organiserIcon;
  final String venueName;
  final String venueCity;
  final String venueCountry;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.bannerImage,
    required this.dateTime,
    required this.organiserName,
    required this.organiserIcon,
    required this.venueName,
    required this.venueCity,
    required this.venueCountry,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    try {
      return Event(
        id: json['id'] ?? -1,
        title: json['title'] ?? 'No Title',
        description: json['description'] ?? 'No Description',
        bannerImage: json['banner_image'] ?? 'No Image',
        dateTime: json['date_time'] != null
            ? DateTime.parse(json['date_time'])
            : DateTime.now(),
        organiserName: json['organiser_name'] ?? 'No Organiser',
        organiserIcon: json['organiser_icon'] ?? 'No Icon',
        venueName: json['venue_name'] ?? 'No Venue Name',
        venueCity: json['venue_city'] ?? 'No City',
        venueCountry: json['venue_country'] ?? 'No Country',
      );
    } catch (error) {
      print('Error parsing event from JSON: $error');
      print('JSON data: $json');
      return Event(
        id: -1, // or some default values
        title: 'Error',
        description: 'Error',
        bannerImage: 'Error',
        dateTime: DateTime.now(),
        organiserName: 'Error',
        organiserIcon: 'Error',
        venueName: 'Error',
        venueCity: 'Error',
        venueCountry: 'Error',
      );
    }
  }
}
