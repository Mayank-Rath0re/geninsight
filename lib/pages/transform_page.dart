import 'package:flutter/material.dart';
import 'package:genbi/components/abs_prompt_field.dart';
import 'package:genbi/components/abs_table.dart';
import 'package:genbi/components/side_drawer.dart';

class TransformPage extends StatefulWidget {
  const TransformPage({super.key});

  @override
  State<TransformPage> createState() => _TransformPageState();
}

class _TransformPageState extends State<TransformPage> {
  TextEditingController promptController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1B2A), // Deep Midnight Blue
              Color(0xFF1B263B), // Dark Navy Blue
              Color(0xFF415A77), // Slate Blue
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(flex: 1, child: Center(child: SideDrawer())),
              const VerticalDivider(),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "BUSINESS ANALYSIS",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 5),

                    // ─── THE FIX: Wrap SingleChildScrollView in Expanded ─────────
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AbsTable(
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
                              rows: const [
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ───────────────────────────────────────────────────────────
                    const SizedBox(height: 10),
                    AbsPromptField(controller: promptController),
                    const SizedBox(
                      height: 10,
                    ), // Optional: Add a little padding at the very bottom
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "HISTORY",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
