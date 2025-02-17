import 'package:flutter/material.dart';

class StaticContainer extends StatelessWidget {
  final bool isLoading;
  final String message;
  const StaticContainer({
    super.key,
    this.isLoading = false,
    this.message = "Something went wrong",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: double.infinity,
      child: Center(
        child: (isLoading)
            ? CircularProgressIndicator()
            : Text(
                textAlign: TextAlign.center,
                message,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey[700],
                ),
              ),
      ),
    );
  }
}
