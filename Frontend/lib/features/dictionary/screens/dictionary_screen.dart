import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/gradient_app_bar.dart';
import '../../../app/navigation/app_routes.dart';
import '../../../core/models/word_model.dart';
import '../data/mock_dictionary_data.dart';
import '../widgets/dictionary_word_card.dart';

enum DictionaryTab { all, favorites, phrases }

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final searchCtrl = TextEditingController();

  DictionaryTab tab = DictionaryTab.all;
  String selectedCategory = 'All';

  // Frontend-only favorites storage (later: database)
  final Set<String> favoriteIds = {};

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  List<WordModel> _filteredWords() {
    final all = MockDictionaryData.words;

    final q = searchCtrl.text.trim().toLowerCase();

    Iterable<WordModel> list = all;

    // Tab filter
    if (tab == DictionaryTab.favorites) {
      list = list.where((w) => favoriteIds.contains(w.id));
    } else if (tab == DictionaryTab.phrases) {
      list = list.where((w) => w.category.toLowerCase() == 'phrases');
    }

    // Category filter
    if (selectedCategory != 'All') {
      list = list.where((w) => w.category == selectedCategory);
    }

    // Search filter (search Urdu + English + category)
    if (q.isNotEmpty) {
      list = list.where((w) =>
          w.urdu.toLowerCase().contains(q) ||
          w.english.toLowerCase().contains(q) ||
          w.category.toLowerCase().contains(q));
    }

    return list.toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories = MockDictionaryData.categories(MockDictionaryData.words);
    final results = _filteredWords();

    return Scaffold(
      appBar: const GradientAppBar(title: 'Dictionary'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              TextField(
                controller: searchCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search signs...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchCtrl.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            searchCtrl.clear();
                            setState(() {});
                          },
                        ),
                ),
              ),

              const SizedBox(height: 12),

              // Tabs: All / Favorites / Phrases (chip style)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _TabChip(
                      label: 'All Signs',
                      selected: tab == DictionaryTab.all,
                      onTap: () => setState(() => tab = DictionaryTab.all),
                    ),
                    const SizedBox(width: 8),
                    _TabChip(
                      label: 'Favorites',
                      selected: tab == DictionaryTab.favorites,
                      onTap: () => setState(() => tab = DictionaryTab.favorites),
                    ),
                    const SizedBox(width: 8),
                    _TabChip(
                      label: 'Phrases',
                      selected: tab == DictionaryTab.phrases,
                      onTap: () => setState(() => tab = DictionaryTab.phrases),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Categories (like your screenshot)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((c) {
                    final selected = selectedCategory == c;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(c),
                        selected: selected,
                        onSelected: (_) => setState(() => selectedCategory = c),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                '${results.length} signs',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black54),
              ),

              const SizedBox(height: 10),

              // Results list
              Expanded(
                child: results.isEmpty
                    ? const Center(child: Text('No results found'))
                    : ListView.separated(
                        itemCount: results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final w = results[i];
                          final isFav = favoriteIds.contains(w.id);

                          return DictionaryWordCard(
                            word: w,
                            isFavorite: isFav,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.wordDetail,
                                arguments: w,
                              );
                            },
                            onToggleFavorite: () {
                              setState(() {
                                if (isFav) {
                                  favoriteIds.remove(w.id);
                                } else {
                                  favoriteIds.add(w.id);
                                }
                              });
                            },
                            onPlay: () {
                              // Video later: open player screen or show bottom sheet
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Play video for: ${w.english} (later)'),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
