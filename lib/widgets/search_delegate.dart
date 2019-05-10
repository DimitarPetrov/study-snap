import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/models/subject_model.dart';
import 'package:study_snap/screens/subject_details.dart';

typedef void OnSelectCallback(String query);

class SearchTitleDelegate extends SearchDelegate<String> {
  final List<String> words;
  final OnSelectCallback onSelectCallback;

  SearchTitleDelegate({this.onSelectCallback, this.words});

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        //Take control back to previous page
        this.close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final Iterable<String> suggestions = words
        .where((word) => word.toLowerCase() == query.toLowerCase());

    return _WordSuggestionList(
      query: this.query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        this.query = suggestion;
        onSelectCallback(query);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions = words
        .where((word) => word.toLowerCase().startsWith(query.toLowerCase()));

    return _WordSuggestionList(
      query: this.query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        this.query = suggestion;
        onSelectCallback(query);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    if (query.isNotEmpty) {
      return <Widget>[
        IconButton(
          tooltip: 'Clear',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
      ];
    }
    return null;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData.dark();
  }
}

class _WordSuggestionList extends StatelessWidget {
  const _WordSuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: Icon(
            Icons.subject,
            color: Theme.of(context).accentColor,
          ),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: textTheme.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
