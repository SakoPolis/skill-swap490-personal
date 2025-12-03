import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestSwapScreen extends StatefulWidget {
  final String partnerName;
  final List<Map<String, dynamic>> partnerOffers;
  final List<Map<String, dynamic>> myOffers;

  const RequestSwapScreen({
    super.key,
    required this.partnerName,
    required this.partnerOffers,
    required this.myOffers,
  });

  @override
  State<RequestSwapScreen> createState() => _RequestSwapScreenState();
}

class _RequestSwapScreenState extends State<RequestSwapScreen> {
  String? _selectedPartnerSkill;
  String? _selectedMySkill;
  final TextEditingController _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (_selectedPartnerSkill == null || _selectedMySkill == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a skill you want and a skill you can offer.',
          ),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be signed in to send a request.'),
        ),
      );
      return;
    }

    final message = _messageController.text.trim();

    setState(() {
      _isSubmitting = true;
    });

    try {
      await FirebaseFirestore.instance.collection('swapRequests').add({
        'fromUserId': user.uid,
        'fromUserEmail': user.email,
        'partnerName': widget.partnerName,
        'requestedSkill': _selectedPartnerSkill,
        'offeredSkill': _selectedMySkill,
        'note': message,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Swap request sent'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send request. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final partnerSkillOptions = widget.partnerOffers
        .map((offer) => (offer['name'] ?? '').toString().trim())
        .where((name) => name.isNotEmpty)
        .toList();

    final mySkillOptions = widget.myOffers
        .map((offer) => (offer['name'] ?? '').toString().trim())
        .where((name) => name.isNotEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Request Swap')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Swap with ${widget.partnerName}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose what you want to learn from them and what you can offer in return.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),

            if (partnerSkillOptions.isNotEmpty) ...[
              Text(
                'Their skills',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: partnerSkillOptions
                    .map(
                      (name) => Chip(
                        label: Text(name),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Skill you want from them',
                border: OutlineInputBorder(),
              ),
              value: _selectedPartnerSkill,
              items: partnerSkillOptions
                  .map(
                    (name) => DropdownMenuItem<String>(
                      value: name,
                      child: Text(name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPartnerSkill = value;
                });
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Skill you will offer',
                border: OutlineInputBorder(),
              ),
              value: _selectedMySkill,
              items: mySkillOptions
                  .map(
                    (name) => DropdownMenuItem<String>(
                      value: name,
                      child: Text(name),
                    ),
                  )
                  .toList(),
              onChanged: mySkillOptions.isEmpty
                  ? null
                  : (value) {
                      setState(() {
                        _selectedMySkill = value;
                      });
                    },
            ),

            if (mySkillOptions.isEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'You don’t have any skills listed yet. Add some to your profile to offer in swaps.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],

            const SizedBox(height: 16),

            TextField(
              controller: _messageController,
              maxLength: 200,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Add a note (optional)',
                hintText: 'Introduce yourself or share what you hope to learn.',
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitRequest,
                child: Text(
                  _isSubmitting ? 'Sending...' : 'Confirm request',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
