import 'package:flutter/material.dart';
import 'database/db_reminder.dart';
import 'model/reminder.dart';

class FormReminder extends StatefulWidget {
  final Reminder? reminder;

  FormReminder({this.reminder});

  @override
  _FormReminderState createState() => _FormReminderState();
}

class _FormReminderState extends State<FormReminder> {
  DbHelper db = DbHelper();

  TextEditingController? event;
  TextEditingController? desc;
  TextEditingController? date;
  TextEditingController? time;
  TextEditingController? location;

  @override
  void initState() {
    event = TextEditingController(
        text: widget.reminder == null ? '' : widget.reminder!.event);

    desc = TextEditingController(
        text: widget.reminder == null ? '' : widget.reminder!.desc);

    date = TextEditingController(
        text: widget.reminder == null ? '' : widget.reminder!.date);

    time = TextEditingController(
        text: widget.reminder == null ? '' : widget.reminder!.time);

    location = TextEditingController(
        text: widget.reminder == null ? '' : widget.reminder!.location);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remind Me To..'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: event,
              decoration: InputDecoration(
                  labelText: 'Event',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: desc,
              decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: date,
              decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: time,
              decoration: InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: location,
              decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              child: (widget.reminder == null)
                  ? Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
              onPressed: () {
                upsertReminder();
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> upsertReminder() async {
    if (widget.reminder != null) {
      //update
      await db.updateReminder(Reminder.fromMap({
        'id': widget.reminder!.id,
        'event': event!.text,
        'desc': desc!.text,
        'date': date!.text,
        'time': time!.text,
        'location': location!.text
      }));
      Navigator.pop(context, 'update');
    } else {
      //insert
      await db.saveReminder(Reminder(
        event: event!.text,
        desc: desc!.text,
        date: date!.text,
        time: time!.text,
        location: location!.text,
      ));
      Navigator.pop(context, 'save');
    }
  }
}
