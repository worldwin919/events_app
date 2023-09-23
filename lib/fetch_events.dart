import 'package:events_app/models/events.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Event>> fetchEvents() async {
  final response = await http.get(Uri.parse('https://sde-007.api.assignment.theinternetfolks.works/v1/event'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> eventData = data['content']['data'];

    return eventData.map((event) => Event(
      id: event['id'],
      title: event['title'],
      description: event['description'],
      bannerImage: event['banner_image'],
      dateTime: event['date_time'],
      organiserName: event['organiser_name'],
      organiserIcon: event['organiser_icon'],
      venueName: event['venue_name'],
      venueCity: event['venue_city'],
      venueCountry: event['venue_country'],
    )).toList();
  } else {
    throw Exception('Failed to load events');
  }
}
