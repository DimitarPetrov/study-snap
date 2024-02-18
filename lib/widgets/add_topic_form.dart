import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_snap/models/subject.dart';

typedef String? ValidateCallback(
    BuildContext context, Subject? subject, String? value);
typedef void SubmitCallback(
    BuildContext context, Subject? subject, String title, String description);

class AddTopicForm extends StatefulWidget {
  final Subject? subject;
  final ValidateCallback validate;
  final SubmitCallback handleSubmitted;

  AddTopicForm({Key? key, this.subject, required this.validate, required this.handleSubmitted})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddTopicFormState();
  }
}

class AddTopicFormState extends State<AddTopicForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String title;
  late String description;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 24.0),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(Icons.title),
              hintText: 'What would you like to snap?',
              labelText: 'Title',
            ),
            onSaved: (String? value) {
              title = value!;
            },
            validator: (title) {
              return widget.validate(context, widget.subject, title);
            },
          ),
          const SizedBox(height: 24.0),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(Icons.description),
              hintText: 'Description of snaps.',
              labelText: 'Description',
            ),
            onSaved: (String? value) {
              description = value!;
            },
          ),
          const SizedBox(height: 24.0),
          Center(
            child: CupertinoButton(
              color: Theme.of(context).colorScheme.secondary,
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                final FormState? form = _formKey.currentState;
                if (form != null && form.validate()) {
                  form.save();
                  widget.handleSubmitted(
                      context, widget.subject, title, description);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
