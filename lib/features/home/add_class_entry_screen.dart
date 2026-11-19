import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/navigation.dart';
import 'home_screen.dart';

class AddClassEntryScreen extends StatefulWidget {
  const AddClassEntryScreen({super.key});

  @override
  State<AddClassEntryScreen> createState() => _AddClassEntryScreenState();
}

class _AddClassEntryScreenState extends State<AddClassEntryScreen> {
  bool _openedSheet = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _openSheetOnce());
  }

  Future<void> _openSheetOnce() async {
    if (_openedSheet || !mounted) return;

    _openedSheet = true;
    await openAddClassSheet(context);

    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) => const HomeScreen();
}
