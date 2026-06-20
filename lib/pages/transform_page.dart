import 'package:flutter/material.dart';
import 'package:genbi/components/glass.dart';
import '../components/abs_table.dart';
import '../components/abs_prompt_field.dart';
import '../components/side_drawer.dart';

class TransformPage extends StatefulWidget {
  const TransformPage({super.key});

  @override
  State<TransformPage> createState() => _TransformPageState();
}

class _TransformPageState extends State<TransformPage> {
  final _prompt = TextEditingController();

  @override
  void dispose() {
    _prompt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ── Sidebar ────────────────────────────────────────────────────────
            const Expanded(flex: 1, child: Center(child: SideDrawer())),
            SizedBox(width: 1, child: const GlassDivider(vertical: true)),

            // ── Main area ──────────────────────────────────────────────────────
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PageHeader(title: 'BUSINESS ANALYSIS'),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        child: AbsTable(
                          title: 'Global Mission Control — Fleet Overview',
                          headers: const [
                            'Mission',
                            'Commander',
                            'Origin',
                            'Destination',
                            'Distance',
                            'Duration',
                            'Phase',
                            'Signal',
                          ],
                          rows: _missionRows,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AbsPromptField(
                      controller: _prompt,
                      onSubmit: _handlePrompt,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            SizedBox(width: 1, child: const GlassDivider(vertical: true)),

            // ── History panel ──────────────────────────────────────────────────
            const Expanded(flex: 1, child: _HistoryPanel()),
          ],
        ),
      ),
    );
  }

  void _handlePrompt() {
    // TODO: wire up to AI
    _prompt.clear();
  }
}

// ─── Page header ──────────────────────────────────────────────────────────────
class _PageHeader extends StatelessWidget {
  final String title;
  const _PageHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const GlassDivider(),
      ],
    );
  }
}

// ─── History panel ────────────────────────────────────────────────────────────
class _HistoryPanel extends StatelessWidget {
  const _HistoryPanel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HISTORY',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const GlassDivider(),
          const SizedBox(height: 20),
          // Placeholder empty state
          Center(
            child: Text(
              'No history yet.',
              style: TextStyle(
                color: AppColors.w(0.25),
                fontSize: 13,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Demo data ────────────────────────────────────────────────────────────────
const _missionRows = [
  [
    'Helios I',
    'Maya Okafor',
    'Earth L2',
    'Mars Orbit',
    '78.3 M km',
    '7 months',
    'Transit',
    '98.2%',
  ],
  [
    'Artemis VII',
    'Jin Yuzhu',
    'Lunar Base',
    'Deep Space',
    '4.2 AU',
    '14 months',
    'Cruise',
    '91.7%',
  ],
  [
    'Nova Prime',
    'Lena Fischer',
    'ISS Alpha',
    'Europa',
    '628 M km',
    '26 months',
    'Approach',
    '84.1%',
  ],
  [
    'Drifter IX',
    'Ravi Anand',
    'Mars Olympia',
    'Asteroid Belt',
    '2.1 AU',
    '5 months',
    'Mapping',
    '99.0%',
  ],
  [
    'Callisto III',
    'Sophie Lark',
    'Earth Dock',
    'Callisto',
    '740 M km',
    '28 months',
    'Launch',
    '100%',
  ],
  [
    'Meridian',
    'Omar Al-Said',
    'Titan Base',
    'Saturn Ring',
    '0.9 AU',
    '3 months',
    'Orbit',
    '76.4%',
  ],
  [
    'Echo Voyager',
    'Priya Nair',
    'Venus Station',
    'Sun Probe',
    '41.4 M km',
    '2 months',
    'Final',
    '88.9%',
  ],
  [
    'Specter II',
    'Kai Tanaka',
    'Mars Relay',
    'Phobos',
    '9,400 km',
    '18 days',
    'Docking',
    '97.5%',
  ],
  [
    'Albatross',
    'Isla Monroe',
    'Earth L4',
    'Trojan Belt',
    '5.2 AU',
    '19 months',
    'Cruise',
    '82.3%',
  ],
  [
    'Vega Run',
    'Deniz Kaya',
    'Ganymede Lab',
    'Jupiter Atm.',
    '270,000 km',
    '6 weeks',
    'Descent',
    '71.0%',
  ],
  [
    'Pioneer XII',
    'Amara Diallo',
    'Earth Orbit',
    'Alpha Centauri',
    '4.37 ly',
    '—',
    'Concept',
    '—',
  ],
  [
    'Tangent',
    'Nora Walsh',
    'ISS Beta',
    'Neptune',
    '4.4 B km',
    '40 months',
    'Mid-cruise',
    '63.8%',
  ],
];
