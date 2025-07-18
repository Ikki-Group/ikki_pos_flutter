import 'package:flutter/material.dart';

class PaymentMethod {
  PaymentMethod({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isEnabled = true,
  });
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isEnabled;
}

class PaymentSplit {
  PaymentSplit({
    required this.id,
    required this.paymentMethodId,
    required this.amount,
    this.customCashAmount,
  });
  final String id;
  final String paymentMethodId;
  final double amount;
  final String? customCashAmount;
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;

  final double totalAmount = 21;
  List<PaymentSplit> paymentSplits = [];
  String selectedPaymentMethod = '';
  TextEditingController customCashController = TextEditingController();
  bool isSplitBillEnabled = false;

  final List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: 'cash',
      name: 'Cash',
      subtitle: 'Tunai',
      icon: Icons.payments,
      color: const Color(0xFF4CAF50),
    ),
    PaymentMethod(
      id: 'qris',
      name: 'QRIS',
      subtitle: 'Scan QR Code',
      icon: Icons.qr_code_scanner,
      color: const Color(0xFF2196F3),
    ),
    PaymentMethod(
      id: 'debit',
      name: 'Debit Card',
      subtitle: 'Kartu Debit',
      icon: Icons.credit_card,
      color: const Color(0xFF607D8B),
    ),
    PaymentMethod(
      id: 'credit',
      name: 'Credit Card',
      subtitle: 'Kartu Kredit',
      icon: Icons.credit_card,
      color: const Color(0xFF9C27B0),
    ),
    PaymentMethod(
      id: 'ewallet',
      name: 'E-Wallet',
      subtitle: 'GoPay, OVO, Dana',
      icon: Icons.account_balance_wallet,
      color: const Color(0xFFFF9800),
    ),
    PaymentMethod(
      id: 'transfer',
      name: 'Bank Transfer',
      subtitle: 'Transfer Bank',
      icon: Icons.account_balance,
      color: const Color(0xFF795548),
    ),
  ];

  final List<double> cashRecommendations = [25.00, 30.00, 50.00, 100.00];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Initialize with single payment
    paymentSplits = [
      PaymentSplit(
        id: '1',
        paymentMethodId: '',
        amount: totalAmount,
      ),
    ];

    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    customCashController.dispose();
    super.dispose();
  }

  void _toggleSplitBill() {
    setState(() {
      isSplitBillEnabled = !isSplitBillEnabled;
      if (isSplitBillEnabled) {
        paymentSplits = [
          PaymentSplit(id: '1', paymentMethodId: '', amount: totalAmount / 2),
          PaymentSplit(id: '2', paymentMethodId: '', amount: totalAmount / 2),
        ];
      } else {
        paymentSplits = [
          PaymentSplit(id: '1', paymentMethodId: '', amount: totalAmount),
        ];
      }
    });
    _slideController.forward();
  }

  void _addPaymentSplit() {
    if (paymentSplits.length < 4) {
      setState(() {
        final remainingAmount = totalAmount - paymentSplits.fold(0, (sum, split) => sum + split.amount);
        paymentSplits.add(
          PaymentSplit(
            id: (paymentSplits.length + 1).toString(),
            paymentMethodId: '',
            amount: remainingAmount > 0 ? remainingAmount : 0,
          ),
        );
      });
    }
  }

  void _removePaymentSplit(String id) {
    if (paymentSplits.length > 1) {
      setState(() {
        paymentSplits.removeWhere((split) => split.id == id);
        _redistributeAmounts();
      });
    }
  }

  void _redistributeAmounts() {
    if (paymentSplits.isEmpty) return;

    final amountPerSplit = totalAmount / paymentSplits.length;
    for (var i = 0; i < paymentSplits.length; i++) {
      paymentSplits[i] = PaymentSplit(
        id: paymentSplits[i].id,
        paymentMethodId: paymentSplits[i].paymentMethodId,
        amount: amountPerSplit,
      );
    }
  }

  void _updateSplitPaymentMethod(String splitId, String paymentMethodId) {
    setState(() {
      final index = paymentSplits.indexWhere((split) => split.id == splitId);
      if (index != -1) {
        paymentSplits[index] = PaymentSplit(
          id: paymentSplits[index].id,
          paymentMethodId: paymentMethodId,
          amount: paymentSplits[index].amount,
        );
      }
    });
  }

  void _updateSplitAmount(String splitId, double amount) {
    setState(() {
      final index = paymentSplits.indexWhere((split) => split.id == splitId);
      if (index != -1) {
        paymentSplits[index] = PaymentSplit(
          id: paymentSplits[index].id,
          paymentMethodId: paymentSplits[index].paymentMethodId,
          amount: amount,
        );
      }
    });
  }

  double get totalPaid => paymentSplits.fold(0, (sum, split) => sum + split.amount);
  double get changeAmount => totalPaid - totalAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: FadeTransition(
        opacity: _fadeController,
        child: Row(
          children: [
            // Left Panel - Order Summary
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Icon(Icons.arrow_back, color: Colors.grey[600]),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Payment',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Order #005',
                            style: TextStyle(
                              color: Color(0xFF1976D2),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Order Summary Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.receipt_long,
                                  color: Color(0xFF4CAF50),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Order Summary',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Order Items
                          _buildOrderItem('Beef Crowich', 1, 5.50),
                          _buildOrderItem('Sliced Black Forest', 2, 5),
                          _buildOrderItem('Solo Floss Bread', 1, 4.50),

                          const Divider(height: 32),

                          // Pricing Details
                          _buildPricingRow('Subtotal', 20),
                          _buildPricingRow('Tax (10%)', 2),
                          _buildPricingRow('Discount', -1, isDiscount: true),

                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Amount',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                Text(
                                  '\$${totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF4285F4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Customer Info
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFF4285F4),
                            child: Text(
                              'E',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Eloise's Order",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                'Table 05 • Dine In',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
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

            // Right Panel - Payment Options
            Expanded(
              flex: 3,
              child: ColoredBox(
                color: Colors.white,
                child: Column(
                  children: [
                    // Payment Header
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Payment Methods',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800],
                            ),
                          ),
                          const Spacer(),
                          // Split Bill Toggle
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: _toggleSplitBill,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: !isSplitBillEnabled ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: !isSplitBillEnabled
                                          ? [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Text(
                                      'Single',
                                      style: TextStyle(
                                        color: !isSplitBillEnabled ? Colors.grey[800] : Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _toggleSplitBill,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSplitBillEnabled ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: isSplitBillEnabled
                                          ? [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Text(
                                      'Split Bill',
                                      style: TextStyle(
                                        color: isSplitBillEnabled ? Colors.grey[800] : Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Payment Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            // Payment Splits
                            ...paymentSplits.asMap().entries.map((entry) {
                              final index = entry.key;
                              final split = entry.value;
                              return _buildPaymentSplit(split, index);
                            }),

                            // Add Split Button
                            if (isSplitBillEnabled && paymentSplits.length < 4)
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: InkWell(
                                  onTap: _addPaymentSplit,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFF4285F4), width: 2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add, color: Color(0xFF4285F4)),
                                        SizedBox(width: 8),
                                        Text(
                                          'Add Payment Method',
                                          style: TextStyle(
                                            color: Color(0xFF4285F4),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 32),

                            // Payment Summary
                            _buildPaymentSummary(),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Action
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: Colors.grey[300]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Back to Order',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4285F4),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Process Payment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(String name, int quantity, double price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF4285F4),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ),
          Text(
            '${quantity}x',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '\$${(price * quantity).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingRow(String label, double amount, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}\$${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDiscount ? Colors.red[600] : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSplit(PaymentSplit split, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4285F4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Payment ${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              if (isSplitBillEnabled && paymentSplits.length > 1)
                InkWell(
                  onTap: () => _removePaymentSplit(split.id),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.red[600],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Amount Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Text(
                  'Amount: ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: split.amount.toStringAsFixed(2),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefix: Text(r'$ ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                    onChanged: (value) {
                      final amount = double.tryParse(value) ?? 0;
                      _updateSplitAmount(split.id, amount);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Payment Method Selection
          Text(
            'Select Payment Method',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),

          // Payment Method Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: paymentMethods.length,
            itemBuilder: (context, methodIndex) {
              final method = paymentMethods[methodIndex];
              final isSelected = split.paymentMethodId == method.id;

              return GestureDetector(
                onTap: () => _updateSplitPaymentMethod(split.id, method.id),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? method.color.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? method.color : Colors.grey[200]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        method.icon,
                        size: 28,
                        color: isSelected ? method.color : Colors.grey[600],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        method.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? method.color : Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Cash Recommendations
          if (split.paymentMethodId == 'cash')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Quick Cash Amount',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: cashRecommendations.map((amount) {
                    return InkWell(
                      onTap: () => _updateSplitAmount(split.id, amount),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: split.amount == amount ? const Color(0xFF4CAF50) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: split.amount == amount ? const Color(0xFF4CAF50) : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          '\$${amount.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: split.amount == amount ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4285F4), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4285F4).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.payment, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                'Payment Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Order Items
          _buildOrderItem('Total Amount', 2, 0),
          _buildOrderItem('Tax (10%)', 2, 0),
          _buildOrderItem('Discount', 2, 0),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                ),
                const Text(
                  r'${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4285F4),
                  ),
                ),
              ],
            ),
          ),
        ],
        // const SizedBox(height: 20),
      ),
    );
  }

  // Widget _buildOrderItem(String name, String amount, int quantity) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 12),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 8,
  //           height: 8,
  //           decoration: const BoxDecoration(
  //             color: Color(0xFF4285F4),
  //             shape: BoxShape.circle,
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Text(
  //             name,
  //             style: TextStyle(
  //               fontSize: 16,
  //               color: Colors.grey[800],
  //             ),
  //           ),
  //         ),
  //         Text(
  //           amount,
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.grey[800],
  //           ),
  //         ),
  //         const SizedBox(width: 16),
  //         Text(
  //           '\$${(double.tryParse(amount) ?? 0) * quantity}',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.grey[800],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
