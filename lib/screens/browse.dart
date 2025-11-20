import 'package:flutter/material.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Discover Skills',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //  Search bar
            
TextField(
  decoration: InputDecoration(
    hintText: "Search skills or people...",
    hintStyle: TextStyle(
      color: Colors.grey.shade600,
      fontSize: 15,
    ),
    prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade600),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: Colors.blue.shade400,
        width: 1.4,
      ),
    ),
  ),
  style: const TextStyle(fontSize: 15),
  onChanged: (value) {
    // Later: Firestore query
  },
),

            //  Section Title
            Text(
              "Categories",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 16),

            //  Categories Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.15,
              children: const [
                CategoryTile(icon: Icons.code, label: "Programming"),
                CategoryTile(icon: Icons.palette_rounded, label: "Art & Design"),
                CategoryTile(icon: Icons.language_rounded, label: "Languages"),
                CategoryTile(icon: Icons.fitness_center_rounded, label: "Fitness"),
                CategoryTile(icon: Icons.music_note_rounded, label: "Music"),
                CategoryTile(icon: Icons.kitchen_rounded, label: "Cooking"),
              ],
            ),

            const SizedBox(height: 30),

            //  Section Title
            Text(
              "Featured Mentors",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 16),

            //  Featured Horizontal Cards
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  FeaturedCard(
                    name: "Ava Martinez",
                    skill: "Digital Illustration",
                    rating: 4.9,
                  ),
                  FeaturedCard(
                    name: "Jason Lee",
                    skill: "Weight Training",
                    rating: 4.8,
                  ),
                  FeaturedCard(
                    name: "Mia Park",
                    skill: "Korean Language Tutor",
                    rating: 5.0,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ======================================================
//  CATEGORY TILE WIDGET
// ======================================================

class CategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryTile({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.blue.shade600),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ======================================================
//  FEATURED CARD WIDGET
// ======================================================

class FeaturedCard extends StatelessWidget {
  final String name;
  final String skill;
  final double rating;

  const FeaturedCard({
    super.key,
    required this.name,
    required this.skill,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder 
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            skill,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),

          const Spacer(),

          Row(
            children: [
              const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
