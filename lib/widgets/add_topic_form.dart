import 'package:flutter/material.dart';
import 'package:study_snap/models/subject.dart';

typedef String ValidateCallback(
    BuildContext context, Subject subject, String value);
typedef void SubmitCallback(
    BuildContext context, Subject subject, String title, String description);

class AddTopicForm extends StatefulWidget {
  final Subject subject;
  final ValidateCallback validate;
  final SubmitCallback handleSubmitted;

  AddTopicForm({Key key, this.subject, this.validate, this.handleSubmitted})
      : super(key: key);

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
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.title),
              hintText: 'What would you like to snap?',
              labelText: 'Title *',
            ),
            onSaved: (String value) {
              title = value;
            },
            validator: (title) {
              widget.validate(context,widget.subject, title);
            },
          ),
          const SizedBox(height: 24.0),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
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
              onPressed: () {
                final FormState form = _formKey.currentState;
                if(!form.validate()) {
                  _validation = true;
                } else {
                  form.save();
                  widget.handleSubmitted(context, widget.subject, title, description);
                }
              },
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
}
