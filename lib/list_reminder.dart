import 'package:flutter/material.dart';
import 'form_reminder.dart';
import 'database/db_reminder.dart';
import 'model/reminder.dart';

class ListReminderPage extends StatefulWidget {
  const ListReminderPage({Key? key}) : super(key: key);

  @override
  _ListReminderPageState createState() => _ListReminderPageState();
}

class _ListReminderPageState extends State<ListReminderPage> {
  List<Reminder> listReminder = [];
  DbHelper db = DbHelper();

  @override
  void initState() {
    //menjalankan fungsi getallReminder saat pertama kali dimuat
    _getAllReminder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Reminder For Your Activity!"),
        ),
      ),
      body: ListView.builder(
          itemCount: listReminder.length,
          itemBuilder: (context, index) {
            Reminder reminder = listReminder[index];
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListTile(
                leading: Icon(
                  Icons.checklist,
                  size: 50,
                ),
                title: Text('${reminder.event}'),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text("Description: ${reminder.desc}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text("Date: ${reminder.date}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text("Time: ${reminder.time}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text("Location: ${reminder.location}"),
                    )
                  ],
                ),
                trailing: FittedBox(
                  fit: BoxFit.fill,
                  child: Row(
                    children: [
                      // button edit
                      IconButton(
                          onPressed: () {
                            _openFormEdit(reminder);
                          },
                          icon: Icon(Icons.edit)),
                      // button hapus
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          //membuat dialog konfirmasi hapus
                          AlertDialog hapus = AlertDialog(
                            title: Text("Delete Reminder?"),
                            content: Container(
                              height: 40,
                              child: Column(
                                children: [
                                  Text(
                                      "This can't be undone and it will be removed from your reminder list.")
                                ],
                              ),
                            ),
                            //terdapat 2 button.
                            //jika ya maka jalankan _deleteReminder() dan tutup dialog
                            //jika tidak maka tutup dialog
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    _deleteReminder(reminder, index);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Yes")),
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                          showDialog(
                              context: context, builder: (context) => hapus);
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
      //membuat button mengapung di bagian bawah kanan layar
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _openFormCreate();
        },
      ),
    );
  }

  //mengambil semua data reminder
  Future<void> _getAllReminder() async {
    //list menampung data dari database
    var list = await db.getAllReminder();

    //ada perubahanan state
    setState(() {
      //hapus data pada listReminder
      listReminder.clear();

      //lakukan perulangan pada variabel list
      list!.forEach((reminder) {
        //masukan data ke listReminder
        listReminder.add(Reminder.fromMap(reminder));
      });
    });
  }

  //menghapus data Reminder
  Future<void> _deleteReminder(Reminder reminder, int position) async {
    await db.deleteReminder(reminder.id!);
    setState(() {
      listReminder.removeAt(position);
    });
  }

  // membuka halaman tambah Reminder
  Future<void> _openFormCreate() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => FormReminder()));
    if (result == 'save') {
      await _getAllReminder();
    }
  }

  //membuka halaman edit Reminder
  Future<void> _openFormEdit(Reminder reminder) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FormReminder(reminder: reminder)));
    if (result == 'update') {
      await _getAllReminder();
    }
  }
}
