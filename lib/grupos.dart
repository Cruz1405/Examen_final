// main.dart
import 'package:flutter/material.dart';

import 'database/SQLHelper.dart';

class MyGroup extends StatelessWidget {
  const MyGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Grupos ',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const MyGroupPage());
  }
}

class MyGroupPage extends StatefulWidget {
  const MyGroupPage({Key? key}) : super(key: key);

  @override
  State<MyGroupPage> createState() => _MyGroupPageState();
}

class _MyGroupPageState extends State<MyGroupPage> {
  // All journals
  List<Map<String, dynamic>> _journals = []; // [{id: 1, name: "Hola"},
  // {id: 2, name: "hihihi"}]

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getGrupos();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
      _amountController.text = existingJournal['amount'].toString();
      _stateController.text = existingJournal['state'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: 'Description'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(hintText: 'Amount'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _stateController,
                    decoration: const InputDecoration(hintText: 'City'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new journal
                      if (id == null) {
                        await _addGrupo();
                      }

                      if (id != null) {
                        await _updateGrupo(id);
                      }

                      // Clear the text fields
                      _titleController.text = '';
                      _descriptionController.text = '';
                      _stateController.text = '';

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Create New' : 'Update'),
                  )
                ],
              ),
            ));
  }

// Insert a new journal to the database
  Future<void> _addGrupo() async {
    await SQLHelper.createGrupo(
      _titleController.text,
      _descriptionController.text,
      _amountController.text,
      _stateController.text,
    );
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateGrupo(int id) async {
    await SQLHelper.updateGrupo(
      id,
      _titleController.text,
      _descriptionController.text,
      _amountController.text,
      _stateController.text,
    );
    _refreshJournals();
  }

  // Delete an grupo
  void _deleteGrupo(int id) async {
    await SQLHelper.deleteGrupo(id);
    var showSnackBar =
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grupos'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) => Card(
                  color: Color.fromARGB(255, 50, 231, 80),
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_journals[index]['title']),
                      Text(_journals[index]['description']),
                      Text((_journals[index]['amount']).toString()),
                      Text(_journals[index]['state']),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showForm(_journals[index]['id']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteGrupo(_journals[index]['id']),
                      ),
                    ],
                  )),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
