import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// État d'une date dans le calendrier
enum DateStatus { none, present, absent }

/// Dialog pour afficher le calendrier de présences avec marquage interactif des jours
/// Permet de marquer les jours comme présent (vert), absent (rouge) ou non marqué
Future<Map<String, dynamic>?> showPresenceCalendarDialog({
  required BuildContext context,
  required DateTime initialDate,
  required Set<DateTime> presenceDates,
  required Set<DateTime> absenceDates,
  bool allowEditing = false,
}) async {
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _PresenceCalendarDialog(
      initialDate: initialDate,
      presenceDates: Set.from(presenceDates),
      absenceDates: Set.from(absenceDates),
      allowEditing: allowEditing,
    ),
  );
}

class _PresenceCalendarDialog extends StatefulWidget {
  final DateTime initialDate;
  final Set<DateTime> presenceDates;
  final Set<DateTime> absenceDates;
  final bool allowEditing;

  const _PresenceCalendarDialog({
    required this.initialDate,
    required this.presenceDates,
    required this.absenceDates,
    this.allowEditing = false,
  });

  @override
  State<_PresenceCalendarDialog> createState() => _PresenceCalendarDialogState();
}

class _PresenceCalendarDialogState extends State<_PresenceCalendarDialog> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;
  late Set<DateTime> _presenceDates;
  late Set<DateTime> _absenceDates;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(widget.initialDate.year, widget.initialDate.month, 1);
    _presenceDates = Set.from(widget.presenceDates);
    _absenceDates = Set.from(widget.absenceDates);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateStatus _getDateStatus(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    if (_presenceDates.any((d) => _isSameDay(d, normalizedDay))) {
      return DateStatus.present;
    }
    if (_absenceDates.any((d) => _isSameDay(d, normalizedDay))) {
      return DateStatus.absent;
    }
    return DateStatus.none;
  }

  void _toggleDateStatus(DateTime date) {
    if (!widget.allowEditing) {
      // Si pas en mode édition, juste sélectionner la date
      setState(() => _selectedDate = date);
      return;
    }

    final normalizedDate = DateTime(date.year, date.month, date.day);
    final currentStatus = _getDateStatus(normalizedDate);

    setState(() {
      // Retirer des deux sets d'abord
      _presenceDates.removeWhere((d) => _isSameDay(d, normalizedDate));
      _absenceDates.removeWhere((d) => _isSameDay(d, normalizedDate));

      // Cycle: none -> present -> absent -> none
      switch (currentStatus) {
        case DateStatus.none:
          _presenceDates.add(normalizedDate);
          break;
        case DateStatus.present:
          _absenceDates.add(normalizedDate);
          break;
        case DateStatus.absent:
          // Revient à none (déjà retiré)
          break;
      }
      _selectedDate = date;
    });
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.allowEditing ? 'Marquer les présences' : 'Calendrier des présences',
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      content: SizedBox(
        width: 320,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Instructions si en mode édition
              if (widget.allowEditing)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Tapez sur un jour pour changer son état:\nVide → Présent → Absent → Vide',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ),

              // Légende
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendItem(color: AppColors.success, label: 'Présent'),
                  const SizedBox(width: 8),
                  _LegendItem(color: AppColors.error, label: 'Absent'),
                ],
              ),
              const SizedBox(height: 12),

              // Navigation mois
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _previousMonth,
                  ),
                  Text(
                    _formatMonth(_displayedMonth),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Jours de la semaine
              Row(
                children: ['L', 'M', 'M', 'J', 'V', 'S', 'D']
                    .map((d) => Expanded(
                          child: Center(
                            child: Text(
                              d,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.grey600,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 4),

              // Grille du calendrier
              _buildCalendarGrid(),

              const SizedBox(height: 12),

              // Stats du mois
              _buildMonthStats(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, {
            'date': _selectedDate,
            'presenceDates': _presenceDates,
            'absenceDates': _absenceDates,
          }),
          child: Text(widget.allowEditing ? 'Valider' : 'OK'),
        ),
      ],
    );
  }

  Widget _buildMonthStats() {
    // Compter les présences et absences du mois affiché
    int presences = 0;
    int absences = 0;

    for (var date in _presenceDates) {
      if (date.year == _displayedMonth.year && date.month == _displayedMonth.month) {
        presences++;
      }
    }
    for (var date in _absenceDates) {
      if (date.year == _displayedMonth.year && date.month == _displayedMonth.month) {
        absences++;
      }
    }

    final total = presences + absences;
    final taux = total > 0 ? (presences / total * 100).toStringAsFixed(0) : '0';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(label: 'Présences', value: '$presences', color: AppColors.success),
          _StatItem(label: 'Absences', value: '$absences', color: AppColors.error),
          _StatItem(label: 'Taux', value: '$taux%', color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final lastDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    int startWeekday = firstDayOfMonth.weekday;
    int totalCells = startWeekday - 1 + daysInMonth;
    int numRows = (totalCells / 7).ceil();

    List<Widget> rows = [];
    int dayCounter = 1;

    for (int row = 0; row < numRows; row++) {
      List<Widget> rowCells = [];
      for (int col = 0; col < 7; col++) {
        int cellIndex = row * 7 + col;
        if (cellIndex < startWeekday - 1 || dayCounter > daysInMonth) {
          rowCells.add(const Expanded(child: SizedBox(height: 40)));
        } else {
          final date = DateTime(_displayedMonth.year, _displayedMonth.month, dayCounter);
          rowCells.add(Expanded(child: _buildDayCell(date)));
          dayCounter++;
        }
      }
      rows.add(Row(children: rowCells));
    }

    return Column(children: rows);
  }

  Widget _buildDayCell(DateTime date) {
    final isSelected = _isSameDay(date, _selectedDate);
    final isToday = _isSameDay(date, DateTime.now());
    final status = _getDateStatus(date);
    final isFuture = date.isAfter(DateTime.now());
    final canTap = widget.allowEditing && !isFuture;

    Color backgroundColor;
    Color textColor;
    Border? border;

    switch (status) {
      case DateStatus.present:
        backgroundColor = AppColors.success;
        textColor = Colors.white;
        break;
      case DateStatus.absent:
        backgroundColor = AppColors.error;
        textColor = Colors.white;
        break;
      case DateStatus.none:
        if (isToday) {
          backgroundColor = AppColors.grey200;
          textColor = AppColors.primary;
          border = Border.all(color: AppColors.primary, width: 2);
        } else if (isFuture) {
          backgroundColor = AppColors.grey100;
          textColor = AppColors.grey400;
        } else {
          backgroundColor = AppColors.grey200;
          textColor = AppColors.grey700;
        }
        break;
    }

    // Bordure pour la date sélectionnée
    if (isSelected) {
      border = Border.all(color: AppColors.primary, width: 3);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canTap ? () {
          debugPrint('Tap on date: ${date.day}/${date.month}/${date.year}');
          _toggleDateStatus(date);
        } : null,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 36,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: border,
          ),
          child: Center(
            child: Text(
              '${date.day}',
              style: TextStyle(
                color: textColor,
                fontWeight: (status != DateStatus.none || isSelected || isToday)
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatMonth(DateTime date) {
    const mois = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return '${mois[date.month - 1]} ${date.year}';
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppColors.grey600),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.grey600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
