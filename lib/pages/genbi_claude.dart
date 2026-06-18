// ============================================================
//  GenBI — AI Data Studio  |  Flutter UI Scaffold
//  Design: Dark Cockpit — deep navy, electric indigo, cyan
//  Architecture: Feature-modular, widget-per-concern
// ============================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const GenBIApp());
}

// ─────────────────────────────────────────────────────────────
//  DESIGN TOKENS
// ─────────────────────────────────────────────────────────────

abstract class AppColors {
  // Base surfaces
  static const bg = Color(0xFF070C1A); // deepest navy
  static const surface = Color(0xFF0D1427); // card navy
  static const surfaceHigh = Color(0xFF131D38); // elevated card
  static const border = Color(0xFF1E2D52); // subtle border
  static const borderHigh = Color(0xFF2C4080); // active border

  // Brand
  static const indigo = Color(0xFF5B5FED); // primary
  static const indigoLight = Color(0xFF7B7FF5);
  static const cyan = Color(0xFF00D2FF); // accent
  static const cyanDim = Color(0xFF0097B8);

  // Semantic
  static const success = Color(0xFF2DD4A4);
  static const warning = Color(0xFFFFB547);
  static const error = Color(0xFFFF5C7A);

  // Text
  static const textPrimary = Color(0xFFE8EBF8);
  static const textSecondary = Color(0xFF8492BE);
  static const textMuted = Color(0xFF4A5A8A);

  // Pipeline node colors
  static const nodeClean = Color(0xFF2DD4A4);
  static const nodeStep = Color(0xFF5B5FED);
  static const nodeActive = Color(0xFF00D2FF);
}

abstract class AppTextStyles {
  static const fontDisplay = 'Poppins'; // headings
  static const fontBody = 'Inter'; // body
  static const fontMono = 'JetBrainsMono'; // code/SQL

  static const displayLg = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  static const displayMd = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );
  static const displaySm = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const bodyMd = TextStyle(
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static const bodySm = TextStyle(
    fontFamily: fontBody,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static const labelMd = TextStyle(
    fontFamily: fontBody,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.8,
  );
  static const mono = TextStyle(
    fontFamily: fontMono,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.cyan,
  );
  static const monoDim = TextStyle(
    fontFamily: fontMono,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
}

// ─────────────────────────────────────────────────────────────
//  THEME
// ─────────────────────────────────────────────────────────────

ThemeData buildAppTheme() => ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.bg,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.indigo,
    secondary: AppColors.cyan,
    surface: AppColors.surface,
    error: AppColors.error,
  ),
  fontFamily: AppTextStyles.fontBody,
  dividerColor: AppColors.border,
  iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 18),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceHigh,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.indigo, width: 1.5),
    ),
    hintStyle: AppTextStyles.bodySm,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  ),
);

// ─────────────────────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────────────────────

enum AppPage { main, canvas }

enum AppMode { transform, dashboard }

enum DashboardStage { idle, processing, clarifying, building, done, error }

class Dataset {
  final String filename;
  final String tableName;
  final int rows;
  final int cols;
  const Dataset({
    required this.filename,
    required this.tableName,
    required this.rows,
    required this.cols,
  });
}

class TransformStep {
  final String prompt;
  final String sql;
  final int rows;
  final int cols;
  bool expanded;
  TransformStep({
    required this.prompt,
    required this.sql,
    required this.rows,
    required this.cols,
    this.expanded = false,
  });
}

class ClarifyQuestion {
  final String text;
  final String category;
  final String impact; // high | medium | low
  String answer;
  ClarifyQuestion({
    required this.text,
    required this.category,
    required this.impact,
    this.answer = '',
  });
}

// ─────────────────────────────────────────────────────────────
//  ROOT APP
// ─────────────────────────────────────────────────────────────

class GenBIApp extends StatelessWidget {
  const GenBIApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'GenBI — AI Data Studio',
    debugShowCheckedModeBanner: false,
    theme: buildAppTheme(),
    home: const AppShell(),
  );
}

