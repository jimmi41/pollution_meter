import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';

//https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69?api-key=579b464db66ec23bdd000001778524f21cfe4fcf7f693de6c47de244&format=json&offset=0&limit=1000
void main() async
{
  Map _data=await getJson();
  List _records=_data['records'];
  //print(_records[0]["state"]);
//  print(_data["features"][1]["properties"]);
/*
* Author: Anupam Thaledi Gbpec Ghurdauri pauri garhwal;
* there is a bug in this project which i have to handle after someTime
* when i am calling divider it is eating one object at that time and printing the new object at next line
* feeling proud after making my first complete working application in fluter;
 */

  runApp(new MaterialApp(
    title: "Pollution Application",
    home: new Scaffold(
      appBar: new AppBar(
        title: new Text(
            "Last Update At:\n${_records[0]["last_update"]}",
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black45,
      ),
      body: new Center(
        child: new ListView.builder(
          itemCount: _records.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (BuildContext context, int position)
          {

            //creating the rows for our listview;;;;
            if(position!=0 && (_records[position]["station"]!=_records[position-1]["station"]))
            {

              return new Divider(
                color: Colors.blueGrey.shade800,
                thickness:5.0 ,
              );
            }
            final index=position;
          //print(position);
             // so that position can be divided and it can have even values also
            //("EEE, MMM d, ''yyyy hh:mm aaa");
//            var format=new DateFormat.yMMMMd("en_US").add_jm();
//            var date=new DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time']*1000);
//            var dateString =format.format(date);


            return new ListTile(
              title: new Text(
                "${_records[index]["pollutant_id"]}",
                style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.blue.shade900,
                  fontStyle: FontStyle.italic,
                ),

              ),
              subtitle: new Text(
                "Location: ${_records[index]["station"]}\n${_records[index]["city"]}, ${_records[index]["state"]}",
                style: new TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontStyle: FontStyle.normal,
                ),
              ),
              leading: new CircleAvatar(
                backgroundColor: Colors.grey.shade500,
                child: new Text(

                  "${_records[index]["pollutant_avg"]}",
                  style: new TextStyle(
                    fontSize: 19.5,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: ()
              {
                _showAlertMessage(
                    context,

                    "Min Pollutent: ${_records[index]["pollutant_min"]} ppm\n"
                        "Max Pollutent: ${_records[index]["pollutant_max"]} ppm\n"
                        "Avg Pollutent: ${_records[index]["pollutant_avg"]} ppm\n"
                );
              },
            );
          },
        ),
      ),
  ),
  ));
}
void _showAlertMessage(BuildContext context,String message)
{
  var alert=new AlertDialog(
    title: new Text(
        "Detailed Information",
      style: new TextStyle(
        fontSize: 21.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    content: new Text(message,
    style: new TextStyle(
      fontSize: 19.9,
      color: Colors.grey.shade900,
    ),),
    actions: <Widget>[
      new FlatButton(onPressed: ()
      {
        Navigator.pop(context);
      },
          child: new Text("OK"))
    ],
  );
  showDialog(context: context,child: alert);
}
Future<Map> getJson() async
{
  String apiUrl="https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69?api-key=579b464db66ec23bdd000001778524f21cfe4fcf7f693de6c47de244&format=json&offset=0&limit=1000";
  http.Response response=await http.get(apiUrl);
  return(json.decode(response.body));
}