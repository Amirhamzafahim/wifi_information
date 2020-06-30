import 'dart:async';

import 'package:android_wifi_info/android_wifi_info.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Public methods
  Future<String> bssid;
  // // TODO: detailedStateOf
  // Future<int> frequency;
  // Future<bool> ssidHidden;
  // Future<int> ipAddress;
  // Future<int> linkSpeed;
  // Future<String> macAddress;
  // Future<int> networkId;
  // Future<int> rssi;
  // Future<int> rxLinkSpeedMbps;
  // Future<String> ssid;
  // // TODO: supplicantState
  // // Future<SupplicantState> supplicantState;
  // Future<int> txLinkSpeedMbps;
  // // Constants
  // Future<String> frequencyUnits;
  // Future<String> linkSpeedUnits;

  @override
  void initState() {
    fireAllFutures();
    super.initState();
  }

  fireAllFutures() {
    setState(() {
      // Public methods
      bssid = AndroidWifiInfo.bssid;
      // frequency = AndroidWifiInfo.frequency;
      // ssidHidden = AndroidWifiInfo.ssidHidden;
      // ipAddress = AndroidWifiInfo.ipAddress;
      // linkSpeed = AndroidWifiInfo.linkSpeed;
      // macAddress = AndroidWifiInfo.macAddress;
      // networkId = AndroidWifiInfo.networkId;
      // rssi = AndroidWifiInfo.rssi;
      // rxLinkSpeedMbps = AndroidWifiInfo.rxLinkSpeedMbps;
      // ssid = AndroidWifiInfo.ssid;
      // txLinkSpeedMbps = AndroidWifiInfo.txLinkSpeedMbps;
      // // Constants
      // frequencyUnits = AndroidWifiInfo.frequencyUnits;
      // linkSpeedUnits = AndroidWifiInfo.linkSpeedUnits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: fireAllFutures,
              )
            ],
            title: Text(
              'wifi info',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.lightGreen,
          ),
          body: SingleChildScrollView(
                      child: Container(
              child: Column(
            
                children: <Widget>[

                  SizedBox(height: 200,),
                  
                  // PUBLIC METHODS
                  buildFutureListTile(
                    future: bssid,
                    name: 'bssid',
                    description: Column(
                      children: <Widget>[
                        TText(
                            'Basic service set identifier (BSSID) of the current access point.'),
                        TText(
                            'Returns BSSID, in the form of a six-byte MAC address: XX:XX:XX:XX:XX:XX'),
                        TText(
                            'The BSSID may be null if there is no network currently connected.')
                      ],
                    ),
                    type: 'String',
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget buildFutureListTile({
    @required Future future,
    @required String name,
    @required Widget description,
    @required String type,
  }) {
    List<Widget> expansionTileChildren = [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('Type: '),
            Text(type, style: TextStyle(fontFamily: 'monospace')),
          ],
        ),
      ),
      Padding(padding: EdgeInsets.all(8.0), child: description),
    ];
    final nameWidget = Text(
      '$name ',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace',
      ),
    );

    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        final titleWidget = Row(children: <Widget>[
          nameWidget,
          Text(
            '${snapshot.data}',
            style: TextStyle(fontFamily: 'monospace'),
          ),
        ]);
        if (snapshot.hasError) {
          return ExpansionTile(
            leading: Icon(Icons.error, color: Colors.red),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(type, style: TextStyle(fontFamily: 'monospace')),
                Text(name),
                Text(snapshot.error)
              ],
            ),
            children: [description, Text(snapshot.error)],
          );
        }
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            return Text('active');
          case ConnectionState.done:
            return ExpansionTile(
              leading: snapshot.hasData
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : Icon(Icons.error_outline, color: Colors.orange),
              title: titleWidget,
              children: expansionTileChildren,
            );
          case ConnectionState.none:
            return ExpansionTile(
              leading: Icon(Icons.help_outline, color: Colors.red),
              title: titleWidget,
              children: expansionTileChildren,
            );
          case ConnectionState.waiting:
            return ExpansionTile(
              leading: Icon(Icons.hourglass_empty, color: Colors.grey[400]),
              title: titleWidget,
              children: expansionTileChildren,
            );
        }
      },
    );
  }
}

class TText extends StatelessWidget {
  final text;

  TText(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: Container(child: Text(text, textAlign: TextAlign.left)),
      );
}
