// ignore_for_file: inference_failure_on_function_invocation, cascade_invocations, inference_failure_on_function_return_type, deprecated_member_use, prefer_null_aware_method_calls

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../router/ikki_router.dart';

class CartPaymentRndTwo extends StatefulWidget {
  const CartPaymentRndTwo({
    required this.orderItems,
    required this.subtotal,
    super.key,
  });

  final List<OrderItem> orderItems;
  final double subtotal;

  @override
  State<CartPaymentRndTwo> createState() => _CartPaymentRndTwoState();
}

class _CartPaymentRndTwoState extends State<CartPaymentRndTwo> {
  String selectedPaymentMethod = 'cash';
  List<PaymentSplit> paymentSplits = [];
  double totalPaid = 0;
  bool isSplitBill = false;

  @override
  void initState() {
    super.initState();
    // Initialize with one payment split
    paymentSplits.add(
      PaymentSplit(
        method: 'cash',
        amount: widget.subtotal,
      ),
    );
  }

  double get remainingAmount => widget.subtotal - totalPaid;

  void _updateTotalPaid() {
    totalPaid = paymentSplits.fold(0, (sum, split) => sum + split.amount);
    setState(() {});
  }

  void _showCashAmountDialog() {
    showDialog(
      context: context,
      builder: (context) => CashAmountDialog(
        totalAmount: widget.subtotal,
        onAmountSelected: (amount) {
          setState(() {
            if (isSplitBill) {
              // Update the cash split
              final cashSplitIndex = paymentSplits.indexWhere((s) => s.method == 'cash');
              if (cashSplitIndex != -1) {
                paymentSplits[cashSplitIndex].amount = amount;
              }
            } else {
              paymentSplits.clear();
              paymentSplits.add(PaymentSplit(method: 'cash', amount: amount));
            }
            _updateTotalPaid();
          });
        },
      ),
    );
  }

  void _addPaymentSplit() {
    if (remainingAmount > 0) {
      setState(() {
        paymentSplits.add(
          PaymentSplit(
            method: 'cash',
            amount: remainingAmount,
          ),
        );
        _updateTotalPaid();
      });
    }
  }

