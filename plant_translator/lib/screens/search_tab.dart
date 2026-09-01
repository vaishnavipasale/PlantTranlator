import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  String _activeFilter = 'All';

  final List<String> _filters = const [
    'All',
    'Easy care',
    'Low light',
    'Pet safe',
    'Air purifying',
  ];

  // Placeholder species data — swap for a real search/API call.
  final List<_SpeciesResult> _allSpecies = const [
    _SpeciesResult('Pothos', 'Epipremnum aureum', ['Easy care', 'Low light', 'Air purifying']),
    _SpeciesResult('Snake Plant', 'Dracaena trifasciata', ['Easy care', 'Low light', 'Air purifying']),
    _SpeciesResult('Fiddle Leaf Fig', 'Ficus lyrata', ['Air purifying']),
    _SpeciesResult('Calathea', 'Calathea orbifolia', ['Pet safe']),
    _SpeciesResult('Spider Plant', 'Chlorophytum comosum', ['Easy care', 'Pet safe', 'Air purifying']),
    _SpeciesResult('Monstera', 'Monstera deliciosa', ['Easy care']),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_SpeciesResult> get _results {
    return _allSpecies.where((s) {
      final matchesQuery = _query.isEmpty ||
          s.name.toLowerCase().contains(_query.toLowerCase()) ||
          s.latinName.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter = _activeFilter == 'All' || s.tags.contains(_activeFilter);
      return matchesQuery && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green50,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Text(
                'Search Plants',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.green900,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text(
                'By name, species, or care needs',
                style: TextStyle(fontSize: 13, color: AppColors.stone600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: _SearchField(
                controller: _controller,
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                itemCount: _filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final filter = _filters[i];
                  final selected = filter == _activeFilter;
                  return _FilterChip(
                    label: filter,
                    selected: selected,
                    onTap: () => setState(() => _activeFilter = filter),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _results.isEmpty
                  ? _EmptyState(query: _query)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: _results.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _SpeciesCard(result: _results[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.green200),
        boxShadow: [
          BoxShadow(
            color: AppColors.green600.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(color: AppColors.green900, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Search plants...',
          hintStyle: TextStyle(color: AppColors.stone400, fontSize: 15),
          prefixIcon: Icon(Icons.search, color: AppColors.green600),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  icon: Icon(Icons.close, color: AppColors.stone400, size: 18),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(colors: [AppColors.green600, AppColors.green500])
              : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.transparent : AppColors.green200,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.green500.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.stone600,
          ),
        ),
      ),
    );
  }
}

class _SpeciesResult {
  const _SpeciesResult(this.name, this.latinName, this.tags);
  final String name;
  final String latinName;
  final List<String> tags;
}

class _SpeciesCard extends StatelessWidget {
  const _SpeciesCard({required this.result});

  final _SpeciesResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.green100),
        boxShadow: [
          BoxShadow(
            color: AppColors.stone400.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.green100, AppColors.green200],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.eco_outlined, color: AppColors.green700, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  result.latinName,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppColors.stone600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: result.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.lime400.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.green700,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.stone400, size: 20),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.green100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search_off_outlined, size: 40, color: AppColors.green600),
            ),
            const SizedBox(height: 16),
            Text(
              query.isEmpty ? 'No plants match this filter' : 'No results for "$query"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.green900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try a different name or clear the filter',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.stone600),
            ),
          ],
        ),
      ),
    );
  }
}