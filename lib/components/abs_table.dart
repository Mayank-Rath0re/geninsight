import 'dart:ui';
import 'package:flutter/material.dart';

// ─── AbsTable ────────────────────────────────────────────────────────────────

class AbsTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  final String? title;
  final double cellWidth; // Added to strictly control column width

  const AbsTable({
    super.key,
    required this.headers,
    required this.rows,
    this.title,
    this.cellWidth = 140.0, // Default width for all columns
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.13),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.40),
            blurRadius: 64,
            offset: const Offset(0, 32),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _TopShimmer(),
              _HeaderBar(title: title, rowCount: rows.length),
              _TableBody(headers: headers, rows: rows, cellWidth: cellWidth),
              _Footer(rowCount: rows.length),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Top shimmer line ────────────────────────────────────────────────────────

class _TopShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withValues(alpha: 0.4),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

// ─── Header bar ──────────────────────────────────────────────────────────────

class _HeaderBar extends StatelessWidget {
  final String? title;
  final int rowCount;

  const _HeaderBar({this.title, required this.rowCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _Dot(opacity: 0.50),
          const SizedBox(width: 6),
          _Dot(opacity: 0.25),
          const SizedBox(width: 6),
          _Dot(opacity: 0.12),
          if (title != null) ...[
            const SizedBox(width: 12),
            Text(
              title!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.70),
                letterSpacing: 0.4,
              ),
            ),
          ],
          const Spacer(),
          Text(
            '$rowCount records',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.30),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final double opacity;
  const _Dot({required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

// ─── Table body ──────────────────────────────────────────────────────────────

class _TableBody extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  final double cellWidth;

  const _TableBody({
    required this.headers,
    required this.rows,
    required this.cellWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ColumnHeaders(headers: headers, cellWidth: cellWidth),
          ...List.generate(
            rows.length,
            (i) => _DataRow(
              cells: rows[i],
              isLast: i == rows.length - 1,
              cellWidth: cellWidth,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColumnHeaders extends StatelessWidget {
  final List<String> headers;
  final double cellWidth;

  const _ColumnHeaders({required this.headers, required this.cellWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.07),
            Colors.white.withValues(alpha: 0.03),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.10),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: headers
            .map((h) => _HeaderCell(label: h, width: cellWidth))
            .toList(),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final double width;

  const _HeaderCell({required this.label, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Fixed width instead of constraints
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
      child: Text(
        label.toUpperCase(),
        overflow:
            TextOverflow.ellipsis, // Prevents layout breaking on long text
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: Colors.white.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}

class _DataRow extends StatefulWidget {
  final List<String> cells;
  final bool isLast;
  final double cellWidth;

  const _DataRow({
    required this.cells,
    required this.isLast,
    required this.cellWidth,
  });

  @override
  State<_DataRow> createState() => _DataRowState();
}

class _DataRowState extends State<_DataRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          gradient: _hovered
              ? LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.03),
                  ],
                )
              : null,
          border: widget.isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
        ),
        child: Row(
          children: List.generate(widget.cells.length, (i) {
            final isFirst = i == 0;
            return Container(
              width: widget.cellWidth, // Fixed width instead of constraints
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Text(
                widget.cells[i],
                overflow: TextOverflow
                    .ellipsis, // Prevents layout breaking on long text
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isFirst ? FontWeight.w500 : FontWeight.w400,
                  color: isFirst
                      ? Colors.white.withValues(alpha: 0.92)
                      : Colors.white.withValues(alpha: 0.70),
                  letterSpacing: 0.1,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─── Footer ──────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  final int rowCount;
  const _Footer({required this.rowCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 14),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$rowCount of $rowCount · AbsTable',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.22),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