// ─────────────────────────────────────────────────────────────
//  APP SHELL  (nav + page routing)
// ─────────────────────────────────────────────────────────────

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with TickerProviderStateMixin {
  AppPage _page = AppPage.main;
  AppMode _mode = AppMode.transform;
  int _navIndex = 0; // 0=transform, 1=dashboard, 2=canvas

  // Demo data
  final List<Dataset> _datasets = [
    const Dataset(
      filename: 'sales_q1.csv',
      tableName: '1026_abc_sales_q1',
      rows: 12450,
      cols: 14,
    ),
    const Dataset(
      filename: 'customers.xlsx',
      tableName: '1026_def_customers',
      rows: 3210,
      cols: 9,
    ),
  ];
  int _activeDataset = 0;

  final List<TransformStep> _steps = [
    TransformStep(
      prompt: 'Top 10 products by total revenue',
      sql:
          'SELECT product_name, SUM(revenue) AS total_revenue\nFROM sales_q1\nGROUP BY product_name\nORDER BY total_revenue DESC\nLIMIT 10',
      rows: 10,
      cols: 2,
    ),
    TransformStep(
      prompt: 'Filter only US region orders',
      sql: 'SELECT *\nFROM prev\nWHERE region = \'US\'',
      rows: 7,
      cols: 2,
    ),
  ];

  final List<ClarifyQuestion> _questions = [
    ClarifyQuestion(
      text: 'Which time period should the revenue trend cover?',
      category: 'temporal',
      impact: 'high',
    ),
    ClarifyQuestion(
      text: 'Should we include returned orders in the KPIs?',
      category: 'business',
      impact: 'medium',
    ),
    ClarifyQuestion(
      text: 'Preferred colour theme for the dashboard?',
      category: 'visual',
      impact: 'low',
    ),
  ];

  DashboardStage _dbStage = DashboardStage.idle;
  bool _sidebarExpanded = true;
  bool _rightPanelOpen = true;

  late final AnimationController _fadeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  )..forward();

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _switchNav(int idx) {
    setState(() {
      _navIndex = idx;
      _mode = idx == 0 ? AppMode.transform : AppMode.dashboard;
      _fadeCtrl.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Row(
        children: [
          // ── Left Nav Rail ──
          _NavRail(
            selectedIndex: _navIndex,
            expanded: _sidebarExpanded,
            datasets: _datasets,
            activeDataset: _activeDataset,
            onNavTap: _switchNav,
            onToggle: () =>
                setState(() => _sidebarExpanded = !_sidebarExpanded),
            onDatasetTap: (i) => setState(() => _activeDataset = i),
            onCanvasTap: () => setState(() {
              _navIndex = 2;
              _fadeCtrl.forward(from: 0);
            }),
          ),

          // ── Main Content ──
          Expanded(
            child: FadeTransition(opacity: _fadeCtrl, child: _buildBody()),
          ),

          // ── Right Panel (transform steps) ──
          if (_navIndex == 0 && _rightPanelOpen)
            _TransformHistoryPanel(
              steps: _steps,
              onClose: () => setState(() => _rightPanelOpen = false),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_navIndex == 2) return const CanvasPage();
    if (_navIndex == 1)
      return DashboardPage(
        stage: _dbStage,
        questions: _questions,
        onStageChange: (s) => setState(() => _dbStage = s),
        dataset: _datasets[_activeDataset],
      );
    return TransformPage(
      dataset: _datasets[_activeDataset],
      steps: _steps,
      onAddStep: () {},
      rightPanelOpen: _rightPanelOpen,
      onOpenRightPanel: () => setState(() => _rightPanelOpen = true),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  LEFT NAV RAIL
// ─────────────────────────────────────────────────────────────

class _NavRail extends StatelessWidget {
  const _NavRail({
    required this.selectedIndex,
    required this.expanded,
    required this.datasets,
    required this.activeDataset,
    required this.onNavTap,
    required this.onToggle,
    required this.onDatasetTap,
    required this.onCanvasTap,
  });

  final int selectedIndex;
  final bool expanded;
  final List<Dataset> datasets;
  final int activeDataset;
  final ValueChanged<int> onNavTap;
  final VoidCallback onToggle;
  final ValueChanged<int> onDatasetTap;
  final VoidCallback onCanvasTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      width: expanded ? 220 : 64,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo bar
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const _LogoPulse(),
                if (expanded) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'GenBI',
                          style: AppTextStyles.displaySm.copyWith(
                            color: AppColors.textPrimary,
                            letterSpacing: 0,
                          ),
                        ),
                        Text(
                          'AI Data Studio',
                          style: AppTextStyles.bodySm.copyWith(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                IconButton(
                  icon: Icon(
                    expanded ? Icons.chevron_left : Icons.chevron_right,
                    color: AppColors.textMuted,
                    size: 16,
                  ),
                  onPressed: onToggle,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Nav items
          _NavItem(
            icon: Icons.transform_rounded,
            label: 'Transforms',
            selected: selectedIndex == 0,
            expanded: expanded,
            onTap: () => onNavTap(0),
          ),
          _NavItem(
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            selected: selectedIndex == 1,
            expanded: expanded,
            onTap: () => onNavTap(1),
          ),
          _NavItem(
            icon: Icons.brush_rounded,
            label: 'Canvas',
            selected: selectedIndex == 2,
            expanded: expanded,
            onTap: () {
              onCanvasTap();
              onNavTap(2);
            },
          ),

          const SizedBox(height: 8),
          if (expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'DATASETS',
                style: AppTextStyles.labelMd.copyWith(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 8),

          // Dataset list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: datasets.length + 1,
              itemBuilder: (ctx, i) {
                if (i == datasets.length)
                  return _UploadButton(expanded: expanded);
                final ds = datasets[i];
                final active = i == activeDataset;
                return _DatasetTile(
                  dataset: ds,
                  active: active,
                  expanded: expanded,
                  onTap: () => onDatasetTap(i),
                );
              },
            ),
          ),

          // Bottom
          const Divider(height: 1, color: AppColors.border),
          _NavItem(
            icon: Icons.settings_rounded,
            label: 'Settings',
            selected: false,
            expanded: expanded,
            onTap: () {},
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _LogoPulse extends StatefulWidget {
  const _LogoPulse();
  @override
  State<_LogoPulse> createState() => _LogoPulseState();
}

class _LogoPulseState extends State<_LogoPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) => Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [AppColors.indigo, AppColors.cyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.indigo.withValues(alpha: 0.3 + 0.3 * _ctrl.value),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 18),
    ),
  );
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.expanded,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected, expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: selected
                  ? AppColors.indigo.withValues(alpha: 0.15)
                  : Colors.transparent,
              border: selected
                  ? Border.all(color: AppColors.indigo.withValues(alpha: 0.4))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected ? AppColors.indigo : AppColors.textMuted,
                ),
                if (expanded) ...[
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: selected
                          ? AppColors.indigoLight
                          : AppColors.textSecondary,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DatasetTile extends StatelessWidget {
  const _DatasetTile({
    required this.dataset,
    required this.active,
    required this.expanded,
    required this.onTap,
  });

  final Dataset dataset;
  final bool active, expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: active
                  ? AppColors.cyan.withValues(alpha: 0.08)
                  : Colors.transparent,
            ),
            child: expanded
                ? Row(
                    children: [
                      Icon(
                        dataset.filename.endsWith('.csv')
                            ? Icons.table_rows_rounded
                            : Icons.grid_on_rounded,
                        size: 15,
                        color: active ? AppColors.cyan : AppColors.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dataset.filename,
                              style: AppTextStyles.bodySm.copyWith(
                                color: active
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontWeight: active
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${dataset.rows.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} r × ${dataset.cols} c',
                              style: AppTextStyles.monoDim.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (active)
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.cyan,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  )
                : Center(
                    child: Icon(
                      dataset.filename.endsWith('.csv')
                          ? Icons.table_rows_rounded
                          : Icons.grid_on_rounded,
                      size: 15,
                      color: active ? AppColors.cyan : AppColors.textMuted,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({required this.expanded});
  final bool expanded;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: DottedBorderButton(onTap: () {}, expanded: expanded),
  );
}

class DottedBorderButton extends StatefulWidget {
  const DottedBorderButton({
    super.key,
    required this.onTap,
    required this.expanded,
  });
  final VoidCallback onTap;
  final bool expanded;
  @override
  State<DottedBorderButton> createState() => _DottedBorderButtonState();
}

class _DottedBorderButtonState extends State<DottedBorderButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered ? AppColors.indigo : AppColors.border,
            width: 1,
          ),
          color: _hovered
              ? AppColors.indigo.withValues(alpha: 0.08)
              : Colors.transparent,
        ),
        child: widget.expanded
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_rounded,
                    size: 14,
                    color: _hovered
                        ? AppColors.indigoLight
                        : AppColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Upload dataset',
                    style: AppTextStyles.bodySm.copyWith(
                      color: _hovered
                          ? AppColors.indigoLight
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              )
            : Center(
                child: Icon(
                  Icons.add_rounded,
                  size: 14,
                  color: _hovered ? AppColors.indigoLight : AppColors.textMuted,
                ),
              ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
//  TRANSFORM PAGE
// ─────────────────────────────────────────────────────────────

class TransformPage extends StatefulWidget {
  const TransformPage({
    super.key,
    required this.dataset,
    required this.steps,
    required this.onAddStep,
    required this.rightPanelOpen,
    required this.onOpenRightPanel,
  });
  final Dataset dataset;
  final List<TransformStep> steps;
  final VoidCallback onAddStep;
  final bool rightPanelOpen;
  final VoidCallback onOpenRightPanel;
  @override
  State<TransformPage> createState() => _TransformPageState();
}

class _TransformPageState extends State<TransformPage> {
  final _promptCtrl = TextEditingController();
  bool _promptFocused = false;

  // Fake data table columns
  final _cols = ['Product', 'Revenue', 'Units', 'Region', 'Date'];
  final _rows = [
    ['Laptop Pro', '\$128,400', '1,284', 'US', '2024-01'],
    ['Monitor 4K', '\$84,200', '421', 'EU', '2024-01'],
    ['Keyboard X', '\$33,100', '2,207', 'AP', '2024-01'],
    ['Mouse Pro', '\$21,500', '4,300', 'US', '2024-02'],
    ['Headset Z', '\$18,900', '945', 'EU', '2024-02'],
  ];

  @override
  void dispose() {
    _promptCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      // ── Header ──
      _PageHeader(
        title: 'Transformations',
        subtitle: widget.dataset.filename,
        trailing: Row(
          children: [
            _ChipBadge(
              label: '${widget.steps.length} steps',
              color: AppColors.indigo,
            ),
            const SizedBox(width: 8),
            if (!widget.rightPanelOpen)
              _IconAction(
                icon: Icons.history_rounded,
                tooltip: 'Show history',
                onTap: widget.onOpenRightPanel,
              ),
            const SizedBox(width: 8),
            _IconAction(
              icon: Icons.download_rounded,
              tooltip: 'Export',
              onTap: () {},
            ),
            const SizedBox(width: 8),
            _GlowButton(
              label: 'Reset',
              icon: Icons.refresh_rounded,
              onTap: () {},
              color: AppColors.error,
              small: true,
            ),
          ],
        ),
      ),

      // ── Dataset stat bar ──
      _DatasetStatBar(dataset: widget.dataset),

      // ── Data Table ──
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Column(
            children: [
              Expanded(
                child: _DataTable(cols: _cols, rows: _rows),
              ),
              const SizedBox(height: 12),
              // ── Prompt bar ──
              _AiPromptBar(
                controller: _promptCtrl,
                onSubmit: (t) {},
                placeholder:
                    'Ask AI to transform this data…  e.g. "Top 10 by revenue"',
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _DatasetStatBar extends StatelessWidget {
  const _DatasetStatBar({required this.dataset});
  final Dataset dataset;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: AppColors.surfaceHigh,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      children: [
        _StatPill(
          label: 'Rows',
          value: '12,450',
          icon: Icons.table_rows_outlined,
          color: AppColors.cyan,
        ),
        const SizedBox(width: 16),
        _StatPill(
          label: 'Cols',
          value: '14',
          icon: Icons.view_column_outlined,
          color: AppColors.indigo,
        ),
        const SizedBox(width: 16),
        _StatPill(
          label: 'Table',
          value: dataset.tableName.split('_').last,
          icon: Icons.storage_rounded,
          color: AppColors.success,
        ),
        const Spacer(),
        Text(
          dataset.filename,
          style: AppTextStyles.mono.copyWith(
            fontSize: 11,
            color: AppColors.textMuted,
          ),
        ),
      ],
    ),
  );
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label, value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: color),
      const SizedBox(width: 5),
      Text(
        value,
        style: AppTextStyles.mono.copyWith(color: color, fontSize: 12),
      ),
      const SizedBox(width: 4),
      Text(label, style: AppTextStyles.bodySm.copyWith(fontSize: 11)),
    ],
  );
}

class _DataTable extends StatelessWidget {
  const _DataTable({required this.cols, required this.rows});
  final List<String> cols;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Container(
          color: AppColors.surfaceHigh,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: cols
                .map(
                  (c) => Expanded(
                    child: Text(c.toUpperCase(), style: AppTextStyles.labelMd),
                  ),
                )
                .toList(),
          ),
        ),
        const Divider(height: 1, color: AppColors.border),
        // Rows
        Expanded(
          child: ListView.separated(
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.border),
            itemCount: rows.length,
            itemBuilder: (ctx, i) => _TableRow(cells: rows[i], even: i.isEven),
          ),
        ),
      ],
    ),
  );
}

class _TableRow extends StatefulWidget {
  const _TableRow({required this.cells, required this.even});
  final List<String> cells;
  final bool even;
  @override
  State<_TableRow> createState() => _TableRowState();
}

class _TableRowState extends State<_TableRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      color: _hovered
          ? AppColors.indigo.withValues(alpha: 0.08)
          : widget.even
          ? Colors.transparent
          : AppColors.surfaceHigh.withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: Row(
        children: widget.cells
            .map(
              (c) => Expanded(
                child: Text(
                  c,
                  style: AppTextStyles.bodyMd.copyWith(
                    fontFamily: AppTextStyles.fontMono,
                    fontSize: 12,
                    color: c.startsWith('\$')
                        ? AppColors.success
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
//  RIGHT PANEL — Transform History (Pipeline Rail)
// ─────────────────────────────────────────────────────────────

class _TransformHistoryPanel extends StatelessWidget {
  const _TransformHistoryPanel({required this.steps, required this.onClose});
  final List<TransformStep> steps;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Container(
    width: 280,
    decoration: const BoxDecoration(
      color: AppColors.surface,
      border: Border(left: BorderSide(color: AppColors.border)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Panel header
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.account_tree_rounded,
                size: 15,
                color: AppColors.indigo,
              ),
              const SizedBox(width: 8),
              Text(
                'Pipeline',
                style: AppTextStyles.displaySm.copyWith(fontSize: 14),
              ),
              const Spacer(),
              _IconAction(
                icon: Icons.close_rounded,
                tooltip: 'Close',
                onTap: onClose,
              ),
            ],
          ),
        ),

        // Pipeline rail
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Source node
                _PipelineSourceNode(),
                // Steps
                ...steps.asMap().entries.map(
                  (e) => _PipelineStepNode(
                    step: e.value,
                    index: e.key,
                    isLast: e.key == steps.length - 1,
                  ),
                ),
                const SizedBox(height: 8),
                // Add step hint
                _AddStepHint(),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _PipelineSourceNode extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Icon(Icons.source_rounded, size: 14, color: AppColors.success),
            const SizedBox(width: 8),
            Text(
              'Source dataset',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.success),
            ),
          ],
        ),
      ),
      _PipelineConnector(color: AppColors.success),
    ],
  );
}

class _PipelineConnector extends StatefulWidget {
  const _PipelineConnector({required this.color});
  final Color color;
  @override
  State<_PipelineConnector> createState() => _PipelineConnectorState();
}

class _PipelineConnectorState extends State<_PipelineConnector>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 28,
    width: 24,
    child: AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        painter: _ConnectorPainter(color: widget.color, progress: _ctrl.value),
      ),
    ),
  );
}

