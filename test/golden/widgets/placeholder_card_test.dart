import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';

void main() {
  goldenTest(
    'PlaceholderCard displays correctly',
    fileName: 'placeholder_card',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'empty_state',
          child: const SizedBox(
            width: 400,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox, size: 48),
                    SizedBox(height: 8),
                    Text('No items yet'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
