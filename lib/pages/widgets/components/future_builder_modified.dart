import 'package:fetchingburulasapi/pages/widgets/components/errors/otobus_error_widget.dart';
import 'package:flutter/material.dart';

class FutureBuilderModified<T> extends StatelessWidget {
  final Future<T> future;
  final String errorTxt;
  final Widget Function(T? data) outputFunc;

  const FutureBuilderModified({super.key, required this.future, required this.errorTxt, required this.outputFunc});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return OtobusErrorWidget(errorText: "Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.toString().isEmpty) {
          return OtobusErrorWidget(errorText: errorTxt);
        } else {
          return outputFunc(snapshot.data);
        }
      }, //s
    );
  }


}