  void _removePaymentSplit(int index) {
    if (paymentSplits.length > 1) {
      setState(() {
        paymentSplits.removeAt(index);
        _updateTotalPaid();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.goNamed(IkkiRouter.cart.name),
        ),
      ),
      body: Row(
        children: [
          // Left side - Payment Methods and Options
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Split Bill Toggle
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Switch(
                          value: isSplitBill,
                          onChanged: (value) {
                            setState(() {
                              isSplitBill = value;
                              if (!value) {
                                // Reset to single payment
                                paymentSplits.clear();
                                paymentSplits.add(
                                  PaymentSplit(
                                    method: 'cash',
                                    amount: widget.subtotal,
                                  ),
                                );
                                _updateTotalPaid();
                              }
                            });
                          },
                          activeColor: const Color(0xFF4F46E5),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Split Bill',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Payment Splits
                  const Text(
                    'Payment Methods',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.builder(
                      itemCount: paymentSplits.length,
                      itemBuilder: (context, index) {
                        return PaymentSplitCard(
                          split: paymentSplits[index],
                          index: index,
                          canRemove: paymentSplits.length > 1,
                          onMethodChanged: (method) {
                            setState(() {
                              paymentSplits[index].method = method;
                            });
                          },
                          onAmountChanged: (amount) {
                            setState(() {
                              paymentSplits[index].amount = amount;
                              _updateTotalPaid();
                            });
                          },
                          onRemove: () => _removePaymentSplit(index),
                          onCashTap: paymentSplits[index].method == 'cash' ? _showCashAmountDialog : null,
                        );
                      },
                    ),
                  ),

                  // Add Payment Button
                  if (isSplitBill && remainingAmount > 0)
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _addPaymentSplit,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Payment Method'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Right side - Order Summary
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Order Items
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.orderItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.orderItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4F46E5).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF4F46E5),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Rp ${item.price.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Rp ${(item.price * item.quantity).toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Summary
                  const Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Rp ${widget.subtotal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  if (isSplitBill) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Paid',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Rp ${totalPaid.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: totalPaid >= widget.subtotal ? Colors.green[600] : Colors.orange[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Remaining',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Rp ${remainingAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: remainingAmount <= 0 ? Colors.green[600] : Colors.red[600],
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: totalPaid >= widget.subtotal ? _processBill : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        totalPaid >= widget.subtotal ? 'Process Payment' : 'Complete Payment',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Save Bill Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _saveBill,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Bill',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _processBill() {
    // Process the payment
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Payment Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green[600],
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Payment of Rp ${totalPaid.toStringAsFixed(0)} processed successfully',
              textAlign: TextAlign.center,
            ),
            if (totalPaid > widget.subtotal) ...[
              const SizedBox(height: 8),
              Text(
                'Change: Rp ${(totalPaid - widget.subtotal).toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _saveBill() {
    // Save bill logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Bill saved successfully'),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class PaymentSplitCard extends StatelessWidget {
  const PaymentSplitCard({
    required this.split,
    required this.index,
    required this.canRemove,
    required this.onMethodChanged,
    required this.onAmountChanged,
    required this.onRemove,
    super.key,
    this.onCashTap,
  });
  final PaymentSplit split;
  final int index;
  final bool canRemove;
  final Function(String) onMethodChanged;
  final Function(double) onAmountChanged;
  final VoidCallback onRemove;
  final VoidCallback? onCashTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Payment ${index + 1}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (canRemove)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Payment Method Selection
          Row(
            children: [
              Expanded(
                child: PaymentMethodButton(
                  icon: Icons.payments,
                  label: 'Cash',
                  isSelected: split.method == 'cash',
                  onTap: () {
                    onMethodChanged('cash');
                    if (onCashTap != null) onCashTap!();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PaymentMethodButton(
                  icon: Icons.account_balance,
                  label: 'Bank Transfer',
                  isSelected: split.method == 'bank_transfer',
                  onTap: () => onMethodChanged('bank_transfer'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PaymentMethodButton(
                  icon: Icons.qr_code,
                  label: 'QRIS',
                  isSelected: split.method == 'qris',
                  onTap: () => onMethodChanged('qris'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Amount Input
          TextFormField(
            initialValue: split.amount.toStringAsFixed(0),
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixText: 'Rp ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              final amount = double.tryParse(value) ?? 0.0;
              onAmountChanged(amount);
            },
          ),
        ],
      ),
    );
  }
}

class PaymentMethodButton extends StatelessWidget {
  const PaymentMethodButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4F46E5) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF4F46E5) : Colors.grey[300]!,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CashAmountDialog extends StatefulWidget {
  const CashAmountDialog({
    required this.totalAmount,
    required this.onAmountSelected,
    super.key,
  });
  final double totalAmount;
  final Function(double) onAmountSelected;

  @override
  State<CashAmountDialog> createState() => _CashAmountDialogState();
}

class _CashAmountDialogState extends State<CashAmountDialog> {
  String customAmount = '';

  List<double> get recommendedAmounts {
    final base = widget.totalAmount;
    final roundedUp = ((base / 5000).ceil() * 5000).toDouble();
    return [
      roundedUp,
      roundedUp + 5000,
      roundedUp + 10000,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cash Payment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Total: Rp ${widget.totalAmount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 24),

            // Recommended Amounts
            Row(
              children: [
                Expanded(
                  child: _buildAmountButton(
                    'Rp ${recommendedAmounts[0].toStringAsFixed(0)}',
                    recommendedAmounts[0],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildAmountButton(
                    'Rp ${recommendedAmounts[1].toStringAsFixed(0)}',
                    recommendedAmounts[1],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildAmountButton(
                    'Rp ${recommendedAmounts[2].toStringAsFixed(0)}',
                    recommendedAmounts[2],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildAmountButton(
                    'Bayar Pas',
                    widget.totalAmount,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Custom Amount Input
            TextField(
              decoration: InputDecoration(
                labelText: 'Custom Amount',
                prefixText: 'Rp ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                setState(() {
                  customAmount = value;
                });
              },
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: customAmount.isNotEmpty
                      ? () {
                          final amount = double.tryParse(customAmount) ?? 0.0;
                          if (amount >= widget.totalAmount) {
                            widget.onAmountSelected(amount);
                            Navigator.pop(context);
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountButton(String label, double amount) {
    return GestureDetector(
      onTap: () {
        widget.onAmountSelected(amount);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF4F46E5).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF4F46E5).withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF4F46E5),
          ),
        ),
      ),
    );
  }
}

// Data Models
class OrderItem {
  OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
  });
  final String name;
  final double price;
  final int quantity;
}

class PaymentSplit {
  PaymentSplit({
    required this.method,
    required this.amount,
  });
  String method;
  double amount;
}
