import 'dart:math';

import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/activity.dart';
import 'enum_activity_provider.dart';
import 'enum_activity_state.dart';

class EnumActivityPage extends ConsumerStatefulWidget {
  const EnumActivityPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnumActivityPageState();
}

class _EnumActivityPageState extends ConsumerState<EnumActivityPage> {
  @override
  void initState() {
    super.initState();
    ref.read(enumActivityProvider.notifier).fetchActivity(activityTypes[0]);
  }

  @override
  Widget build(BuildContext context) {
    final activityState = ref.watch(enumActivityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EnumActivityNotifier'),
      ),
      body: switch (activityState.status) {
        ActivityStatus.initial => const Center(
            child: Text(
              'Get some activity',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ActivityStatus.loading => const Center(
            child: CircularProgressIndicator(),
          ),
        ActivityStatus.failure => Center(
            child: Text(
              activityState.error,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
          ),
        ActivityStatus.success => ActivityWidget(
            activity: activityState.activities.first,
          ),
      },
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final randomNumber = Random().nextInt(activityTypes.length);
          ref
              .read(enumActivityProvider.notifier)
              .fetchActivity(activityTypes[randomNumber]);
        },
        label: Text(
          'New Activity',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class ActivityWidget extends StatelessWidget {
  final Activity activity;
  const ActivityWidget({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(25),
      children: [
        Text(
          activity.type,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const Divider(),
        BulletedList(
          bullet: const Icon(
            Icons.check,
            color: Colors.green,
          ),
          listItems: [
            'activity: ${activity.activity}',
            'availability: ${activity.availability}',
            'participants: ${activity.participants}',
            'price: ${activity.price}',
            'accessibility: ${activity.accessibility}',
            'duration: ${activity.duration}',
            'link: ${activity.link.isEmpty ? 'no link' : activity.link}',
            'kidFriendly: ${activity.kidFriendly}',
            'key: ${activity.key}',
          ],
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
