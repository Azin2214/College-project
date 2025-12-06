import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchWorkerPage(),
    ),
  );
}

// --- 1. Data Model (Mock Data) ---
class Worker {
  final String name;
  final String profession;
  final String imageUrl;
  final double wage;
  final String wageUnit;
  final double rating;
  final int reviews;
  final bool isAvailable;

  Worker({
    required this.name,
    required this.profession,
    required this.imageUrl,
    required this.wage,
    required this.wageUnit,
    required this.rating,
    required this.reviews,
    required this.isAvailable,
  });
}

// --- 2. Main Screen ---
class SearchWorkerPage extends StatefulWidget {
  const SearchWorkerPage({super.key});

  @override
  State<SearchWorkerPage> createState() => _SearchWorkerPageState();
}

class _SearchWorkerPageState extends State<SearchWorkerPage> {
  final TextEditingController _searchController = TextEditingController();

  // Dummy Data Generation
  final List<Worker> _workers = [
    Worker(
      name: "Fadil TP",
      profession: "Plumber",
      imageUrl:
          "https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=500&auto=format&fit=crop&q=60",
      wage: 150,
      wageUnit: "hr",
      rating: 4.8,
      reviews: 120,
      isAvailable: true,
    ),
    Worker(
      name: "Sarah Jenkins",
      profession: "Electrician",
      imageUrl:
          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60",
      wage: 200,
      wageUnit: "hr",
      rating: 4.9,
      reviews: 85,
      isAvailable: true,
    ),
    Worker(
      name: "Rajesh Kumar",
      profession: "Carpenter",
      imageUrl:
          "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=500&auto=format&fit=crop&q=60",
      wage: 800,
      wageUnit: "day",
      rating: 4.5,
      reviews: 45,
      isAvailable: false,
    ),
    Worker(
      name: "Emily Chen",
      profession: "Cleaner",
      imageUrl:
          "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=500&auto=format&fit=crop&q=60",
      wage: 120,
      wageUnit: "hr",
      rating: 4.7,
      reviews: 200,
      isAvailable: true,
    ),
    Worker(
      name: "Michael Ross",
      profession: "Painter",
      imageUrl:
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&auto=format&fit=crop&q=60",
      wage: 1500,
      wageUnit: "day",
      rating: 4.6,
      reviews: 30,
      isAvailable: true,
    ),
    Worker(
      name: "David Miller",
      profession: "Mechanic",
      imageUrl:
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=500&auto=format&fit=crop&q=60",
      wage: 300,
      wageUnit: "hr",
      rating: 4.9,
      reviews: 150,
      isAvailable: true,
    ),
  ];

  List<Worker> _filteredWorkers = [];
  final List<String> _categories = [
    "All",
    "Plumber",
    "Electrician",
    "Carpenter",
    "Painter",
  ];
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _filteredWorkers = _workers;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    filterWorkers();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    filterWorkers();
  }

  void filterWorkers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredWorkers = _workers.where((worker) {
        final matchesQuery =
            worker.name.toLowerCase().contains(query) ||
            worker.profession.toLowerCase().contains(query);
        final matchesCategory =
            _selectedCategory == "All" ||
            worker.profession == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Professional Color Palette
    final primaryColor = Colors.indigo.shade600;
    final backgroundColor = Colors.grey.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // --- Header Section ---
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Find Expert",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Workers Nearby",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.indigo.shade50,
                        child: IconButton(
                          icon: Icon(
                            Icons.notifications_outlined,
                            color: primaryColor,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search name or profession...",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.tune,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Categories Filter
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return GestureDetector(
                          onTap: () => _onCategorySelected(category),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? primaryColor : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? primaryColor
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // --- Worker List ---
            Expanded(
              child: _filteredWorkers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "No workers found",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredWorkers.length,
                      itemBuilder: (context, index) {
                        final worker = _filteredWorkers[index];
                        return AnimationConfiguration(
                          index: index,
                          child: WorkerCard(worker: worker),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 3. Custom Worker Card Widget ---
class WorkerCard extends StatelessWidget {
  final Worker worker;

  const WorkerCard({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigate to detail page
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Stack(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(worker.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (worker.isAvailable)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade400,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            worker.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  worker.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        worker.profession,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "₹${worker.wage.toInt()}",
                                  style: TextStyle(
                                    color: Colors.indigo.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(
                                  text: "/${worker.wageUnit}",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 32,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                              child: const Text(
                                "Request",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- 4. Simple Animation Wrapper (Slide + Fade) ---
class AnimationConfiguration extends StatefulWidget {
  final int index;
  final Widget child;

  const AnimationConfiguration({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  State<AnimationConfiguration> createState() => _AnimationConfigurationState();
}

class _AnimationConfigurationState extends State<AnimationConfiguration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Stagger effect based on index
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
