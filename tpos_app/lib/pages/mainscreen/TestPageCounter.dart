import 'package:flutter/material.dart';

class TestPageCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: new List.generate(5, (int i)=>new ListTileItem(
          title: "Item #$i",
        )),
      ),
    );
  }
}
class ListTileItem extends StatefulWidget {
  final String title;
  ListTileItem({required this.title, Key? key}) : super(key: key) ;
  @override
  _ListTileItemState createState() => _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  int _itemCount = 0;
  @override
  Widget build(BuildContext context) 
  {
    return ListTile(
      title: Text(widget.title),
      onTap: (){},
      trailing: _buildTrailingWidget(),
    );
  }

  Widget _buildTrailingWidget() {
    return FittedBox(
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.remove), onPressed: () => setState(() {
            _itemCount != 0 ? _itemCount-- : _itemCount;
          }),),
          Text(_itemCount.toString()),
          IconButton(icon: Icon(Icons.add),onPressed: () => setState(() {
            _itemCount++;
          }))
        ],
      ),
    );
  }
}