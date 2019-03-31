import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:study_snap/models/TopicModel.dart';
import 'dart:convert';

class AddTopicForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddTopicFormState();
  }
}

class AddTopicFormState extends State<AddTopicForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String title;
  String description;

  bool _validation = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _validation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 24.0),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.title),
              hintText: 'What topic you would like to snap?',
              labelText: 'Title *',
            ),
            onSaved: (String value) {
              title = value;
            },
            validator: _validateTitle,
          ),
          const SizedBox(height: 24.0),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.description),
              hintText: 'Description of snaps.',
              labelText: 'Description',
            ),
            onSaved: (String value) {
              description = value;
            },
          ),
          const SizedBox(height: 24.0),
          Center(
            child: RaisedButton(
              child: const Text('SUBMIT'),
              onPressed: _handleSubmitted,
            ),
          ),
          const SizedBox(height: 24.0),
          Text(
            '* indicates required field',
            style: Theme.of(context).textTheme.caption,
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  String _validateTitle(String value) {
    if (value.isEmpty) return 'Title of the topic can not be empty';
    return null;
  }

  void _handleSubmitted() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _validation = true;
    } else {
      form.save();
      TopicModel model = ScopedModel.of<TopicModel>(context);
      model.add(Topic(title: title, description: description));
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('topics', json.encode(model.toJson()));
      Navigator.pop(context);
    }
  }
}