class _ConnectorPainter extends CustomPainter {
  final Color color;
  final double progress;
  const _ConnectorPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    // Static line
    canvas.drawLine(
      Offset(cx, 0),
      Offset(cx, size.height),
      Paint()
        ..color = color.withValues(alpha: 0.25)
        ..strokeWidth = 1.5,
    );
    // Animated dot
    final dotY = progress * size.height;
    canvas.drawCircle(
      Offset(cx, dotY),
      2.5,
      Paint()..color = color.withValues(alpha: 0.9),
    );
  }

  @override
  bool shouldRepaint(_ConnectorPainter old) => old.progress != progress;
}

class _PipelineStepNode extends StatefulWidget {
  const _PipelineStepNode({
    required this.step,
    required this.index,
    required this.isLast,
  });
  final TransformStep step;
  final int index;
  final bool isLast;
  @override
  State<_PipelineStepNode> createState() => _PipelineStepNodeState();
}

class _PipelineStepNodeState extends State<_PipelineStepNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _expandCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  bool _expanded = false;

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _expandCtrl.forward() : _expandCtrl.reverse();
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      GestureDetector(
        onTap: _toggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _expanded
                ? AppColors.indigo.withValues(alpha: 0.12)
                : AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _expanded ? AppColors.indigo : AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.indigo.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.indigo, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.index + 1}',
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.indigoLight,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.step.prompt,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.step.sql,
                    style: AppTextStyles.mono.copyWith(
                      fontSize: 10,
                      color: AppColors.cyan.withValues(alpha: 0.85),
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _MiniStat(
                      label: 'rows',
                      value: '${widget.step.rows}',
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    _MiniStat(
                      label: 'cols',
                      value: '${widget.step.cols}',
                      color: AppColors.indigo,
                    ),
                    const Spacer(),
                    _IconAction(
                      icon: Icons.edit_rounded,
                      tooltip: 'Edit',
                      onTap: () {},
                      size: 13,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      if (!widget.isLast) _PipelineConnector(color: AppColors.nodeStep),
    ],
  );
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label, value;
  final Color color;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        value,
        style: AppTextStyles.mono.copyWith(color: color, fontSize: 10),
      ),
      const SizedBox(width: 3),
      Text(label, style: AppTextStyles.bodySm.copyWith(fontSize: 10)),
    ],
  );
}

