import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeofireProvider {
  
  CollectionReference _ref;
  Geoflutterfire _geo;

  GeofireProvider(){
    _ref = FirebaseFirestore.instance.collection('Locations');
    _geo = Geoflutterfire();
  }

  Stream<List<DocumentSnapshot>> getNearbyUsers(double lat, double lng, double radius){
    GeoFirePoint center = _geo.point(latitude: lat, longitude: lng);
    return _geo.collection(
      collectionRef: _ref.where('status', isEqualTo: 'available_users')
    ).within(center: center, radius: radius, field: 'position');
  }

  Stream<DocumentSnapshot> getLocationByIdStream(String id){
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<void> create(String id, double lat, double lng){
    GeoFirePoint myLocation = _geo.point(latitude: lat, longitude: lng);
    return _ref.doc(id).set({'status': 'available_users', 'position': myLocation.data});
  }

  Future<void> delete(String id){
    return _ref.doc(id).delete();
  }
}