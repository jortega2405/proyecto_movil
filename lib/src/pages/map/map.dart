import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proyecto_movil/src/pages/map/map_controller.dart';
import 'package:proyecto_movil/src/widget/button_app.dart';
import 'package:proyecto_movil/src/utils/colors.dart' as utils;

class MapPage extends StatefulWidget {
 MapPage({Key key}) : super(key: key);

  @override
   MapPageState createState() =>  MapPageState();
}

class  MapPageState extends State <MapPage> {

  MapController _con = new MapController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });

    @override
    void dispose(){
      super.dispose();
      print("Se Ejecutó el dispose");
      _con.dispose();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      body: Stack(
        children: [
          _googleMapWidget(),
          SafeArea(
              child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonBack(),
                    _buttonCenterPosition(),
                  ],
                ),
                Expanded(child: Container()),
                _buttonConnect(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: _iconMyLocation(),
          )
        ],
      ),
    );
  }

  Widget _buttonCenterPosition(){
    return Container(
      child: Card(
        shape: CircleBorder(),
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(
            Icons.location_searching_outlined,
            color: Colors.grey[600],
            size: 20,
          ),
        ),
      ),
    );
  }


  Widget _buttonBack(){
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        color: Colors.white,
        onPressed: (){
          Navigator.pushNamed(context, 'home');
        },
        icon: Icon(Icons.arrow_back_ios_outlined,),

      ),
    );
  }

  Widget _buttonConnect(){
    return Container(
      height: 50,
      child: ButtonApp(
        onPressed: _con.connect,
        text: _con.isConnect ? 'DESCONECTARSE':'CONECTARSE',
        color: _con.isConnect ? utils.Colors.appColor : Color(0xFFF39845),
        textColor: Colors.black,
         
      ),
    );
  }

  Widget _googleMapWidget(){
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: Set<Marker>.of(_con.markers.values),
    );
  }

  void refresh(){
    setState(() {});
  }
  
  Widget _iconMyLocation(){
    return Image.asset('assets/img/pointer2.png', 
      width: 65,
      height: 65,
    );
  }

  
}