class _AddStepHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.border, width: 1),
      color: Colors.transparent,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_rounded, size: 13, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Text(
          'Type a prompt to add a step',
          style: AppTextStyles.bodySm.copyWith(fontSize: 11),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────
//  DASHBOARD PAGE
// ─────────────────────────────────────────────────────────────

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    required this.stage,
    required this.questions,
    required this.onStageChange,
    required this.dataset,
  });
  final DashboardStage stage;
  final List<ClarifyQuestion> questions;
  final ValueChanged<DashboardStage> onStageChange;
  final Dataset dataset;
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _promptCtrl = TextEditingController();

  @override
  void dispose() {
    _promptCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _PageHeader(
        title: 'Dashboard Generator',
        subtitle: 'Describe → Clarify → Build',
        trailing: Row(
          children: [_ChipBadge(label: _stageLabel(), color: _stageColor())],
        ),
      ),
      Expanded(child: _buildStageBody()),
    ],
  );

  String _stageLabel() => switch (widget.stage) {
    DashboardStage.idle => 'Ready',
    DashboardStage.processing => 'Analysing…',
    DashboardStage.clarifying => 'Clarifying',
    DashboardStage.building => 'Building…',
    DashboardStage.done => 'Done',
    DashboardStage.error => 'Error',
  };

  Color _stageColor() => switch (widget.stage) {
    DashboardStage.idle => AppColors.textMuted,
    DashboardStage.processing => AppColors.warning,
    DashboardStage.clarifying => AppColors.indigo,
    DashboardStage.building => AppColors.warning,
    DashboardStage.done => AppColors.success,
    DashboardStage.error => AppColors.error,
  };

  Widget _buildStageBody() => switch (widget.stage) {
    DashboardStage.idle => _IdlePromptView(
      ctrl: _promptCtrl,
      dataset: widget.dataset,
      onSubmit: () => widget.onStageChange(DashboardStage.clarifying),
    ),
    DashboardStage.processing => const _ProcessingView(),
    DashboardStage.clarifying => _ClarifyView(
      questions: widget.questions,
      onSubmit: () => widget.onStageChange(DashboardStage.building),
      onSkip: () => widget.onStageChange(DashboardStage.building),
    ),
    DashboardStage.building => const _BuildingView(),
    DashboardStage.done => _DoneView(
      onRebuild: () => widget.onStageChange(DashboardStage.idle),
    ),
    DashboardStage.error => _ErrorView(
      onRetry: () => widget.onStageChange(DashboardStage.idle),
    ),
  };
}

