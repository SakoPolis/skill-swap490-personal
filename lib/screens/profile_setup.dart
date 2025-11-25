import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  // Basic info controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();

  // For possible validation later if needed
  final _formKey = GlobalKey<FormState>();

  // Category IDs that were selected during sign-up
  List<String> _offerCategoryIds = [];

  // categoryId -> list of skills
  final Map<String, List<_Skill>> _skillsByCategory = {};

  // Keep category metadata consistent with LoginScreen
  static const List<Map<String, String>> _allOfferCategories = [
    {'id': 'technical', 'label': 'Technical'},
    {'id': 'creative', 'label': 'Creative / Artistic'},
    {'id': 'academic', 'label': 'Academic / Educational'},
    {'id': 'business', 'label': 'Business / Professional'},
    {'id': 'trades', 'label': 'Trades / Hands-On'},
    {'id': 'lifestyle', 'label': 'Lifestyle & Personal Dev'},
    {'id': 'social', 'label': 'Social & Community'},
    {'id': 'digital_content', 'label': 'Digital Content / Social Media'},
    {'id': 'career', 'label': 'Career & Tech Advancement'},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _error = 'No logged-in user found.';
          _isLoading = false;
        });
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data() ?? {};

      // Basic info
      _firstNameCtrl.text = (data['firstName'] ?? '').toString();
      _lastNameCtrl.text = (data['lastName'] ?? '').toString();

      // Categories
      final offerCatsDynamic = data['offerCategories'] as List<dynamic>? ?? [];
      _offerCategoryIds = offerCatsDynamic.map((e) => e.toString()).toList();

      // Existing offers, if any
      final offersDynamic = data['offers'] as List<dynamic>? ?? [];
      for (final item in offersDynamic) {
        if (item is Map<String, dynamic>) {
          final cat = item['category']?.toString() ?? 'other';
          final name = item['name']?.toString() ?? '';
          if (name.isEmpty) continue;
          final level = item['level']?.toString() ?? 'beginner';
          final desc = item['description']?.toString() ?? '';

          _skillsByCategory.putIfAbsent(cat, () => []);
          _skillsByCategory[cat]!.add(
            _Skill(
              name: name,
              categoryId: cat,
              level: level,
              description: desc,
            ),
          );
        }
      }

      // Ensure every selected category has an entry in the map
      for (final id in _offerCategoryIds) {
        _skillsByCategory.putIfAbsent(id, () => []);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load profile data.';
        _isLoading = false;
      });
    }
  }

  String _labelForCategory(String id) {
    return _allOfferCategories
            .firstWhere(
              (c) => c['id'] == id,
              orElse: () => {'id': id, 'label': id},
            )['label'] ??
        id;
  }

  /// Returns an example description hint based on category.
  String _exampleDescriptionForCategory(String categoryId) {
    switch (categoryId) {
      case 'technical':
        return 'e.g. 2 years building Flutter apps; I can help with UI, Firebase, and debugging.';
      case 'creative':
        return 'e.g. I do digital illustration and can teach Procreate basics, shading, and color theory.';
      case 'academic':
        return 'e.g. I can tutor intro calculus and help with homework, exam prep, and study tips.';
      case 'business':
        return 'e.g. I’ve run small marketing campaigns and can help with branding, email, and outreach.';
      case 'trades':
        return 'e.g. I can show basic woodworking skills and how to safely use common tools.';
      case 'lifestyle':
        return 'e.g. I help build sustainable habits around fitness, sleep, and productivity.';
      case 'social':
        return 'e.g. I can help with public speaking, confidence, and conversation skills.';
      case 'digital_content':
        return 'e.g. I edit TikToks/Reels and can help with hooks, pacing, and basic editing apps.';
      case 'career':
        return 'e.g. I can review resumes, LinkedIn, and help practice for tech interviews.';
      default:
        return 'e.g. What you can help with, your experience, and what a session with you might look like.';
    }
  }

  Future<void> _showAddSkillDialog(String categoryId) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String level = 'beginner';

    final exampleDescription = _exampleDescriptionForCategory(categoryId);

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add skill for ${_labelForCategory(categoryId)}'),
          content: StatefulBuilder(
            builder: (ctx, setInnerState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Skill name',
                        hintText: 'e.g. Flutter, Guitar, Public Speaking',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: level,
                      decoration: const InputDecoration(
                        labelText: 'Level',
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'beginner', child: Text('Beginner')),
                        DropdownMenuItem(
                            value: 'intermediate',
                            child: Text('Intermediate')),
                        DropdownMenuItem(
                            value: 'advanced', child: Text('Advanced')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setInnerState(() {
                          level = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Description (optional)',
                        hintText: exampleDescription,
                        alignLabelWithHint: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                setState(() {
                  _skillsByCategory[categoryId]!.add(
                    _Skill(
                      name: nameController.text.trim(),
                      categoryId: categoryId,
                      level: level,
                      description: descriptionController.text.trim(),
                    ),
                  );
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    descriptionController.dispose();
  }

  /// New: edit an existing skill when the chip is tapped
  Future<void> _showEditSkillDialog(String categoryId, _Skill skill) async {
    final nameController = TextEditingController(text: skill.name);
    final descriptionController =
        TextEditingController(text: skill.description);
    String level = skill.level;

    final exampleDescription = _exampleDescriptionForCategory(categoryId);

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Edit skill – ${_labelForCategory(categoryId)}'),
          content: StatefulBuilder(
            builder: (ctx, setInnerState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Skill name',
                        hintText: 'e.g. Flutter, Guitar, Public Speaking',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: level,
                      decoration: const InputDecoration(
                        labelText: 'Level',
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'beginner', child: Text('Beginner')),
                        DropdownMenuItem(
                            value: 'intermediate',
                            child: Text('Intermediate')),
                        DropdownMenuItem(
                            value: 'advanced', child: Text('Advanced')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setInnerState(() {
                          level = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Description (optional)',
                        hintText: exampleDescription,
                        alignLabelWithHint: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                setState(() {
                  final list = _skillsByCategory[categoryId]!;
                  final idx = list.indexOf(skill);
                  if (idx != -1) {
                    list[idx] = _Skill(
                      name: nameController.text.trim(),
                      categoryId: categoryId,
                      level: level,
                      description: descriptionController.text.trim(),
                    );
                  }
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    descriptionController.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _error = 'No logged-in user found.';
          _isSaving = false;
        });
        return;
      }

      // Flatten skills into a single list
      final List<Map<String, dynamic>> offers = [];
      _skillsByCategory.forEach((categoryId, skillList) {
        for (final skill in skillList) {
          offers.add({
            'name': skill.name,
            'category': categoryId,
            'level': skill.level,
            'description': skill.description,
          });
        }
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'firstName': _firstNameCtrl.text.trim(),
          'lastName': _lastNameCtrl.text.trim(),
          'offers': offers,
        },
        SetOptions(merge: true),
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/browse');
    } catch (e) {
      setState(() {
        _error = 'Failed to save profile. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set up your profile'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // BASIC INFO SECTION
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Basic info',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameCtrl,
                            decoration: const InputDecoration(
                              labelText: 'First name',
                            ),
                            validator: (v) {
                              // Make this required or optional as you like
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Last name',
                            ),
                            validator: (v) {
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Skills you offer',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add the specific skills you can offer to others. '
                        'We’ll use this to help match you with people who want what you know.',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (_error != null) ...[
                      Text(
                        _error!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    Expanded(
                      child: _offerCategoryIds.isEmpty
                          ? const Center(
                              child: Text(
                                'You have no selected categories yet. '
                                'Go back and choose at least one on the account creation screen.',
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              itemCount: _offerCategoryIds.length,
                              itemBuilder: (context, index) {
                                final catId = _offerCategoryIds[index];
                                final label = _labelForCategory(catId);
                                final skills = _skillsByCategory[catId] ?? [];

                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              label,
                                              style: theme
                                                  .textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(),
                                            TextButton.icon(
                                              onPressed: () =>
                                                  _showAddSkillDialog(catId),
                                              icon: const Icon(Icons.add),
                                              label: const Text('Add skill'),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        if (skills.isEmpty)
                                          Text(
                                            'No skills added yet for this category.',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                    color: Colors.grey[600]),
                                          )
                                        else
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: skills.map((s) {
                                              return InputChip(
                                                label: Text(
                                                    '${s.name} • ${s.level}'),
                                                onPressed: () => _showEditSkillDialog(catId, s),
                                                onDeleted: () {
                                                  setState(() {
                                                    skills.remove(s);
                                                  });
                                                },
                                              );
                                            }).toList(),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Save & continue'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _Skill {
  final String name;
  final String categoryId;
  final String level;
  final String description;

  _Skill({
    required this.name,
    required this.categoryId,
    required this.level,
    this.description = '',
  });
}
