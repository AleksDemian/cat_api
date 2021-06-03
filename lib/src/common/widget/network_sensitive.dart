import 'package:flutter/material.dart';
import 'package:cat_api/src/common/enum/connectivity_status.dart';
import 'package:provider/provider.dart';

class NetworkSensitive extends StatelessWidget {
  final Widget child;

  NetworkSensitive({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Get our connection status from the provider
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    if (connectionStatus == ConnectivityStatus.WiFi) {
      return child;
    }

    if (connectionStatus == ConnectivityStatus.Cellular) {
      return  child;
    }

    return Container(
      alignment: Alignment.center,
      child: Text('No internet connection'),
    );
  }
}