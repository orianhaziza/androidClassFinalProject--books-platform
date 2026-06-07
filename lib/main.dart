import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AgesChoiceScreen(),
    );
  }
}

class AgesChoiceScreen extends StatefulWidget {
  const AgesChoiceScreen({super.key});

  @override
  State<AgesChoiceScreen> createState() => _AgesChoiceScreenState();
}

class _AgesChoiceScreenState extends State<AgesChoiceScreen> {
  final List<String> options = [
    'ages 0-4', 'ages 4-8', 'ages 8-12',
  ];
  final List<IconData> icons = [
    Icons.child_friendly,
    Icons.child_care,
    Icons.school,
  ];
  int? _selectedIndex;

  void _goToDetail() {
    if (_selectedIndex == null) return;
    // TODO: navigate to the next screen once it exists
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 193, 230, 247),
              Color.fromARGB(255, 244, 231, 192),
              Color.fromARGB(255, 218, 165, 175),
            ],
            stops: [0.0, 0.4, 0.9],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // ─── Header: title on the left, Word + PDF badges on the right ───
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Text(
                            "Choose your\nchild's age:",
                            style: TextStyle(
                              fontFamily: 'MyDancingScript',
                              fontSize: 42,
                              color: Color.fromARGB(255, 176, 39, 119),
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                        ),
                        _formatBadge(
                          label: 'W',
                          icon: Icons.description,
                          tint: const Color.fromARGB(255, 41, 87, 175),
                        ),
                        const SizedBox(width: 10),
                        _formatBadge(
                          label: 'PDF',
                          icon: Icons.picture_as_pdf,
                          tint: const Color.fromARGB(255, 200, 50, 50),
                        ),
                      ],
                    ),
                  ),

                  // ─── Age grid ───
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: options.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) {
                        final isSelected = _selectedIndex == index;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color.fromARGB(255, 253, 218, 238)
                                  : const Color.fromARGB(255, 236, 247, 253),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.15),
                                  blurRadius: 12,
                                  offset: const Offset(4, 6),
                                ),
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(-3, -3),
                                ),
                              ],
                              border: Border.all(
                                color: isSelected
                                    ? const Color.fromARGB(255, 176, 39, 119)
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(icons[index], size: 40),
                                const SizedBox(height: 8),
                                Text(
                                  options[index],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 90),
                ],
              ),

              // ─── Forward FAB ───
              Positioned(
                bottom: 20,
                right: 20,
                child: AnimatedOpacity(
                  opacity: _selectedIndex == null ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  child: IgnorePointer(
                    ignoring: _selectedIndex == null,
                    child: FloatingActionButton(
                      onPressed: _goToDetail,
                      backgroundColor: const Color.fromARGB(255, 176, 39, 119),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Small file-format badge used in the header (Word / PDF).
  Widget _formatBadge({
    required String label,
    required IconData icon,
    required Color tint,
  }) {
    return Container(
      width: 50,
      height: 55,
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}