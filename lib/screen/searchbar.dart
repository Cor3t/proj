import 'package:flutter/material.dart';
import 'package:mua/services/data.dart';

class SearchBar extends StatefulWidget {
  final Function function;
  final String text;
  SearchBar({this.function, this.text});
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.function,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width - 20,
            height: 55,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(blurRadius: 5, color: Colors.grey, spreadRadius: 2)
            ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Text(
              widget.text,
              style: TextStyle(fontSize: 20),
            )),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  static List<String> _getItems(List<Database> data) {
    List<String> items = [];
    for (var i in data) {
      items.add(i.title);
    }
    return items;
  }

  List<String> places = _getItems(data);
  final recentPlaces = ['hey', 'heu'];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentPlaces
        : places.where((element) => element.startsWith(query)).toList();
    return Container(
      color: Colors.white,
      child: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.location_city),
              title: RichText(
                text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: suggestionList[index].substring(query.length),
                          style: TextStyle(color: Colors.grey))
                    ]),
              ),
              onTap: () {
                query = suggestionList[index];
                close(context, query);
              },
            );
          },
          itemCount: suggestionList.length),
    );
  }
}
