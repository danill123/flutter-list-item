import 'package:flutter/material.dart';
import 'package:flutter_app/helper.dart';
import 'package:flutter_app/screens/transaction/item.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  final List<Item> _listItem = [];

  void _deleteTransaction(String id) {
    setState(() {
      _listItem.removeWhere((tx) => tx.id == id);
    });
  }

  void _adItem(String title, double amount) {
    final newItem = Item(id: getRandomString(14), title: title, amount: amount);

    setState(() {
      _listItem.add(newItem);
    });
  }

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    // print('${enteredAmount}, ${enteredTitle}'); // debug reason

    if (enteredTitle.isEmpty || enteredAmount <= 0 || enteredAmount == null) {
      return;
    }

    _adItem(enteredTitle, enteredAmount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    void _BottomModalAdditem(BuildContext ctx) {
      showModalBottomSheet(
          context: ctx,
          builder: (_) {
            return GestureDetector(
              onTap: () {},
              child: Card(
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(labelText: 'Title'),
                        controller: _titleController,
                        onSubmitted: (_) => _submitData(),
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Amount'),
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) => _submitData(),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      new RaisedButton(
                        onPressed: () => _submitData(),
                        textColor: Colors.white,
                        color: Colors.lightGreen,
                        child: Text('Add Item'),
                      )
                    ],
                  ),
                ),
              ),
              behavior: HitTestBehavior.opaque,
            );
          });
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              child: _listItem.isEmpty
                  ? Center(child: Text('List item empty'))
                  : ListView.builder(
                      itemBuilder: (ctx, index) {
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 5,
                          ),
                          child: ListTile(
                            title: Text(_listItem[index].title),
                            subtitle: Text('${_listItem[index].amount}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () =>
                                  _deleteTransaction(_listItem[index].id),
                            ),
                          ),
                        );
                      },
                      itemCount: _listItem.length,
                    ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _BottomModalAdditem(context)),
    );
  }
}
