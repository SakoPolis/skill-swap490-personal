import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryResultsScreen extends StatelessWidget {
  final String categoryId;
  final String categoryLabel;

  const CategoryResultsScreen({
    super.key,
    required this.categoryId,
    required this.categoryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          categoryLabel,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load users. Please try again.'),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          final currentUser = FirebaseAuth.instance.currentUser;
          final currentUserId = currentUser?.uid;
          final currentUserEmail = currentUser?.email;

          final filtered = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;

            // ---------- 🚫 Don't show the signed-in user ----------
            if (currentUserId != null || currentUserEmail != null) {
              final docUid = (data['uid'] ?? '').toString();
              final docEmail = (data['email'] ?? '').toString();

              final isSameById = currentUserId != null && doc.id == currentUserId;
              final isSameByUidField =
                  currentUserId != null && docUid.isNotEmpty && docUid == currentUserId;
              final isSameByEmail = currentUserEmail != null &&
                  currentUserEmail.isNotEmpty &&
                  docEmail.isNotEmpty &&
                  docEmail == currentUserEmail;

              if (isSameById || isSameByUidField || isSameByEmail) {
                return false;
              }
            }
            // ----------------------------------------------------

            final offersDynamic = data['offers'] as List<dynamic>? ?? [];
            final offers =
                offersDynamic.whereType<Map<String, dynamic>>().toList();

            if (offers.isEmpty) return false;

            final hasCategory = offers.any((offer) {
              final cat = (offer['category'] ?? '').toString().trim();
              return cat == categoryId;
            });

            return hasCategory;
          }).toList();

          if (filtered.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'No one has listed skills in "$categoryLabel" yet.\nCheck back soon!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final doc = filtered[index];
              final data = doc.data() as Map<String, dynamic>;

              final firstName =
                  (data['firstName'] ?? '').toString().trim();
              final lastName =
                  (data['lastName'] ?? '').toString().trim();
              final fullName = (firstName.isEmpty && lastName.isEmpty)
                  ? 'Unnamed user'
                  : '$firstName $lastName';

              final offersDynamic =
                  data['offers'] as List<dynamic>? ?? [];
              final offers =
                  offersDynamic.whereType<Map<String, dynamic>>().toList();

              // Only keep offers in this category for display
              final categoryOffers = offers.where((offer) {
                final cat = (offer['category'] ?? '').toString().trim();
                return cat == categoryId;
              }).toList();

              return UserSkillCard(
                name: fullName,
                offers: categoryOffers,
              );
            },
          );
        },
      ),
    );
  }
}

// ===================== USER SKILL CARD =====================

class UserSkillCard extends StatelessWidget {
  final String name;
  final List<Map<String, dynamic>> offers;

  const UserSkillCard({
    super.key,
    required this.name,
    required this.offers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Take first 3 skills for chips
    final topOffers = offers.take(3).toList();

    // Use first offer description as preview if available
    String? firstDescription;
    if (offers.isNotEmpty) {
      final raw = offers.first['description']?.toString().trim() ?? '';
      if (raw.isNotEmpty) {
        firstDescription = raw;
      }
    }

    String initials = '';
    final parts = name.split(' ');
    if (parts.isNotEmpty) {
      initials = parts[0].isNotEmpty ? parts[0][0] : '';
      if (parts.length > 1 && parts[1].isNotEmpty) {
        initials += parts[1][0];
      }
    }
    initials = initials.toUpperCase();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + name
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  initials.isEmpty ? 'S' : initials,
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (topOffers.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: topOffers.map((offer) {
                final skillName =
                    (offer['name'] ?? '').toString().trim();
                final level =
                    (offer['level'] ?? '').toString().trim();
                final label =
                    level.isEmpty ? skillName : '$skillName • $level';

                return Chip(
                  label: Text(
                    label,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.blue.shade50,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            )
          else
            Text(
              'No skills listed yet.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),

          if (firstDescription != null) ...[
            const SizedBox(height: 8),
            Text(
              firstDescription,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 13,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.swap_horiz_rounded,
                      size: 18, color: Colors.blue.shade600),
                  const SizedBox(width: 6),
                  Text(
                    "Open to swap",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Later: navigate to full profile / send request
                },
                child: const Text('View details'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
