import 'package:flutter/material.dart';

class ProviderButton extends StatefulWidget {
  final BuildContext context;
  final String signInType;

  const ProviderButton({Key key, this.context, this.signInType})
      : super(key: key);

  @override
  _ProviderButtonState createState() => _ProviderButtonState();
}

class _ProviderButtonState extends State<ProviderButton> {
  @override
  Widget build(BuildContext context) {
    switch (widget.signInType) {
      case "google":
        return InkWell(
          // #TODO onTap configure
          // onTap: () => context.signInWithGoogle(),
          child: Container(
              padding: const EdgeInsets.all(12.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black26,
                ),
              ),
              child: Icon(
                Icons.grid_on,
              )),
        );
      default:
        return const Text("error");
    }
  }
}
