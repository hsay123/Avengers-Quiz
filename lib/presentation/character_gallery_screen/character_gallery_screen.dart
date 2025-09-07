import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/character_card_widget.dart';
import './widgets/character_detail_modal.dart';
import './widgets/empty_search_widget.dart';
import './widgets/quick_actions_modal.dart';
import './widgets/search_bar_widget.dart';
import './widgets/sort_options_modal.dart';

class CharacterGalleryScreen extends StatefulWidget {
  const CharacterGalleryScreen({Key? key}) : super(key: key);

  @override
  State<CharacterGalleryScreen> createState() => _CharacterGalleryScreenState();
}

class _CharacterGalleryScreenState extends State<CharacterGalleryScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _currentSort = 'alphabetical';
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredCharacters = [];
  bool _isRandomizing = false;

  late AnimationController _randomAnimationController;
  late Animation<double> _randomAnimation;

  final List<Map<String, dynamic>> _allCharacters = [
    {
      "id": 1,
      "name": "Iron Man",
      "alias": "Tony Stark",
      "avatar":
          "assets/images/ironman.jpg",
      "description": "Genius billionaire inventor with powered armor suit",
      "biography":
          "Tony Stark is a genius inventor and billionaire industrialist who created the Iron Man armor after being captured by terrorists. Using his intellect and resources, he became one of the founding members of the Avengers and a key figure in protecting Earth from various threats.",
      "powers":
          "Genius-level intellect, powered armor suit with flight capabilities, repulsor rays, advanced weaponry, and arc reactor technology. Master engineer and strategist.",
      "personalityAnalysis":
          "Tony Stark exhibits traits of confidence, innovation, and leadership. He's known for his wit, determination, and willingness to sacrifice for the greater good, though he can be arrogant and impulsive at times.",
      "traits": ["Genius", "Innovative", "Confident", "Witty", "Leader"],
      "team": "Avengers",
      "popularity": 95
    },
    {
      "id": 2,
      "name": "Captain America",
      "alias": "Steve Rogers",
      "avatar":
          "assets/images/captan america.jpg",
      "description":
          "Super soldier with enhanced abilities and vibranium shield",
      "biography":
          "Steve Rogers was a frail young man who volunteered for the Super Soldier program during World War II. Enhanced to peak human potential, he became Captain America and led the fight against HYDRA before being frozen in ice for decades.",
      "powers":
          "Enhanced strength, speed, agility, and endurance. Master tactician and hand-to-hand combatant. Wields an indestructible vibranium shield.",
      "personalityAnalysis":
          "Steve Rogers embodies honor, courage, and unwavering moral principles. He's a natural leader who inspires others and never gives up, even when facing impossible odds.",
      "traits": ["Honorable", "Brave", "Leader", "Loyal", "Determined"],
      "team": "Avengers",
      "popularity": 92
    },
    {
      "id": 3,
      "name": "Thor",
      "alias": "God of Thunder",
      "avatar":
          "assets/images/Thor.jpg",
      "description": "Asgardian god with control over lightning and thunder",
      "biography":
          "Thor is the Asgardian God of Thunder and heir to the throne of Asgard. Banished to Earth by his father Odin to learn humility, he became one of Earth's mightiest defenders and a founding member of the Avengers.",
      "powers":
          "Superhuman strength, durability, and longevity. Control over lightning and thunder. Wields the enchanted hammer Mjolnir, which grants him flight and weather manipulation.",
      "personalityAnalysis":
          "Thor is noble, brave, and sometimes impetuous. He has a strong sense of honor and duty, though he can be prideful. His time on Earth has taught him humility and compassion.",
      "traits": ["Noble", "Powerful", "Brave", "Honorable", "Protective"],
      "team": "Avengers",
      "popularity": 89
    },
    {
      "id": 4,
      "name": "Hulk",
      "alias": "Bruce Banner",
      "avatar":
          "assets/images/Hulk.jpg",
      "description":
          "Scientist who transforms into a powerful green giant when angry",
      "biography":
          "Dr. Bruce Banner is a brilliant scientist who was exposed to gamma radiation during an experiment gone wrong. This exposure causes him to transform into the Hulk, a powerful green creature, whenever he experiences intense emotions.",
      "powers":
          "Transforms into the Hulk with virtually unlimited strength that increases with anger. Superhuman durability, healing factor, and immunity to diseases.",
      "personalityAnalysis":
          "Bruce Banner is intelligent, compassionate, and struggles with controlling his anger. The Hulk represents his suppressed emotions and desire for acceptance, often acting as both protector and destroyer.",
      "traits": [
        "Intelligent",
        "Powerful",
        "Conflicted",
        "Protective",
        "Misunderstood"
      ],
      "team": "Avengers",
      "popularity": 87
    },
    {
      "id": 5,
      "name": "Black Widow",
      "alias": "Natasha Romanoff",
      "avatar":
          "assets/images/blackwido.jpg",
      "description": "Master spy and assassin with exceptional combat skills",
      "biography":
          "Natasha Romanoff was trained from childhood in the Red Room program to become a deadly assassin. She later defected and joined S.H.I.E.L.D., becoming a key member of the Avengers and using her skills to protect the innocent.",
      "powers":
          "Master martial artist, expert marksman, skilled in espionage and infiltration. Enhanced agility and reflexes through training and conditioning.",
      "personalityAnalysis":
          "Natasha is pragmatic, loyal, and haunted by her past. She's incredibly skilled and resourceful, with a strong desire to atone for her previous actions by protecting others.",
      "traits": ["Skilled", "Loyal", "Pragmatic", "Determined", "Secretive"],
      "team": "Avengers",
      "popularity": 85
    },
    {
      "id": 6,
      "name": "Hawkeye",
      "alias": "Clint Barton",
      "avatar":
          "assets/images/Hawkeye.jpg",
      "description": "Master archer with perfect aim and tactical expertise",
      "biography":
          "Clint Barton is a master archer who was recruited by S.H.I.E.L.D. and became a founding member of the Avengers. Despite having no superpowers, his exceptional marksmanship and tactical skills make him invaluable to the team.",
      "powers":
          "Perfect marksmanship with bow and arrow, expert hand-to-hand combatant, tactical genius, and exceptional reflexes.",
      "personalityAnalysis":
          "Clint is down-to-earth, loyal, and family-oriented. He provides a human perspective to the team and is known for his dry humor and unwavering dedication to his friends and family.",
      "traits": ["Precise", "Loyal", "Grounded", "Tactical", "Family-oriented"],
      "team": "Avengers",
      "popularity": 78
    },
    {
      "id": 7,
      "name": "Spider-Man",
      "alias": "Peter Parker",
      "avatar":
          "assets/images/spiderman.jpg",
      "description":
          "Web-slinging hero with spider powers and great responsibility",
      "biography":
          "Peter Parker gained spider powers after being bitten by a radioactive spider. Learning that with great power comes great responsibility, he became Spider-Man to protect New York City and later joined the Avengers.",
      "powers":
          "Superhuman strength, speed, agility, and reflexes. Wall-crawling abilities, spider-sense danger detection, and web-shooters for swinging and combat.",
      "personalityAnalysis":
          "Peter is intelligent, witty, and has a strong moral compass. He struggles to balance his personal life with his responsibilities as Spider-Man, often making sacrifices for the greater good.",
      "traits": ["Witty", "Responsible", "Intelligent", "Agile", "Caring"],
      "team": "Avengers",
      "popularity": 94
    },
    {
      "id": 8,
      "name": "Doctor Strange",
      "alias": "Stephen Strange",
      "avatar":
          "assets/images/doctor.jpg",
      "description": "Master of the mystic arts and Sorcerer Supreme",
      "biography":
          "Dr. Stephen Strange was a brilliant but arrogant surgeon who lost the use of his hands in a car accident. Seeking healing, he discovered the mystic arts and became the Sorcerer Supreme, protecting Earth from mystical threats.",
      "powers":
          "Master of the mystic arts, reality manipulation, dimensional travel, astral projection, and time manipulation. Wields powerful artifacts like the Eye of Agamotto.",
      "personalityAnalysis":
          "Strange is intelligent, determined, and initially arrogant. His journey taught him humility and the importance of serving others, though he retains his sharp wit and analytical mind.",
      "traits": [
        "Mystical",
        "Intelligent",
        "Determined",
        "Analytical",
        "Protective"
      ],
      "team": "Avengers",
      "popularity": 82
    }
  ];

  @override
  void initState() {
    super.initState();
    _filteredCharacters = List.from(_allCharacters);
    _sortCharacters();

    _randomAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _randomAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _randomAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _randomAnimationController.dispose();
    super.dispose();
  }

  void _filterCharacters(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCharacters = List.from(_allCharacters);
      } else {
        _filteredCharacters = _allCharacters.where((character) {
          final name = (character["name"] as String).toLowerCase();
          final alias = (character["alias"] as String).toLowerCase();
          final description =
              (character["description"] as String).toLowerCase();
          final searchLower = query.toLowerCase();

          return name.contains(searchLower) ||
              alias.contains(searchLower) ||
              description.contains(searchLower);
        }).toList();
      }
      _sortCharacters();
    });
  }

  void _sortCharacters() {
    setState(() {
      switch (_currentSort) {
        case 'alphabetical':
          _filteredCharacters.sort(
              (a, b) => (a["name"] as String).compareTo(b["name"] as String));
          break;
        case 'popularity':
          _filteredCharacters.sort((a, b) =>
              (b["popularity"] as int).compareTo(a["popularity"] as int));
          break;
        case 'team':
          _filteredCharacters.sort(
              (a, b) => (a["team"] as String).compareTo(b["team"] as String));
          break;
      }
    });
  }

  void _showCharacterDetail(Map<String, dynamic> character) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CharacterDetailModal(character: character),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortOptionsModal(
        currentSort: _currentSort,
        onSortSelected: (sort) {
          setState(() {
            _currentSort = sort;
          });
          _sortCharacters();
        },
      ),
    );
  }

  void _showQuickActions(Map<String, dynamic> character) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickActionsModal(
        character: character,
        onFavorite: () => _addToFavorites(character),
        onShare: () => _shareCharacter(character),
        onCompare: () => _compareWithQuizResult(character),
      ),
    );
  }

  void _addToFavorites(Map<String, dynamic> character) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${character["name"]} added to favorites!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _shareCharacter(Map<String, dynamic> character) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${character["name"]}...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _compareWithQuizResult(Map<String, dynamic> character) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Comparing ${character["name"]} with your quiz result...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _randomCharacter() async {
    if (_isRandomizing) return;

    setState(() {
      _isRandomizing = true;
    });

    _randomAnimationController.forward();

    await Future.delayed(Duration(milliseconds: 1500));

    final random = Random();
    final randomCharacter =
        _allCharacters[random.nextInt(_allCharacters.length)];

    _randomAnimationController.reset();
    setState(() {
      _isRandomizing = false;
    });

    _showCharacterDetail(randomCharacter);
  }

  void _clearSearch() {
    _searchController.clear();
    _filterCharacters('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SearchBarWidget(
              controller: _searchController,
              onChanged: _filterCharacters,
              onSortPressed: _showSortOptions,
            ),
            Expanded(
              child: _filteredCharacters.isEmpty && _searchQuery.isNotEmpty
                  ? EmptySearchWidget(
                      searchQuery: _searchQuery,
                      onClearSearch: _clearSearch,
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(Duration(milliseconds: 1000));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Character database updated!'),
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.primary,
                          ),
                        );
                      },
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(4.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _getCrossAxisCount(),
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 4.w,
                          mainAxisSpacing: 2.h,
                        ),
                        itemCount: _filteredCharacters.length,
                        itemBuilder: (context, index) {
                          final character = _filteredCharacters[index];
                          return CharacterCardWidget(
                            character: character,
                            onTap: () => _showCharacterDetail(character),
                            onLongPress: () => _showQuickActions(character),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _randomCharacter,
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
        icon: AnimatedBuilder(
          animation: _randomAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _randomAnimation.value,
              child: CustomIconWidget(
                iconName: 'shuffle',
                color: AppTheme.lightTheme.colorScheme.onSecondary,
                size: 6.w,
              ),
            );
          },
        ),
        label: Text(
          _isRandomizing ? 'Randomizing...' : 'Random',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  int _getCrossAxisCount() {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 900) return 4; // Large tablets
    if (screenWidth > 600) return 3; // Small tablets
    return 2; // Mobile
  }
}
