import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WorkerHomePage extends StatelessWidget {
  WorkerHomePage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ImageProvider userImage = const AssetImage("assets/user_avatar.png");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FA),
      drawer: _buildDrawer(context),
      body: CustomScrollView(
        slivers: [
          // ================= APP BAR =================
          SliverAppBar(
            expandedHeight: 220,
            collapsedHeight: 90,
            pinned: true,
            floating: true,
            backgroundColor: const Color(0xFF059669),
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.inbox_rounded, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const InboxPage()),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✅ CENTERED AVATAR IN APPBAR
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                    child: CircleAvatar(radius: 28, backgroundImage: userImage),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Welcome back!",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const Text(
                    "John Carter",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ================= BODY =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader("Available Jobs", "Find nearby work"),
                  const SizedBox(height: 16),
                  _buildJobList(),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF059669),
        icon: const Icon(Icons.search, color: Colors.white),
        label: const Text("Find Jobs"),
      ).animate(delay: 300.ms).slideY(begin: 1, end: 0),
    );
  }

  // ================= DRAWER =================

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            color: const Color(0xFF059669),
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                    child: CircleAvatar(radius: 44, backgroundImage: userImage),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "John Carter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Electrician",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.work),
            title: const Text("My Jobs"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyJobsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text("Schedule"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SchedulePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text("Ratings"),
            onTap: () {},
          ),
          const Spacer(),
          const ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ================= SECTIONS =================

  Widget _sectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildJobList() {
    return Column(
      children: const [
        _JobCard(
          title: "Plumbing Repair",
          description: "Kitchen pipe leak",
          price: "₹1,500",
        ),
        SizedBox(height: 12),
        _JobCard(
          title: "Electrical Wiring",
          description: "New house wiring",
          price: "₹3,000",
        ),
      ],
    );
  }
}

// ================= COMPONENTS =================

class _JobCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;

  const _JobCard({
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Text(
          price,
          style: const TextStyle(
            color: Color(0xFF059669),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ================= EXTRA PAGES =================

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
        backgroundColor: const Color(0xFF059669),
      ),
      body: const Center(child: Text("Inbox Page")),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF059669),
      ),
      body: const Center(
        child: Text("Worker Profile Page", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

class MyJobsPage extends StatelessWidget {
  const MyJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Jobs")),
      body: const Center(child: Text("My Jobs Page")),
    );
  }
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Schedule")),
      body: const Center(child: Text("Schedule Page")),
    );
  }
}
