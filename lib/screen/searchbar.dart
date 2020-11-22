import 'package:flutter/material.dart';
import 'package:mua/services/data.dart';

class SearchBar extends StatefulWidget {
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          width: MediaQuery.of(context).size.width - 10,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Text('Search here')),
    );
  }
}

class DataSearch extends SearchDelegate {
  static List<String> _getItems(List<Database> data) {
    List<String> items = [];
    for (var i in data) {
      items.add(i.title);
    }
    return items;
  }

  List<String> places = _getItems(data);
  final recentPlaces = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {})];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {},
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty ? recentPlaces : places;

    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.location_city),
          title: Text(suggestionList[index])
        );
      },
      itemCount: suggestionList.length
    );
  }
}
