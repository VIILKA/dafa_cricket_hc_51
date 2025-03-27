import 'package:dafa_cricket/core/models/trigger_model.dart';
import 'package:dafa_cricket/services/trigger_service.dart';
import 'package:flutter/material.dart';

class ListOfTriggersScreen extends StatefulWidget {
  const ListOfTriggersScreen({super.key});

  @override
  State<ListOfTriggersScreen> createState() => _ListOfTriggersScreenState();
}

class _ListOfTriggersScreenState extends State<ListOfTriggersScreen> {
  final TextEditingController _listNameController = TextEditingController();
  final TextEditingController _triggerController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final List<String> _triggers = [];
  final TriggerService _triggerService = TriggerService();

  @override
  void dispose() {
    _listNameController.dispose();
    _triggerController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _addTrigger() {
    if (_triggerController.text.isNotEmpty) {
      setState(() {
        _triggers.add(_triggerController.text);
        _triggerController.clear();
      });
    }
  }

  void _removeTrigger(String trigger) {
    setState(() {
      _triggers.remove(trigger);
    });
  }

  Future<void> _saveTriggerList() async {
    if (_listNameController.text.isNotEmpty && _triggers.isNotEmpty) {
      final newList = TriggerList(
        name: _listNameController.text,
        triggers: _triggers,
        comment:
            _commentController.text.isEmpty ? null : _commentController.text,
      );

      await _triggerService.saveTriggerList(newList);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7E0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Transform.rotate(
                        angle: 3.14159,
                        child: const Icon(Icons.arrow_upward),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'List of triggers',
                  style: TextStyle(fontSize: 24, color: Color(0xFF16151A)),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16151A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Name of the list',
                        style: TextStyle(
                          color: Color(0xFFFDF7E0),
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF7E0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _listNameController,
                          decoration: const InputDecoration(
                            hintText: 'Triger list 1',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            color: Color(0xFF16151A),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Note the triggers:',
                        style: TextStyle(
                          color: Color(0xFFFDF7E0),
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF7E0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _triggerController,
                                decoration: const InputDecoration(
                                  hintText:
                                      'Start typing reasons why your mood is so...',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF16151A),
                                  fontSize: 14,
                                ),
                                onSubmitted: (_) => _addTrigger(),
                              ),
                            ),
                            GestureDetector(
                              onTap: _addTrigger,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF16151A),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Color(0xFFFDF7E0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_triggers.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children:
                              _triggers.map((trigger) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFDF7E0),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        trigger,
                                        style: const TextStyle(
                                          color: Color(0xFF16151A),
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () => _removeTrigger(trigger),
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Color(0xFF16151A),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
                      const SizedBox(height: 20),
                      const Text(
                        'My comment:',
                        style: TextStyle(
                          color: Color(0xFFFDF7E0),
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF7E0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _commentController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Start typing...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            color: Color(0xFF16151A),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      _triggers.isEmpty || _listNameController.text.isEmpty
                          ? null
                          : _saveTriggerList,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9A0104),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: const Text(
                    'Add List',
                    style: TextStyle(color: Color(0xFFFDF7E0), fontSize: 17),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
