import 'package:flutter/material.dart';
import 'package:myprojects/direction.dart';

import 'buttin.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({Key key,  this.onTapped}) : super(key: key);
  final void Function(Direction direction) onTapped;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0.0,
        right: 0.0,
        bottom: 50.0,
        child: Row(
          children: [
            Expanded(
                child: Row(
              children: [
                Expanded(child: Container()),
                ControlButton(
                  onPressed: () {
                    onTapped(Direction.left);
                  },
                  icon: const Icon(Icons.arrow_left),
                ),
              ],
            )),
            Expanded(
                child: Column(
              children: [
                ControlButton(
                  onPressed: () {
                    onTapped(Direction.up);
                  },
                  icon: const Icon(Icons.arrow_drop_up),
                ),
                const SizedBox(height: 70.0,),
                ControlButton(
                  onPressed: () {
                    onTapped(Direction.down);
                  },
                  icon: const Icon(Icons.arrow_drop_down),
                ),
              ],
            )),
            Expanded(
                child: Row(
              children: [
                ControlButton(
                  onPressed: () {
                    onTapped(Direction.right);
                  },
                  icon: const Icon(Icons.arrow_right),
                ),
                Expanded(child: Container()),
              ],
            )),
          ],
        ));
  }
}
