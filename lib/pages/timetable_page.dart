import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  DateTime selectedDate = DateTime.now();
  
  final List<Map<String, dynamic>> events = [
    {
      'date': DateTime.now(),
      'startTime': TimeOfDay(hour: 9, minute: 0),
      'endTime': TimeOfDay(hour: 10, minute: 30),
      'details': 'Mathematics Lecture',
      'color': Colors.blue,
    },
    {
      'date': DateTime.now(),
      'startTime': TimeOfDay(hour: 11, minute: 0),
      'endTime': TimeOfDay(hour: 12, minute: 30),
      'details': 'Physics Lab',
      'color': Colors.green,
    },
    {
      'date': DateTime.now(),
      'startTime': TimeOfDay(hour: 14, minute: 0),
      'endTime': TimeOfDay(hour: 15, minute: 30),
      'details': 'Project Meeting',
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final todayEvents = events.where((event) {
      return event['date'].day == selectedDate.day &&
          event['date'].month == selectedDate.month &&
          event['date'].year == selectedDate.year;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Timetable',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today, color: Colors.black87),
            onPressed: () {
              setState(() {
                selectedDate = DateTime.now();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.black87),
            onPressed: () {
              _showDatePicker(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDateSelector(),
                const SizedBox(height: 16),
                _buildWeekDays(),
              ],
            ),
          ),
          Expanded(
            child: todayEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy,
                            size: 100, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No events scheduled',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add an event',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: todayEvents.length,
                    itemBuilder: (context, index) {
                      return _buildEventCard(todayEvents[index], index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showEventDialog(context, null);
        },
        backgroundColor: Colors.teal[600],
        icon: const Icon(Icons.add),
        label: const Text('New Event'),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 32),
          onPressed: () {
            setState(() {
              selectedDate = selectedDate.subtract(const Duration(days: 1));
            });
          },
        ),
        Column(
          children: [
            Text(
              DateFormat('MMMM yyyy').format(selectedDate),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('d').format(selectedDate),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              DateFormat('EEEE').format(selectedDate),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, size: 32),
          onPressed: () {
            setState(() {
              selectedDate = selectedDate.add(const Duration(days: 1));
            });
          },
        ),
      ],
    );
  }

  Widget _buildWeekDays() {
    final weekStart = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        final day = weekStart.add(Duration(days: index));
        final isSelected = day.day == selectedDate.day &&
            day.month == selectedDate.month;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = day;
            });
          },
          child: Container(
            width: 44,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? Colors.teal[600] : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('E').format(day).substring(0, 1),
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  day.day.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event, int index) {
    final startTime = event['startTime'] as TimeOfDay;
    final endTime = event['endTime'] as TimeOfDay;

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
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: event['color'],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (event['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.event,
                        color: event['color'],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            event['details'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${startTime.format(context)} - ${endTime.format(context)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                      onPressed: () {
                        _showEventOptions(context, index);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Event'),
              onTap: () {
                Navigator.pop(context);
                _showEventDialog(context, index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Event',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                setState(() {
                  events.removeAt(index);
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showEventDialog(BuildContext context, int? index) {
    final detailsController = TextEditingController(
      text: index != null ? events[index]['details'] : '',
    );
    TimeOfDay startTime = index != null
        ? events[index]['startTime']
        : const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = index != null
        ? events[index]['endTime']
        : const TimeOfDay(hour: 10, minute: 0);
    Color selectedColor =
        index != null ? events[index]['color'] : Colors.blue;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(index != null ? 'Edit Event' : 'New Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: detailsController,
                  decoration: InputDecoration(
                    labelText: 'Event Details',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: startTime,
                          );
                          if (picked != null) {
                            setDialogState(() {
                              startTime = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.access_time),
                        label: Text(startTime.format(context)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: endTime,
                          );
                          if (picked != null) {
                            setDialogState(() {
                              endTime = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.access_time),
                        label: Text(endTime.format(context)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Choose Color',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                    Colors.red,
                    Colors.purple,
                    Colors.teal,
                  ].map((color) {
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color
                                ? Colors.black
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: selectedColor == color
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 20)
                            : null,
                      ),
                    );
                  }).toList(),
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
                    events[index]['details'] = detailsController.text;
                    events[index]['startTime'] = startTime;
                    events[index]['endTime'] = endTime;
                    events[index]['color'] = selectedColor;
                  });
                } else {
                  setState(() {
                    events.add({
                      'date': selectedDate,
                      'startTime': startTime,
                      'endTime': endTime,
                      'details': detailsController.text,
                      'color': selectedColor,
                    });
                  });
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[600],
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