class _IdlePromptView extends StatelessWidget {
  const _IdlePromptView({
    required this.ctrl,
    required this.dataset,
    required this.onSubmit,
  });
  final TextEditingController ctrl;
  final Dataset dataset;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      width: 640,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Glowing top icon
            Center(child: _GlowOrb()),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Generate a Dashboard',
                style: AppTextStyles.displayLg,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Describe what you want. The AI will ask clarifying questions, then build.',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Prompt textarea
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
                color: AppColors.surfaceHigh,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: ctrl,
                    maxLines: 5,
                    style: AppTextStyles.bodyMd,
                    decoration: InputDecoration(
                      hintText:
                          'e.g. "Monthly revenue trend with top 5 products, '
                          'regional breakdown, and KPIs for total revenue, order count…"',
                      hintStyle: AppTextStyles.bodySm,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      fillColor: Colors.transparent,
                      filled: true,
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.table_rows_rounded,
                          size: 13,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Text(dataset.filename, style: AppTextStyles.bodySm),
                        const Spacer(),
                        _GlowButton(
                          label: 'Generate Dashboard',
                          icon: Icons.auto_awesome_rounded,
                          onTap: onSubmit,
                          color: AppColors.indigo,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Example chips
            Text('QUICK STARTERS', style: AppTextStyles.labelMd),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  [
                        'Sales performance overview',
                        'Regional breakdown by month',
                        'Top products & customer segments',
                        'KPI scorecard with trends',
                      ]
                      .map(
                        (t) =>
                            _ExampleChip(label: t, onTap: () => ctrl.text = t),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    ),
  );
}

class _GlowOrb extends StatefulWidget {
  @override
  State<_GlowOrb> createState() => _GlowOrbState();
}

class _GlowOrbState extends State<_GlowOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) => Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.indigo.withValues(alpha: 0.3 + 0.2 * _ctrl.value),
            AppColors.cyan.withValues(alpha: 0.1 + 0.1 * _ctrl.value),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.indigo.withValues(alpha: 0.4 + 0.3 * _ctrl.value),
            blurRadius: 28,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Icon(
        Icons.dashboard_customize_rounded,
        color: Colors.white,
        size: 32,
      ),
    ),
  );
}

class _ExampleChip extends StatefulWidget {
  const _ExampleChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  State<_ExampleChip> createState() => _ExampleChipState();
}

class _ExampleChipState extends State<_ExampleChip> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _hovered
              ? AppColors.indigo.withValues(alpha: 0.15)
              : AppColors.surfaceHigh,
          border: Border.all(
            color: _hovered ? AppColors.indigo : AppColors.border,
          ),
        ),
        child: Text(
          widget.label,
          style: AppTextStyles.bodySm.copyWith(
            color: _hovered ? AppColors.indigoLight : AppColors.textSecondary,
          ),
        ),
      ),
    ),
  );
}

