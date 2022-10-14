import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key key,
    @required this.onChanged,
    this.fromNav,
  }) : super(key: key);

  final Function(String text) onChanged;
  final fromNav;

  @override
  Widget build(BuildContext context) {
    return fromNav
        ? Padding(
            padding: const EdgeInsets.all(
              8.0,
            ),
            child: Card(
              color: Theme.of(context).colorScheme.primary,
              child: TextFormField(
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                decoration: InputDecoration(
                  hintText: 'Search for market',
                  hintStyle: Theme.of(context).primaryTextTheme.bodyText2,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(
                    10,
                  ),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                onChanged: (String text) {
                  print(text);
                },
                onEditingComplete: () {
                  print('Editing complete');
                },
                style: const TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(
              8.0,
            ),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Flexible(
                  child: Card(
                    color: Theme.of(context).colorScheme.primary,
                    child: TextFormField(
                      cursorColor:
                          Theme.of(context).textSelectionTheme.cursorColor,
                      decoration: InputDecoration(
                        hintText: 'Search for market',
                        hintStyle: Theme.of(context).primaryTextTheme.bodyText2,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(
                          10,
                        ),
                        suffixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                      onChanged: (String text) {
                        print(text);
                      },
                      onEditingComplete: () {
                        print('Editing complete');
                      },
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
