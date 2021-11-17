import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:proyecto_movil/src/providers/auth_provider.dart';
import 'package:proyecto_movil/src/providers/geofire_provider.dart';
import 'package:proyecto_movil/src/utils/progress_dialog.dart';
import 'package:proyecto_movil/src/utils/snackbar.dart' as utils;


class MapController {
  
  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = CameraPosition(
    target: LatLng(10.791284,-74.908680),
    zoom: 20.0
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Position _position;
  StreamSubscription<Position> _positionStream;


  BitmapDescriptor markerUser;
  GeofireProvider _geofireProvider;
  AuthProvider _authProvider;

  bool isConnect = false;
  ProgressDialog _progressDialog;

  StreamSubscription<DocumentSnapshot> _statusSuscription;

  Future init(BuildContext context, Function refresh)async{
    this.context = context;
    this.refresh = refresh;
    _geofireProvider = new GeofireProvider();
    _authProvider = new AuthProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Conectandose...');
    markerUser = await createMarkerImageFromAsset('assets/img/pointer2.png');
    checkGPS();
  }

  void dispose(){
    _positionStream?.cancel();
    _statusSuscription?.cancel();
  }


  void onMapCreated(GoogleMapController controller){
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    _mapController.complete(controller);
  }

  void saveLocation() async {
    await _geofireProvider.create(
      _authProvider.getUser().uid,
      _position.latitude,
      _position.longitude
    );
    _progressDialog.hide();
  }

  void connect(){
    if (isConnect) {
      disconnect();
    }
    else{
      _progressDialog.show();
      updateLocation();
    }
  }

  void disconnect(){
    _positionStream?.cancel();
    _geofireProvider.delete(_authProvider.getUser().uid);
  }

  void checkIfIsConnect(){
    Stream<DocumentSnapshot> status = _geofireProvider.getLocationByIdStream(_authProvider.getUser().uid);

    _statusSuscription = status.listen((DocumentSnapshot document) { 
      if ( document.exists) {
        isConnect = true;
      }else{
        isConnect = false;
      }
      refresh();
    });
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      centerPosition();
      getNearbyUsers();
      saveLocation();
      addMarker(
        'User',
        _position.latitude,
        _position.longitude,
        'Tu Posicion',
        '',
        markerUser
      );
      refresh();
      _positionStream = Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.best,
        distanceFilter: 1
      ).listen((Position position) {
        _position = position;
        addMarker(
        'User',
        _position.latitude,
        _position.longitude,
        'Tu Posicion',
        '',
        markerUser
      );
        animatedCameraToPosition(_position.latitude, _position.longitude);
        saveLocation();
        refresh();
        
      });
    } catch (error) {
      print('Error en la localizacion: $error');
    }
  }

  void getNearbyUsers(){
    Stream<List<DocumentSnapshot>> stream = _geofireProvider.getNearbyUsers(_position.latitude, _position.longitude, 30);

    stream.listen((List<DocumentSnapshot> documentList) {

      for (MarkerId m in markers.keys) {
        bool remove = true;

        for (DocumentSnapshot d in documentList ) {
          if (m.value == d.id) {
            remove =  false;
          }
        }

        if (remove) {
          markers.remove(m);
          refresh();
        }
        
      }

      for (DocumentSnapshot d in documentList) {
        GeoPoint point = d.data()['position']['geopoint'];
        addMarker(
          d.id,
          point.latitude,
          point.longitude,
          'Usuario Disponible',
          '',
          markerUser
        );
      }

      refresh();

     });
  }

  void centerPosition(){
    if (_position != null) {
      animatedCameraToPosition( _position.latitude, _position.longitude);
          }else{
            utils.Snackbar.showSnackbar(context, key, "Activa el GPS para obtener la posicion");
          }
        }
      
        void checkGPS()async{
          bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
          if (isLocationEnabled) {
            print("GPS Activado");
            updateLocation();
            checkIfIsConnect();
          }else{
            print("GPS desactivado");
            bool locationGPS = await location.Location().requestService();
            if (locationGPS) {
              updateLocation();
              checkIfIsConnect();
              print('Se activó el GPS');
            }
          }
        }
      
        Future<Position> _determinePosition() async {
        bool serviceEnabled;
        LocationPermission permission;
      
        // Test if location services are enabled.
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          return Future.error('Location services are disabled.');
        }
      
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            return Future.error('Location permissions are denied');
          }
        }
        
        if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, handle appropriately. 
          return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
        } 
      
        return await Geolocator.getCurrentPosition();
      }
      
      Future animatedCameraToPosition(double latitude, double longitude)async{
          GoogleMapController controller = await _mapController.future;
          if (controller != null) {
            controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                bearing: 0,
                target: LatLng(latitude, longitude),
                zoom: 20,
              ),
            ));
          }
      }

      Future<BitmapDescriptor> createMarkerImageFromAsset(String path)async{
        ImageConfiguration configuration = ImageConfiguration();
        BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(configuration, path);
        return bitmapDescriptor;
      }

      void addMarker(
        String markerId,
        double lat,
        double lng,
        String title,
        String content,
        BitmapDescriptor iconMarker
        ){
        MarkerId id = MarkerId(markerId);
        Marker marker = Marker(
          markerId: id,
          icon: iconMarker,
          position: LatLng(lat,lng),
          infoWindow: InfoWindow(
            title: title,
            snippet: content,
          )
        );

        markers[id] = marker;

      }
}