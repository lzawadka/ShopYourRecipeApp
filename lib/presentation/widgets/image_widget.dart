import 'package:flutter/cupertino.dart';

class ImageWidget extends StatelessWidget {
  final String? imageUrl;

  const ImageWidget({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return Image.network(imageUrl!);
    } else if (imageUrl != null) {
      return Image.asset(imageUrl!);
    } else {
      return Container();
    }
  }
}