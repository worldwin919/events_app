import 'package:events_app/AllEvents.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Detail extends StatelessWidget {
  Detail({super.key, required this.event_det});
  Event event_det;

  @override
  Widget build(BuildContext context) {
    DateTime eventDateTime = event_det.dateTime; // Your DateTime object
    String formattedDateTime = DateFormat('EEEE, h:mma').format(eventDateTime);

// Assuming your event lasts 5 hours, you can calculate the end time
    DateTime eventEndTime = eventDateTime.add(Duration(hours: 5));
    String formattedEndTime = DateFormat('h:mma').format(eventEndTime);

    String finalFormattedString = '$formattedDateTime - $formattedEndTime';

    String SformattedDateTime = DateFormat('dd MMM, y').format(eventDateTime);

    return Scaffold(
    
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(event_det.bannerImage),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 29.0),
            child: Text(
              event_det.title,
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 9,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                Image.network(
                  event_det.organiserIcon,
                  height: 60,
                  width: 60,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event_det.organiserName,
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Organiser',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 22,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Row(
              children: [
                Image.asset('lib/assets/Date.png'),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SformattedDateTime,
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      finalFormattedString,
                      style:
                          TextStyle(color: Color.fromARGB(255, 110, 109, 109)),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 26,
          ),
          Padding(
            padding: EdgeInsets.only(left: 14),
            child: Row(
              children: [
                Image.asset('lib/assets/Location.png'),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event_det.venueName,
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text('${event_det.venueCity}, ${event_det.venueCountry}' ,
                    style: TextStyle(color: const Color.fromARGB(255, 112, 111, 111)),)
                  ],
                )
              ],
            ),
          ),
      
           const SizedBox(height: 25,),

      const   Padding(
          padding:  EdgeInsets.only(left : 18.0),
          child: Text('About Event ' , 
          style: TextStyle(
            fontSize: 20 , 
            fontWeight: FontWeight.w500
          ),),
        ), 
       
       const SizedBox(height: 12,),

       Padding(
         padding: const EdgeInsets.only(left : 18.0),
         child: Text(event_det.description , 
         style: TextStyle(
          fontSize: 18 , 
          fontWeight: FontWeight.normal
         ),
         ),
       ),

       Padding(
         padding: const EdgeInsets.only(top : 68.0 , left : 70),
         child: Container(
         // color: Colors.purple,
          height: 50,
          width: 240,
       
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 86, 105, 255),
            borderRadius: BorderRadius.circular(12)
          ),
        child:  Row(
          children: [
            
            Padding(
              padding: EdgeInsets.only(left : 78.0),
              child: Text('BOOK NOW'  ,
                      style: TextStyle(
              fontSize: 15 , 
              color: Colors.white,
              fontWeight: FontWeight.bold
                      ),),
            ),
            
            Padding(
              padding: const EdgeInsets.only(left : 38.0),
              child: Container(
                width: 30,
                height: 30,
                 decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 47, 71, 255)
                ),
                child: Icon(Icons.arrow_right_alt_sharp , 
                color: Colors.white,),
              ),
            )


            ]
            
            
            ,
        ),
        
         ),
       )

        ],
      ),
    );
  }
}
