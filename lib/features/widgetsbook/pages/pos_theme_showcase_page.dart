import 'package:flutter/material.dart';

import '../../../core/config/pos_theme.dart';
import '../../../widgets/ui/button_variants.dart';

// Import your POSTheme class here
// import 'pos_theme.dart';

class POSThemeShowcasePage extends StatefulWidget {
  const POSThemeShowcasePage({super.key});

  @override
  POSThemeShowcasePageState createState() => POSThemeShowcasePageState();
}

class POSThemeShowcasePageState extends State<POSThemeShowcasePage> {
  String _selectedCategory = 'Minuman';
  bool _switchValue = true;
  double _sliderValue = 50;
  String _searchText = '';

  final List<String> categories = ['Minuman', 'Makanan', 'Snack', 'Dessert'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POS Theme Showcase'),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ButtonExamples(),

            // Typography Section
            _buildSection(
              'Typography',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Display Large', style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(height: 8),
                  Text('Display Medium', style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 8),
                  Text('Display Small', style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 16),
                  Text('Headline Large', style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 8),
                  Text('Headline Medium', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('Headline Small', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Text('Title Large', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Title Medium', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Title Small', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 16),
                  Text(
                    'Body Large - Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Body Medium - Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Body Small - Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Text('Label Large', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Text('Label Medium', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 8),
                  Text('Label Small', style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ),

            // Custom Text Styles
            _buildSection(
              'Custom POS Text Styles',
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Header Title', style: POSTextStyles.headerTitle),
                  SizedBox(height: 8),
                  Text('Card Title', style: POSTextStyles.cardTitle),
                  SizedBox(height: 8),
                  Text('Card Subtitle', style: POSTextStyles.cardSubtitle),
                  SizedBox(height: 8),
                  Text('Button Text', style: POSTextStyles.buttonText),
                  SizedBox(height: 8),
                  Text('Rp 25.000', style: POSTextStyles.priceText),
                  SizedBox(height: 8),
                  Text('Category Text', style: POSTextStyles.categoryText),
                ],
              ),
            ),

            // Buttons Section
            _buildSection(
              'Buttons',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Elevated Buttons
                  Text('Elevated Buttons', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Primary Button'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('Add Item'),
                      ),
                      const ElevatedButton(
                        onPressed: null,
                        child: Text('Disabled'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Outlined Buttons
                  Text('Outlined Buttons', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Secondary Button'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                      const OutlinedButton(
                        onPressed: null,
                        child: Text('Disabled'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Text Buttons
                  Text('Text Buttons', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Text Button'),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                      ),
                      const TextButton(
                        onPressed: null,
                        child: Text('Disabled'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Floating Action Button
                  Text('Floating Action Button', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FloatingActionButton(
                        onPressed: () {},
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(width: 16),
                      FloatingActionButton.extended(
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Checkout'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Cards Section
            _buildSection(
              'Cards',
              Column(
                children: [
                  // Basic Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Basic Card', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(
                            'This is a basic card with default styling.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Product Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.local_drink,
                              color: Theme.of(context).colorScheme.primary,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ICE COFFEE', style: POSTextStyles.cardTitle),
                                SizedBox(height: 4),
                                Text('Kategori: Minuman', style: POSTextStyles.cardSubtitle),
                                SizedBox(height: 8),
                                Text('Rp 15.000', style: POSTextStyles.priceText),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Transaction Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Order #001', style: POSTextStyles.cardTitle),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Completed',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text('Dine In - 2 items', style: POSTextStyles.cardSubtitle),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total:', style: Theme.of(context).textTheme.bodyMedium),
                              const Text('Rp 35.000', style: POSTextStyles.priceText),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form Elements
            _buildSection(
              'Form Elements',
              Column(
                children: [
                  // Text Fields
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search Product',
                      hintText: 'Enter product name...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Customer Name',
                      hintText: 'Enter customer name...',
                      prefixIcon: const Icon(Icons.person),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Payment Method',
                      prefixIcon: Icon(Icons.payment),
                    ),
                    items: ['Cash', 'Credit Card', 'Debit Card', 'E-Wallet']
                        .map(
                          (method) => DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),

                  // Switch
                  SwitchListTile(
                    title: const Text('Include Tax'),
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() {
                        _switchValue = value;
                      });
                    },
                  ),

                  // Slider
                  ListTile(
                    title: Text('Discount (${_sliderValue.round()}%)'),
                    subtitle: Slider(
                      value: _sliderValue,
                      max: 100,
                      divisions: 10,
                      label: '${_sliderValue.round()}%',
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Chips Section
            _buildSection(
              'Chips & Categories',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category Selection', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((category) {
                      return ChoiceChip(
                        label: Text(category),
                        showCheckmark: false,
                        checkmarkColor: Colors.white,
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  Text('Filter Chips', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Available'),
                        selected: true,
                        onSelected: (selected) {},
                      ),
                      FilterChip(
                        label: const Text('Promotions'),
                        onSelected: (selected) {},
                      ),
                      FilterChip(
                        label: const Text('New Items'),
                        onSelected: (selected) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text('Action Chips', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        label: const Text('Add to Cart'),
                        avatar: const Icon(Icons.add_shopping_cart, size: 18),
                        onPressed: () {},
                      ),
                      ActionChip(
                        label: const Text('Quick Sale'),
                        avatar: const Icon(Icons.flash_on, size: 18),
                        onPressed: () {},
                      ),
                      ActionChip(
                        label: const Text('Print Receipt'),
                        avatar: const Icon(Icons.print, size: 18),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Status Indicators
            _buildSection(
              'Status Indicators',
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatusIndicator('Success', Colors.green, Icons.check_circle),
                      _buildStatusIndicator('Warning', Colors.orange, Icons.warning),
                      _buildStatusIndicator('Error', Colors.red, Icons.error),
                      _buildStatusIndicator('Info', Colors.blue, Icons.info),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Progress Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 8),
                          Text('Loading', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: LinearProgressIndicator(value: 0.7),
                          ),
                          const SizedBox(height: 8),
                          Text('70%', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Lists
            _buildSection(
              'Lists',
              Column(
                children: [
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.receipt),
                          title: const Text('Transaction History'),
                          subtitle: const Text('View all transactions'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.inventory),
                          title: const Text('Inventory'),
                          subtitle: const Text('Manage products'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.analytics),
                          title: const Text('Reports'),
                          subtitle: const Text('Sales analytics'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Color Palette
            _buildSection(
              'Color Palette',
              Column(
                children: [
                  _buildColorPalette(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String label, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildColorPalette() {
    return Column(
      children: [
        _buildColorRow('Primary Colors', [
          {'name': 'Primary', 'color': Theme.of(context).colorScheme.primary},
          {'name': 'Secondary', 'color': Theme.of(context).colorScheme.secondary},
          {'name': 'Tertiary', 'color': Theme.of(context).colorScheme.tertiary},
        ]),
        const SizedBox(height: 16),
        _buildColorRow('Surface Colors', [
          {'name': 'Surface', 'color': Theme.of(context).colorScheme.surface},
          {'name': 'Background', 'color': Theme.of(context).colorScheme.surface},
          {'name': 'Card', 'color': Theme.of(context).cardColor},
        ]),
        const SizedBox(height: 16),
        _buildColorRow('Status Colors', [
          {'name': 'Success', 'color': Colors.green},
          {'name': 'Warning', 'color': Colors.orange},
          {'name': 'Error', 'color': Theme.of(context).colorScheme.error},
        ]),
      ],
    );
  }

  Widget _buildColorRow(String title, List<Map<String, dynamic>> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: colors.map((colorData) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: colorData['color'] as Color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      colorData['name'] as String,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