class _ProcessingView extends StatelessWidget {
  const _ProcessingView();
  @override
  Widget build(BuildContext context) => const Center(
    child: _SpinnerCard(message: 'Analysing dataset and extracting intent…'),
  );
}

class _SpinnerCard extends StatelessWidget {
  const _SpinnerCard({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Container(
    width: 380,
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _PulsingRing(),
        const SizedBox(height: 20),
        Text(message, style: AppTextStyles.bodyMd, textAlign: TextAlign.center),
      ],
    ),
  );
}

class _PulsingRing extends StatefulWidget {
  const _PulsingRing();
  @override
  State<_PulsingRing> createState() => _PulsingRingState();
}

class _PulsingRingState extends State<_PulsingRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) => SizedBox(
      width: 56,
      height: 56,
      child: CustomPaint(painter: _RingPainter(_ctrl.value)),
    ),
  );
}

class _RingPainter extends CustomPainter {
  final double t;
  const _RingPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 4;

    // Background ring
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = AppColors.border
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    // Sweeping arc
    final rect = Rect.fromCircle(center: center, radius: r);
    canvas.drawArc(
      rect,
      -math.pi / 2 + t * 2 * math.pi,
      math.pi * 0.8,
      false,
      Paint()
        ..color = AppColors.indigo
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Center dot
    canvas.drawCircle(
      center,
      5,
      Paint()..color = AppColors.cyan.withValues(alpha: 0.8),
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.t != t;
}

class _ClarifyView extends StatefulWidget {
  const _ClarifyView({
    required this.questions,
    required this.onSubmit,
    required this.onSkip,
  });
  final List<ClarifyQuestion> questions;
  final VoidCallback onSubmit, onSkip;
  @override
  State<_ClarifyView> createState() => _ClarifyViewState();
}

class _ClarifyViewState extends State<_ClarifyView> {
  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      width: 600,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.indigo.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.indigo.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.psychology_rounded,
                        size: 13,
                        color: AppColors.indigoLight,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Clarification Round 1 · 80% confidence',
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.indigoLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('A few quick questions', style: AppTextStyles.displayMd),
            const SizedBox(height: 4),
            Text(
              'Answer any or all — skip to proceed immediately.',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            ...widget.questions.asMap().entries.map(
              (e) => _ClarifyCard(question: e.value, index: e.key),
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _GlowButton(
                    label: 'Submit Answers & Continue',
                    icon: Icons.check_rounded,
                    onTap: widget.onSubmit,
                    color: AppColors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                _GlowButton(
                  label: 'Skip All',
                  icon: Icons.skip_next_rounded,
                  onTap: widget.onSkip,
                  color: AppColors.textMuted,
                  small: true,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _ClarifyCard extends StatelessWidget {
  const _ClarifyCard({required this.question, required this.index});
  final ClarifyQuestion question;
  final int index;

  Color get _impactColor => switch (question.impact) {
    'high' => AppColors.error,
    'medium' => AppColors.warning,
    _ => AppColors.success,
  };

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _impactColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                question.category.toUpperCase(),
                style: AppTextStyles.labelMd.copyWith(
                  color: _impactColor,
                  fontSize: 9,
                ),
              ),
              const Spacer(),
              Text(
                'Q${index + 1}',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(question.text, style: AppTextStyles.bodyMd),
          const SizedBox(height: 10),
          TextField(
            style: AppTextStyles.bodyMd.copyWith(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Leave blank to skip…',
              hintStyle: AppTextStyles.bodySm,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.indigo,
                  width: 1.5,
                ),
              ),
              fillColor: AppColors.bg,
              filled: true,
            ),
          ),
        ],
      ),
    ),
  );
}

class _BuildingView extends StatelessWidget {
  const _BuildingView();
  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      width: 420,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SpinnerCard(
            message: 'Generating SQL, executing queries, rendering HTML…',
          ),
          const SizedBox(height: 16),
          _ProgressSteps(),
        ],
      ),
    ),
  );
}

class _ProgressSteps extends StatefulWidget {
  @override
  State<_ProgressSteps> createState() => _ProgressStepsState();
}

class _ProgressStepsState extends State<_ProgressSteps>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  final steps = [
    ('Generating SQL for KPIs', 0.0),
    ('Executing chart queries', 0.33),
    ('Rendering HTML layout', 0.66),
    ('Finalising dashboard', 1.0),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) {
      final v = _ctrl.value;
      return Column(
        children: steps.map((s) {
          final done = v > s.$2 + 0.25;
          final active = !done && v >= s.$2;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done
                        ? AppColors.success.withValues(alpha: 0.2)
                        : active
                        ? AppColors.indigo.withValues(alpha: 0.2)
                        : AppColors.border,
                    border: Border.all(
                      color: done
                          ? AppColors.success
                          : active
                          ? AppColors.indigo
                          : AppColors.border,
                    ),
                  ),
                  child: done
                      ? const Icon(
                          Icons.check_rounded,
                          size: 11,
                          color: AppColors.success,
                        )
                      : active
                      ? const Icon(
                          Icons.radio_button_unchecked_rounded,
                          size: 11,
                          color: AppColors.indigo,
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  s.$1,
                  style: AppTextStyles.bodySm.copyWith(
                    color: done
                        ? AppColors.success
                        : active
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    },
  );
}

class _DoneView extends StatelessWidget {
  const _DoneView({required this.onRebuild});
  final VoidCallback onRebuild;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      // Action bar
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            _GlowButton(
              label: 'Rebuild',
              icon: Icons.refresh_rounded,
              onTap: onRebuild,
              color: AppColors.indigo,
              small: true,
            ),
            const SizedBox(width: 10),
            _GlowButton(
              label: 'Download HTML',
              icon: Icons.download_rounded,
              onTap: () {},
              color: AppColors.success,
              small: true,
            ),
            const SizedBox(width: 10),
            _GlowButton(
              label: 'Open in Browser',
              icon: Icons.open_in_new_rounded,
              onTap: () {},
              color: AppColors.textMuted,
              small: true,
            ),
            const Spacer(),
            // KPI chips
            _ChipBadge(label: '4 KPIs', color: AppColors.cyan),
            const SizedBox(width: 6),
            _ChipBadge(label: '6 Charts', color: AppColors.indigo),
            const SizedBox(width: 6),
            _ChipBadge(label: '92% conf.', color: AppColors.success),
          ],
        ),
      ),
      // Dashboard preview placeholder
      Expanded(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: _DashboardPreviewMock(),
        ),
      ),
    ],
  );
}

