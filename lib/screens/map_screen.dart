import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/users_list_provider.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  late CameraPosition _puntActual; //punto inicial de tipo CameraPosition

  @override
  void initState() {
    super.initState();
  }

  void addMarker() {
    final usersProvLocal =
        Provider.of<UserListProvider>(context, listen: false);
    LatLng ltngAct = usersProvLocal.nou!.getLatLng();
    MarkerId markerId = MarkerId("${usersProvLocal.tempUser.id}");
    Marker marker = Marker(markerId: markerId, zIndex: 5.0, position: ltngAct);
    setState(() {
      _markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usersProvLocal =
        Provider.of<UserListProvider>(context, listen: false);

    LatLng ltngAct = usersProvLocal.nou!.getLatLng();
    _puntActual = CameraPosition(
      target: ltngAct,
      zoom: 15.5,
      tilt: 25,
      bearing: 45,
    );
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        minMaxZoomPreference: MinMaxZoomPreference(15.5, 20),
        initialCameraPosition: _puntActual,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          addMarker();
        },
        markers: Set.of(_markers.values),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: IconButton(
        icon: Icon(
          Icons.cancel_outlined,
          color: Colors.red,
        ),
        hoverColor: Color.fromARGB(255, 242, 19, 19),
        iconSize: 80,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
