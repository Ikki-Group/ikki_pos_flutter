import 'package:flutter/material.dart';

import '../../../widgets/ui/pos_dialog.dart';

class ShowcaseIndexPage extends StatefulWidget {
  const ShowcaseIndexPage({super.key});

  @override
  State<ShowcaseIndexPage> createState() => _ShowcaseIndexPageState();
}

class _ShowcaseIndexPageState extends State<ShowcaseIndexPage> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DialogSection(),
            _TypographySection(),
            _ButtonsSection(),
            _ChipsSection(),
            _FormsSection(),
            _IndicatorsSection(),
            _ListsSection(),
            _ColorsSection(),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.content});

  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
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
}

class _DialogSection extends StatelessWidget {
  const _DialogSection();

  void showSampleOne(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const PosDialog(
        title: 'IKKI COFFEE',
        subtitle: 'Order #001',
        width: 400,
        height: 300,
        children: [
          Placeholder(),
          Placeholder(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Dialog',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () => showSampleOne(context),
            child: const Text('Sample 1'),
          ),
        ],
      ),
    );
  }
}

class _TypographySection extends StatelessWidget {
  const _TypographySection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Typography',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text('Display Large', style: Theme.of(context).textTheme.displayLarge),
          Text('Display Medium', style: Theme.of(context).textTheme.displayMedium),
          Text('Display Small', style: Theme.of(context).textTheme.displaySmall),
          Text('Headline Large', style: Theme.of(context).textTheme.headlineLarge),
          Text('Headline Medium', style: Theme.of(context).textTheme.headlineMedium),
          Text('Headline Small', style: Theme.of(context).textTheme.headlineSmall),
          Text('Title Large', style: Theme.of(context).textTheme.titleLarge),
          Text('Title Medium', style: Theme.of(context).textTheme.titleMedium),
          Text('Title Small', style: Theme.of(context).textTheme.titleSmall),
          Text(
            'Body Large - Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            'Body Medium - Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Body Small - Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text('Label Large', style: Theme.of(context).textTheme.labelLarge),
          Text('Label Medium', style: Theme.of(context).textTheme.labelMedium),
          Text('Label Small', style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _ButtonsSection extends StatelessWidget {
  const _ButtonsSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Buttons',
      content: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 8,
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
              ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              FilledButton(
                onPressed: () {},
                child: const Text('FB'),
              ),
              FilledButton.tonal(
                onPressed: () {},
                child: const Text('FB Tonal'),
              ),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('FB Icon'),
              ),
              FilledButton.tonalIcon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('FB Tonal Icon'),
              ),
              FilledButton.tonalIcon(
                onPressed: null,
                icon: const Icon(Icons.add),
                label: const Text('FB Tonal Icon'),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              OutlinedButton(
                onPressed: () {},
                child: const Text('OB'),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('OB Icon'),
              ),
              OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.add),
                label: const Text('OB'),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('TB'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
                color: Colors.red,
              ),
              IconButton.filled(onPressed: () {}, icon: const Icon(Icons.add)),
              IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.add)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipsSection extends StatelessWidget {
  const _ChipsSection();

  @override
  Widget build(BuildContext context) {
    final categories = <String>['Minuman', 'Makanan', 'Snack', 'Dessert'];

    return _Section(
      title: 'Chips',
      content: Column(
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
                selected: false,
                onSelected: (selected) {},
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
    );
  }
}

class _FormsSection extends StatelessWidget {
  const _FormsSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Forms',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Search Product',
              hintText: 'Enter product name...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {},
          ),
          TextFormField(
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
          SwitchListTile(
            title: const Text('Include Tax'),
            value: false,
            onChanged: (bool value) {},
          ),
          Slider(
            value: 10,
            max: 100,
            divisions: 10,
            label: '10%',
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}

class _IndicatorsSection extends StatelessWidget {
  const _IndicatorsSection();

  @override
  Widget build(BuildContext context) {
    return const _Section(
      title: 'Indicators',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularProgressIndicator(),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListsSection extends StatelessWidget {
  const _ListsSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Lists',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}

class _ColorsSection extends StatelessWidget {
  const _ColorsSection();

  Widget _buildColorPalette(BuildContext context) {
    return Column(
      children: [
        _buildColorRow('Primary Colors', [
          {'name': 'Primary', 'color': Theme.of(context).colorScheme.primary},
          {'name': 'Secondary', 'color': Theme.of(context).colorScheme.secondary},
          {'name': 'Tertiary', 'color': Theme.of(context).colorScheme.tertiary},
        ], context),
        const SizedBox(height: 16),
        _buildColorRow('Surface Colors', [
          {'name': 'Surface', 'color': Theme.of(context).colorScheme.surface},
          {'name': 'Background', 'color': Theme.of(context).colorScheme.surface},
          {'name': 'Card', 'color': Theme.of(context).cardColor},
        ], context),
        const SizedBox(height: 16),
        _buildColorRow('Status Colors', [
          {'name': 'Success', 'color': Colors.green},
          {'name': 'Warning', 'color': Colors.orange},
          {'name': 'Error', 'color': Theme.of(context).colorScheme.error},
        ], context),
      ],
    );
  }

  Widget _buildColorRow(String title, List<Map<String, dynamic>> colors, BuildContext context) {
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
                        border: Border.all(color: Colors.grey.withValues(alpha: .3)),
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

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Colors',
      content: Column(
        children: [
          _buildColorPalette(context),
        ],
      ),
    );
  }
}
