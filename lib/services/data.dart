import 'package:google_maps_controller/google_maps_controller.dart';

class Database {
  LatLng position;
  String title;
  Database({this.position, this.title});
}

List<Database> data = [
  //Boys' Area
  Database(position: LatLng(5.1445, 6.832812), title: "Miami Hostel"),
  Database(position: LatLng(5.144955, 6.833022), title: "Los Angeles Hostel"),
  Database(position: LatLng(5.143226, 6.831224), title: "Saint Peter Hostel"),
  Database(position: LatLng(5.145463, 6.832716), title: "London Hostel"),
  Database(position: LatLng(5.145377, 6.833188), title: "Chiago Hostel"),
  Database(position: LatLng(5.142835, 6.831721), title: "Saint Paul Hostel"),
  Database(
      position: LatLng(5.144730976247162, 6.831877268042799),
      title: "Boy's MiniMart"),
  Database(
      position: LatLng(5.145651404261276, 6.832499612369041),
      title: "Boy's Cafe"),
  Database(
      position: LatLng(5.145289749408434, 6.832413489354996),
      title: "Boy's Boutigue"),
  Database(
      position: LatLng(5.1446924562612315, 6.8317506820254446),
      title: "Barber"),
  Database(
      position: LatLng(5.1447060708196615, 6.831686635382614),
      title: "Boy's Tailor"),
  //Girls' Area
  Database(
      position: LatLng(5.13861116732392, 6.82785965066346),
      title: "Emmanuel Hostel"),
  Database(
      position: LatLng(5.138073869926042, 6.827764797324183),
      title: "St. Mary Hostel"),
  Database(
      position: LatLng(5.137124400711367, 6.82753242058158),
      title: "MJS Hostel"),
  Database(
      position: LatLng(5.137675082736727, 6.826175911393751),
      title: "Omogo Hostel"),
  Database(
      position: LatLng(5.137610968343613, 6.826885716670578),
      title: "Edeami Hostel"),
  Database(
      position: LatLng(5.137803528133078, 6.826364430476591),
      title: "Girl's Tailor"),
  Database(
      position: LatLng(5.137987811614671, 6.825724207217547),
      title: "Madonna Hostel"),
  Database(
      position: LatLng(5.138922707995338, 6.825894981525657),
      title: "St. Anthony Hostel"),
  Database(
      position: LatLng(5.138961751633173, 6.825406304495329),
      title: "St. Barnabas Hostel"),
  Database(
      position: LatLng(5.138140310252152, 6.826147834947131),
      title: "Girl's MiniMart"),
  Database(
      position: LatLng(5.137240597614865, 6.825744377756242),
      title: "Girl's Boutique"),
  Database(
      position: LatLng(5.138731731706623, 6.825862721758464),
      title: "Girl's Cafe"),
  //Official Places
  Database(
      position: LatLng(5.142708857598002, 6.830293064390516),
      title: "Admission Office"),
  Database(
      position: LatLng(5.140519818654879, 6.831150106051692),
      title: "Registrar Office"),
  Database(
      position: LatLng(5.140428990334958, 6.831793836192257),
      title: "Alumni Building"),
  //Classes
  Database(
      position: LatLng(5.142489059177431, 6.831114046379265),
      title: "MLS Building"),
  Database(
      position: LatLng(5.141129412324065, 6.830226132220735),
      title: "Faculty of Pharmacy"),
  Database(
      position: LatLng(5.140525269743224, 6.830256339886889),
      title: "Engine Block"),
  Database(
      position: LatLng(5.14108059995287, 6.828749394339111),
      title: "CS Building"),
  Database(
      position: LatLng(5.141094028948097, 6.8291260483884315),
      title: "MB Building"),
  Database(
      position: LatLng(5.141203134648792, 6.829090880589515),
      title: "BC Building"),
  Database(
      position: LatLng(5.138547598664362, 6.82910893864504),
      title: "Philo's Mart"),
  Database(
      position: LatLng(5.141051909206421, 6.829470074894614),
      title: "Science Hall"),
  Database(
      position: LatLng(5.140570125743865, 6.828794688099205),
      title: "Faculty of Science"),
  Database(
      position: LatLng(5.140610646961862, 6.830710223788973),
      title: "Tuck Shop"),
  Database(
      position: LatLng(5.140071754535556, 6.830911930915455),
      title: "Edeh's Ark"),

  Database(
      position: LatLng(5.139879685346384, 6.82929396747234),
      title: "Staff Lounge"),
];
