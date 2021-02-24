import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LoadingIndicator extends StatelessWidget {
  final StackFit fit;
  final bool showProgress;
  final Widget child;
  final Widget progressWidget;
  final bool horizontalLoader;
  final String loadingMessage;
  const LoadingIndicator(
      {Key key,
      this.fit,
      @required this.showProgress,
      @required this.child,
      this.progressWidget,
      this.horizontalLoader = false,
      this.loadingMessage})
      : assert(child != null),
        assert(horizontalLoader != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (horizontalLoader) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showProgress
                ? LinearProgressIndicator(
                    backgroundColor: Colors.yellow,
                    minHeight: 4,
                  )
                : Container(),
            Expanded(child: child),
          ],
        );
      }
      return Stack(
        fit: fit ?? StackFit.expand,
        children: [
          child ?? Container(),
          showProgress
              ? Container(
                  color: const Color(0x80000000),
                  child: Center(
                    child: progressWidget ?? _buildDefaultLoadingIndicator(),
                  ),
                )
              : Container(),
        ],
      );
    });
  }

  Widget _buildDefaultLoadingIndicator() {
    if (loadingMessage == null || loadingMessage.isEmpty) {
      return CircularProgressIndicator();
    }
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 15),
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
