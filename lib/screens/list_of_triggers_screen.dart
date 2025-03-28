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

  // Обновленная цветовая схема
  static const Color _primaryBlue = Color(0xFF1E3D59);
  static const Color _secondaryBlue = Color(0xFF17C3B2);
  static const Color _goldLight = Color(0xFFFFD700);
  static const Color _goldDark = Color(0xFFDAA520);
  static const Color _surfaceColor = Colors.white;

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _primaryBlue,
              _primaryBlue.withOpacity(0.8),
              _secondaryBlue.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Декоративные элементы
              Positioned(
                top: -50,
                right: -30,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _goldLight.withOpacity(0.2),
                        _goldDark.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                left: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _secondaryBlue.withOpacity(0.2),
                        _primaryBlue.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
              // Основной контент
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Create Trigger List',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildListNameSection(),
                      const SizedBox(height: 24),
                      _buildTriggersSection(),
                      const SizedBox(height: 24),
                      _buildCommentSection(),
                      const SizedBox(height: 24),
                      _buildSaveButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListNameSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surfaceColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _goldLight.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: _goldLight.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'List Name',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _listNameController,
              decoration: InputDecoration(
                hintText: 'Enter list name...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
              style: TextStyle(color: _primaryBlue, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggersSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surfaceColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _goldLight.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: _goldLight.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Triggers',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _triggerController,
                    decoration: InputDecoration(
                      hintText: 'Add a trigger...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[600]),
                    ),
                    onSubmitted: (_) => _addTrigger(),
                  ),
                ),
                GestureDetector(
                  onTap: _addTrigger,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _secondaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          if (_triggers.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _triggers.map((trigger) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _secondaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            trigger,
                            style: TextStyle(color: _primaryBlue, fontSize: 14),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _removeTrigger(trigger),
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: _primaryBlue.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surfaceColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _goldLight.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: _goldLight.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Notes',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add any additional notes...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed:
          _triggers.isEmpty || _listNameController.text.isEmpty
              ? null
              : _saveTriggerList,
      style: ElevatedButton.styleFrom(
        backgroundColor: _secondaryBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: const Text(
        'Save List',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
