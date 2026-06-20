import 'package:flutter/material.dart';
import 'package:genbi/components/glass.dart';

class AbsTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  final String? title;
  final double cellWidth;

  const AbsTable({
    super.key,
    required this.headers,
    required this.rows,
    this.title,
    this.cellWidth = 140,
  });

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _shimmer,
          _TitleBar(title: title, count: rows.length),
          _Body(headers: headers, rows: rows, cellWidth: cellWidth),
          _footer,
        ],
      ),
    );
  }

  // Top shimmer highlight
  Widget get _shimmer => Container(
    height: 1,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.transparent, AppColors.w(0.4), Colors.transparent],
      ),
    ),
  );

  // Bottom footer
  Widget get _footer => Container(
    padding: const EdgeInsets.fromLTRB(24, 12, 24, 14),
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: AppColors.w(0.06))),
    ),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.w(0.12), Colors.transparent],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${rows.length} of ${rows.length} · AbsTable',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.w(0.22),
            letterSpacing: 0.3,
          ),
        ),
      ],
    ),
  );
}

// ─── Title bar ────────────────────────────────────────────────────────────────
class _TitleBar extends StatelessWidget {
  final String? title;
  final int count;
  const _TitleBar({this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.w(0.08))),
      ),
      child: Row(
        children: [
          ...List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.w([0.50, 0.25, 0.12][i]),
                ),
              ),
            ),
          ),
          if (title != null) ...[
            const SizedBox(width: 6),
            Text(
              title!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.w(0.70),
                letterSpacing: 0.4,
              ),
            ),
          ],
          const Spacer(),
          Text(
            '$count records',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.w(0.30),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Table body ───────────────────────────────────────────────────────────────
class _Body extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  final double cellWidth;
  const _Body({
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
          // Header row
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.w(0.07), AppColors.w(0.03)],
              ),
              border: Border(bottom: BorderSide(color: AppColors.w(0.10))),
            ),
            child: Row(
              children: headers
                  .map(
                    (h) => _cell(
                      Text(
                        h.toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: AppColors.w(0.35),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // Data rows
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

  Widget _cell(Widget child) => SizedBox(
    width: cellWidth,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
      child: child,
    ),
  );
}

// ─── Data row with hover ──────────────────────────────────────────────────────
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
        decoration: BoxDecoration(
          gradient: _hovered
              ? LinearGradient(colors: [AppColors.w(0.08), AppColors.w(0.03)])
              : null,
          border: widget.isLast
              ? null
              : Border(bottom: BorderSide(color: AppColors.w(0.05))),
        ),
        child: Row(
          children: List.generate(
            widget.cells.length,
            (i) => SizedBox(
              width: widget.cellWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                child: Text(
                  widget.cells[i],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: i == 0 ? FontWeight.w500 : FontWeight.w400,
                    color: AppColors.w(i == 0 ? 0.92 : 0.70),
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