class _DashboardPreviewMock extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      // Mock header
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: const BoxDecoration(
          color: AppColors.surfaceHigh,
          borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Text('Sales Performance Dashboard', style: AppTextStyles.displaySm),
            const Spacer(),
            Text('Q1 2024', style: AppTextStyles.bodySm),
          ],
        ),
      ),
      // KPI row
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _KpiCard(
              label: 'Total Revenue',
              value: '\$2.84M',
              change: '+12.3%',
              up: true,
            ),
            const SizedBox(width: 12),
            _KpiCard(
              label: 'Order Count',
              value: '14,230',
              change: '+8.1%',
              up: true,
            ),
            const SizedBox(width: 12),
            _KpiCard(
              label: 'Avg. Order',
              value: '\$199',
              change: '-1.4%',
              up: false,
            ),
            const SizedBox(width: 12),
            _KpiCard(
              label: 'Return Rate',
              value: '3.2%',
              change: '-0.4%',
              up: true,
            ),
          ],
        ),
      ),
      // Fake chart area
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(flex: 3, child: _MockBarChart()),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: _MockPieChart()),
            ],
          ),
        ),
      ),
    ],
  );
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.change,
    required this.up,
  });
  final String label, value, change;
  final bool up;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.bodySm.copyWith(fontSize: 11)),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.displaySm.copyWith(fontSize: 18)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                size: 11,
                color: up ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: 3),
              Text(
                change,
                style: AppTextStyles.bodySm.copyWith(
                  color: up ? AppColors.success : AppColors.error,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _MockBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.surfaceHigh,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Revenue Trend',
          style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: CustomPaint(painter: _BarChartPainter(), size: Size.infinite),
        ),
      ],
    ),
  );
}

class _BarChartPainter extends CustomPainter {
  final data = const [
    0.4,
    0.65,
    0.5,
    0.8,
    0.6,
    0.9,
    0.75,
    1.0,
    0.7,
    0.85,
    0.95,
    0.88,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final barW = size.width / (data.length * 1.5);
    final gap = barW * 0.5;

    for (int i = 0; i < data.length; i++) {
      final x = i * (barW + gap);
      final h = data[i] * size.height * 0.85;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, size.height - h, barW, h),
        const Radius.circular(3),
      );
      canvas.drawRRect(
        rect,
        Paint()
          ..shader = LinearGradient(
            colors: [AppColors.indigo, AppColors.cyan],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ).createShader(rect.outerRect)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter old) => false;
}

class _MockPieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.surfaceHigh,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Revenue by Region',
          style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: CustomPaint(painter: _PieChartPainter(), size: Size.infinite),
        ),
      ],
    ),
  );
}

class _PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;

    final slices = [
      (0.40, AppColors.indigo),
      (0.30, AppColors.cyan),
      (0.20, AppColors.success),
      (0.10, AppColors.warning),
    ];

    double startAngle = -math.pi / 2;
    for (final (fraction, color) in slices) {
      final sweep = fraction * 2 * math.pi;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        true,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
      // Gap
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        true,
        Paint()
          ..color = AppColors.surfaceHigh
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
      startAngle += sweep;
    }

    // Donut hole
    canvas.drawCircle(
      center,
      radius * 0.55,
      Paint()..color = AppColors.surfaceHigh,
    );
  }

  @override
  bool shouldRepaint(_PieChartPainter old) => false;
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 380,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, color: AppColors.error, size: 40),
          const SizedBox(height: 12),
          Text('Dashboard generation failed', style: AppTextStyles.displaySm),
          const SizedBox(height: 8),
          Text(
            'Check the dataset columns and try rephrasing your prompt.',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _GlowButton(
            label: 'Try Again',
            icon: Icons.refresh_rounded,
            onTap: onRetry,
            color: AppColors.indigo,
          ),
        ],
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
//  CANVAS PAGE
// ─────────────────────────────────────────────────────────────

