import 'package:fetchingburulasapi/pages/components/errors/otobus_error_component.dart';
import 'package:flutter/material.dart';

class FutureBuilderErrors {
  String hasDataError;
  String? isEmptyError;

  FutureBuilderErrors({required this.hasDataError, this.isEmptyError});
}

class FutureBuilderExtended<T> extends StatelessWidget {
  final Future<T> future;
  final FutureBuilderErrors errors;
  final Widget Function(T? data) outputFunc;

  const FutureBuilderExtended({super.key, required this.future, required this.errors, required this.outputFunc});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return OtobusErrorComponent(errorText: "Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.toString().isEmpty) {
          return OtobusErrorComponent(errorText: errors.hasDataError);
        } else if(errors.isEmptyError != null && snapshot.data! is List && (snapshot.data! as List).isEmpty) {
          return OtobusErrorComponent(errorText: errors.isEmptyError!);
        } else {
          return outputFunc(snapshot.data);
        }
      }, //s
    );
  }
}