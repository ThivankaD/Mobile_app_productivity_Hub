import 'package:flutter/material.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final List<Map<String, dynamic>> reminders = [
    {
      'title': 'Team Meeting',
      'description': 'Weekly sync with development team',
      'repeat': 'Weekly',
      'isCompleted': false,
    },
    {
      'title': 'Gym',
      'description': 'Evening workout session',
      'repeat': 'Daily',
      'isCompleted': false,
    },
    {
      'title': 'Pay Bills',
      'description': 'Monthly utility payments',
      'repeat': 'Monthly',
      'isCompleted': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Reminders',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              leading: Checkbox(
                value: reminder['isCompleted'],
                onChanged: (value) {
                  setState(() {
                    reminder['isCompleted'] = value;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              title: Text(
                reminder['title']!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: reminder['isCompleted']
                      ? Colors.grey[400]
                      : Colors.black87,
                  decoration: reminder['isCompleted']
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder['description']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getRepeatColor(reminder['repeat']),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        reminder['repeat']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 12),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    _showReminderDialog(context, index);
                  } else if (value == 'delete') {
                    setState(() {
                      reminders.removeAt(index);
                    });
                  }
                },
              ),
              onTap: () {
                _showReminderDialog(context, index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showReminderDialog(context, null);
        },
        backgroundColor: Colors.purple[600],
        icon: const Icon(Icons.alarm_add),
        label: const Text('New Reminder'),
      ),
    );
  }

  Color _getRepeatColor(String repeat) {
    switch (repeat.toLowerCase()) {
      case 'daily':
        return Colors.blue[600]!;
      case 'weekly':
        return Colors.green[600]!;
      case 'monthly':
        return Colors.orange[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  void _showReminderDialog(BuildContext context, int? index) {
    final titleController = TextEditingController(
      text: index != null ? reminders[index]['title'] : '',
    );
    final descController = TextEditingController(
      text: index != null ? reminders[index]['description'] : '',
    );
    String selectedRepeat =
        index != null ? reminders[index]['repeat'] : 'Daily';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(index != null ? 'Edit Reminder' : 'New Reminder'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedRepeat,
                  decoration: InputDecoration(
                    labelText: 'Repeat',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  items: ['Daily', 'Weekly', 'Monthly', 'Never']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedRepeat = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (index != null) {
                  setState(() {
                    reminders[index]['title'] = titleController.text;
                    reminders[index]['description'] = descController.text;
                    reminders[index]['repeat'] = selectedRepeat;
                  });
                } else {
                  setState(() {
                    reminders.add({
                      'title': titleController.text,
                      'description': descController.text,
                      'repeat': selectedRepeat,
                      'isCompleted': false,
                    });
                  });
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(index != null ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}