class CanvasPage extends StatefulWidget {
  const CanvasPage({super.key});
  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  String _tool = 'pen';
  Color _color = AppColors.cyan;
  double _strokeWidth = 2;
  List<_Stroke> _strokes = [];
  _Stroke? _current;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _PageHeader(
        title: 'Dashboard Canvas',
        subtitle: 'Sketch your layout',
        trailing: Row(
          children: [
            _IconAction(
              icon: Icons.undo_rounded,
              tooltip: 'Undo',
              onTap: () => setState(() {
                if (_strokes.isNotEmpty) _strokes.removeLast();
              }),
            ),
            const SizedBox(width: 8),
            _IconAction(
              icon: Icons.delete_outline_rounded,
              tooltip: 'Clear',
              onTap: () => setState(() => _strokes = []),
            ),
          ],
        ),
      ),
      // Toolbar
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            ...[
              ('pen', Icons.edit_rounded),
              ('rect', Icons.crop_square_rounded),
              ('line', Icons.remove_rounded),
              ('eraser', Icons.auto_fix_normal_rounded),
            ].map(
              (t) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _ToolButton(
                  icon: t.$2,
                  selected: _tool == t.$1,
                  onTap: () => setState(() => _tool = t.$1),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ...[
              AppColors.cyan,
              AppColors.indigo,
              AppColors.success,
              AppColors.warning,
              AppColors.error,
              AppColors.textPrimary,
            ].map(
              (c) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () => setState(() => _color = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _color == c ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text('Size:', style: AppTextStyles.bodySm),
            const SizedBox(width: 8),
            SizedBox(
              width: 100,
              child: Slider(
                value: _strokeWidth,
                min: 1,
                max: 20,
                activeColor: AppColors.indigo,
                inactiveColor: AppColors.border,
                onChanged: (v) => setState(() => _strokeWidth = v),
              ),
            ),
          ],
        ),
      ),
      // Canvas
      Expanded(
        child: GestureDetector(
          onPanStart: (d) => setState(() {
            _current = _Stroke(
              color: _color,
              width: _strokeWidth,
              points: [d.localPosition],
            );
          }),
          onPanUpdate: (d) =>
              setState(() => _current?.points.add(d.localPosition)),
          onPanEnd: (_) => setState(() {
            if (_current != null) {
              _strokes.add(_current!);
              _current = null;
            }
          }),
          child: Container(
            color: AppColors.surface,
            child: CustomPaint(
              painter: _CanvasPainter(strokes: _strokes, current: _current),
              size: Size.infinite,
            ),
          ),
        ),
      ),
    ],
  );
}

class _Stroke {
  final Color color;
  final double width;
  final List<Offset> points;
  _Stroke({required this.color, required this.width, required this.points});
}

class _CanvasPainter extends CustomPainter {
  final List<_Stroke> strokes;
  final _Stroke? current;
  const _CanvasPainter({required this.strokes, required this.current});

  @override
  void paint(Canvas canvas, Size size) {
    // Grid
    final gridPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.5)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40)
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    for (double y = 0; y < size.height; y += 40)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);

    // Draw strokes
    for (final stroke in [...strokes, if (current != null) current!]) {
      if (stroke.points.isEmpty) continue;
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      final path = Path()
        ..moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (int i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_CanvasPainter old) =>
      old.strokes != strokes || old.current != current;
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: selected
            ? AppColors.indigo.withValues(alpha: 0.2)
            : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.indigo : AppColors.border,
        ),
      ),
      child: Icon(
        icon,
        size: 16,
        color: selected ? AppColors.indigoLight : AppColors.textMuted,
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
//  SHARED COMPONENTS
// ─────────────────────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });
  final String title, subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) => Container(
    height: 60,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.border)),
    ),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: AppTextStyles.displaySm.copyWith(fontSize: 15)),
            Text(subtitle, style: AppTextStyles.bodySm.copyWith(fontSize: 11)),
          ],
        ),
        const Spacer(),
        trailing,
      ],
    ),
  );
}

class _GlowButton extends StatefulWidget {
  const _GlowButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.color,
    this.small = false,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final bool small;
  @override
  State<_GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<_GlowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: widget.small ? 12 : 16,
          vertical: widget.small ? 7 : 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.color.withValues(alpha: _hovered ? 0.25 : 0.12),
          border: Border.all(
            color: widget.color.withValues(alpha: _hovered ? 0.8 : 0.4),
            width: 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.25),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: widget.small ? 13 : 15,
              color: widget.color,
            ),
            const SizedBox(width: 6),
            Text(
              widget.label,
              style: AppTextStyles.bodyMd.copyWith(
                color: widget.color,
                fontWeight: FontWeight.w600,
                fontSize: widget.small ? 12 : 13,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _IconAction extends StatefulWidget {
  const _IconAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.size = 15,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final double size;
  @override
  State<_IconAction> createState() => _IconActionState();
}

class _IconActionState extends State<_IconAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: widget.tooltip,
    child: MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: _hovered ? AppColors.surfaceHigh : Colors.transparent,
          ),
          child: Icon(
            widget.icon,
            size: widget.size,
            color: _hovered ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
      ),
    ),
  );
}

class _ChipBadge extends StatelessWidget {
  const _ChipBadge({required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Text(
      label,
      style: AppTextStyles.labelMd.copyWith(color: color, fontSize: 10),
    ),
  );
}

class _AiPromptBar extends StatefulWidget {
  const _AiPromptBar({
    required this.controller,
    required this.onSubmit,
    required this.placeholder,
  });
  final TextEditingController controller;
  final ValueChanged<String> onSubmit;
  final String placeholder;
  @override
  State<_AiPromptBar> createState() => _AiPromptBarState();
}

class _AiPromptBarState extends State<_AiPromptBar> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: _focused ? AppColors.indigo : AppColors.border,
        width: _focused ? 1.5 : 1,
      ),
      color: AppColors.surfaceHigh,
      boxShadow: _focused
          ? [
              BoxShadow(
                color: AppColors.indigo.withValues(alpha: 0.15),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ]
          : [],
    ),
    child: Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      child: TextField(
        controller: widget.controller,
        style: AppTextStyles.bodyMd,
        onSubmitted: widget.onSubmit,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: AppTextStyles.bodySm,
          border: InputBorder.none,
          fillColor: Colors.transparent,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _GlowButton(
              label: 'Run',
              icon: Icons.send_rounded,
              onTap: () => widget.onSubmit(widget.controller.text),
              color: AppColors.indigo,
              small: true,
            ),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 16,
              color: _focused ? AppColors.indigo : AppColors.textMuted,
            ),
          ),
        ),
      ),
    ),
  );
}
