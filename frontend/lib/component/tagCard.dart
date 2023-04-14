
import 'package:flutter/material.dart';

import '../event.dart';

class TagCard extends StatefulWidget {
  final Tag tag;
  const TagCard({super.key, required this.tag});

  @override
  State<TagCard> createState() => _TagCardState();
}

class _TagCardState extends State<TagCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xffe8f8c1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(widget.tag.name),
      ),
    );
  }
  
}