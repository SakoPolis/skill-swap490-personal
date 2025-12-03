import 'package:flutter/material.dart';
import 'request_swap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileScreen extends StatefulWidget {
  final String name;
  final List<Map<String, dynamic>> offers;

  const UserProfileScreen({
    super.key,
    required this.name,
    required this.offers,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<Map<String, dynamic>> myOffers = [];

  @override
  void initState() {
    super.initState();
    _loadMyOffers();
  }

  Future<void> _loadMyOffers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = doc.data();
    if (data == null) return;

    final offersDynamic = data['offers'] as List<dynamic>? ?? [];

    setState(() {
      myOffers = offersDynamic.whereType<Map<String, dynamic>>().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final name = widget.name;
    final offers = widget.offers;

    final topOffers = offers.take(3).toList();

    String initials = '';
    final parts = name.split(' ');
    if (parts.isNotEmpty) {
      initials = parts[0].isNotEmpty ? parts[0][0] : '';
      if (parts.length > 1 && parts[1].isNotEmpty) {
        initials += parts[1][0];
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        child: Text(
                          initials.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Open to swap',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Choose the skills you want to swap with them – like adding an item to your cart.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'What they offer',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (topOffers.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: topOffers.map((offer) {
                        final skillName =
                            (offer['name'] ?? '').toString().trim();
                        final level =
                            (offer['level'] ?? '').toString().trim();
                        final label =
                            level.isEmpty ? skillName : '$skillName • $level';

                        return Chip(
                          label: Text(label),
                          backgroundColor: Colors.blue.shade50,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
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

                  const SizedBox(height: 24),

                  Text(
                    'Details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...offers.map((offer) {
                    final skillName =
                        (offer['name'] ?? '').toString().trim();
                    final description =
                        (offer['description'] ?? '').toString().trim();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black.withOpacity(0.03),
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            skillName.isEmpty ? 'Skill' : skillName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            description.isEmpty
                                ? 'No description yet.'
                                : description,
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RequestSwapScreen(
                                      partnerName: name,
                                      partnerOffers: offers,
                                      myOffers: myOffers,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Request swap?'),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          SafeArea(
            minimum:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RequestSwapScreen(
                        partnerName: name,
                        partnerOffers: offers,
                        myOffers: myOffers,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Request Swap',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
