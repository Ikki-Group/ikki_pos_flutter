import 'package:flutter/material.dart';
import 'package:ikki_pos_flutter/features/home/manager/home_tab_item.dart';
import 'package:ikki_pos_flutter/features/home/widgets/home_topbar.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: HomeTabItem.values.length,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8,
          children: [
            HomeTopBar(),
            Flexible(
              child: Row(
                spacing: 8,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 1. Data Models ---

// Enum for Order Status
enum OrderStatus {
  notPaid, // Belum Dibayar
  readyToProcess, // Siap Diproses
  shipped, // Sudah Dikirim
  completed, // Selesai
  failed, // Gagal
}

// Enum for Payment Status
enum PaymentStatus {
  paid, // Sudah Dibayar
  notPaid, // Belum Dibayar
}

// Represents a single item within an order
class OrderItem {
  final String productName;
  final String? description; // e.g., "Ice/Hot: Hot"
  final double price;
  final String? notes; // e.g., "Done by Ikki Coff @ 03:45"

  OrderItem({
    required this.productName,
    this.description,
    required this.price,
    this.notes,
  });
}

// Represents an entire order
class Order {
  final String id;
  final DateTime orderDate;
  final String orderNumber;
  final double totalAmount;
  final OrderStatus orderStatus;
  final PaymentStatus paymentStatus;
  final String cashierName;
  final String tableInfo; // e.g., "Meja" or "Open Bill"
  final List<OrderItem> items;
  final String? timeAgo; // e.g., "+30mins", "-15mins"

  Order({
    required this.id,
    required this.orderDate,
    required this.orderNumber,
    required this.totalAmount,
    required this.orderStatus,
    required this.paymentStatus,
    required this.cashierName,
    required this.tableInfo,
    required this.items,
    this.timeAgo,
  });
}

// --- 2. State Management (Provider) ---

// Manages the currently selected order
class OrderProvider extends ChangeNotifier {
  Order? _selectedOrder;

  Order? get selectedOrder => _selectedOrder;

  void setSelectedOrder(Order order) {
    _selectedOrder = order;
    notifyListeners();
  }
}

// --- 4. Main Screen Widget ---

class PosDashboardScreen extends StatefulWidget {
  const PosDashboardScreen({super.key});

  @override
  State<PosDashboardScreen> createState() => _PosDashboardScreenState();
}

class _PosDashboardScreenState extends State<PosDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dummy Data for demonstration
  final List<Order> _allOrders = [
    Order(
      id: '1',
      orderDate: DateTime(2025, 3, 18, 6, 5),
      orderNumber: '06',
      totalAmount: 360000,
      orderStatus: OrderStatus.notPaid,
      paymentStatus: PaymentStatus.notPaid,
      cashierName: 'KASIR ****8144',
      tableInfo: 'Meja',
      timeAgo: '+30mins',
      items: [
        OrderItem(productName: 'produk 1', price: 120000),
        OrderItem(
          productName: 'Americano',
          description: 'Ice/hot: hot',
          price: 100000,
        ),
        OrderItem(productName: 'Roti', price: 140000),
      ],
    ),
    Order(
      id: '2',
      orderDate: DateTime(2025, 3, 18, 23, 7),
      orderNumber: '01',
      totalAmount: 120000,
      orderStatus: OrderStatus.notPaid,
      paymentStatus: PaymentStatus.paid,
      cashierName: 'KASIR ****8144',
      tableInfo: 'Open Bill',
      timeAgo: '-30mins',
      items: [OrderItem(productName: 'produk 2', price: 120000)],
    ),
    Order(
      id: '3',
      orderDate: DateTime(2025, 3, 19, 3, 43),
      orderNumber: '02',
      totalAmount: 120000,
      orderStatus: OrderStatus.notPaid,
      paymentStatus: PaymentStatus.notPaid,
      cashierName: 'KASIR ****8144',
      tableInfo: 'Meja',
      timeAgo: '-15mins',
      items: [OrderItem(productName: 'produk 3', price: 120000)],
    ),
    Order(
      id: '4',
      orderDate: DateTime(2025, 3, 19, 3, 51),
      orderNumber: '02',
      totalAmount: 341000,
      orderStatus: OrderStatus.notPaid,
      paymentStatus: PaymentStatus.notPaid,
      cashierName: 'KASIR ****8144',
      tableInfo: 'Open Bill',
      items: [
        OrderItem(
          productName: 'produk 1',
          price: 120000,
          notes: 'Done by Ikki Coff @ 03:45',
        ),
        OrderItem(
          productName: 'Americano',
          description: 'Ice/hot: hot',
          price: 100000,
        ),
        OrderItem(productName: 'Roti', price: 121000),
      ],
    ),
    Order(
      id: '5',
      orderDate: DateTime(2025, 3, 19, 3, 43),
      orderNumber: '8144',
      totalAmount: 200000,
      orderStatus: OrderStatus.notPaid,
      paymentStatus: PaymentStatus.notPaid,
      cashierName: 'KASIR ****8144',
      tableInfo: 'Meja -',
      items: [
        OrderItem(productName: 'Produk A', price: 50000),
        OrderItem(productName: 'Produk B', price: 150000),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: OrderStatus.values.length,
      vsync: this,
    );

    // // Initialize selected order with the first one, if available
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_allOrders.isNotEmpty) {
    //     Provider.of<OrderProvider>(context, listen: false).setSelectedOrder(_allOrders.first);
    //   }
    // });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper to filter orders by status
  List<Order> _getOrdersByStatus(OrderStatus status) {
    return _allOrders.where((order) => order.orderStatus == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Panel: Order List
        Flexible(
          flex: 2, // Adjust flex as needed for screen size
          child: TabBarView(
            controller: _tabController,
            children: OrderStatus.values.map((status) {
              return _OrderListPanel(orders: _getOrdersByStatus(status));
            }).toList(),
          ),
        ),
        // Right Panel: Order Details (only visible if an order is selected)
        Flexible(
          flex: 3, // Adjust flex as needed for screen size
          child: _OrderDetailsPanel(
            order: _getOrdersByStatus(OrderStatus.notPaid)[0],
          ),
        ),
      ],
    );
  }
}

// --- 5. Custom App Bar Widget ---

class _CustomAppBar extends StatelessWidget {
  final TabController tabController;

  const _CustomAppBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari Nama, No. Meja, No. Telo...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.filter_list, color: Colors.grey[600]),
                      const SizedBox(width: 4.0),
                      Text('Filter', style: TextStyle(color: Colors.grey[800])),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Pesanan'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 10.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Order Status Tabs
          _OrderStatusTabs(tabController: tabController),
        ],
      ),
    );
  }
}

// --- 6. Order Status Tabs Widget ---

class _OrderStatusTabs extends StatelessWidget {
  final TabController tabController;

  const _OrderStatusTabs({required this.tabController});

  String _getTabLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.notPaid:
        return 'Belum Dibayar';
      case OrderStatus.readyToProcess:
        return 'Siap Diproses';
      case OrderStatus.shipped:
        return 'Sudah Dikirim';
      case OrderStatus.completed:
        return 'Selesai';
      case OrderStatus.failed:
        return 'Gagal';
    }
  }

  Widget _buildTab(OrderStatus status, int count) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_getTabLabel(status)),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: const TextStyle(fontSize: 10, color: Colors.black),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dummy counts for tabs, you'd fetch these from actual data
    final Map<OrderStatus, int> orderCounts = {
      OrderStatus.notPaid: 5, // Example count
      OrderStatus.readyToProcess: 0,
      OrderStatus.shipped: 0,
      OrderStatus.completed: 0,
      OrderStatus.failed: 0,
    };

    return TabBar(
      controller: tabController,
      isScrollable: true,
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey[600],
      indicatorColor: Colors.blue,
      indicatorWeight: 3.0,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      tabs: OrderStatus.values.map((status) {
        return _buildTab(status, orderCounts[status] ?? 0);
      }).toList(),
    );
  }
}

// --- 7. Order List Panel Widget ---

class _OrderListPanel extends StatelessWidget {
  final List<Order> orders;

  const _OrderListPanel({required this.orders});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey[300]!, width: 1.0)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(order: order);
        },
      ),
    );
  }
}

// --- 8. Order Card Widget ---

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  Color _getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return Colors.green;
      case PaymentStatus.notPaid:
        return Colors.red;
    }
  }

  String _getPaymentStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return 'Sudah Dibayar';
      case PaymentStatus.notPaid:
        return 'Belum Dibayar';
    }
  }

  @override
  Widget build(BuildContext context) {
    // final orderProvider = Provider.of<OrderProvider>(context);
    final isSelected = true;

    return GestureDetector(
      onTap: () {
        // orderProvider.setSelectedOrder(order);
      },
      child: Card(
        // color: isSelected ? Colors.blue : Colors.white,
        color: Colors.blue,
        elevation: 0, // No shadow for individual cards as per UI
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: isSelected ? const BorderSide(color: Colors.blue, width: 1.5) : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(order.totalAmount)} ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '(${order.items.length}/${order.items.length} selesai)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getPaymentStatusColor(
                        order.paymentStatus,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      _getPaymentStatusText(order.paymentStatus),
                      style: TextStyle(
                        color: _getPaymentStatusColor(order.paymentStatus),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        DateFormat('dd MMM yyyy HH:mm').format(order.orderDate),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '#${order.orderNumber}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (order.timeAgo != null) ...[
                        const SizedBox(width: 8.0),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            order.timeAgo!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(
                        0.1,
                      ), // Example color for table/bill
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      order.tableInfo,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.cashierName,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  Icon(
                    order.paymentStatus == PaymentStatus.paid ? Icons.check_circle : Icons.credit_card,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 9. Order Details Panel Widget ---

class _OrderDetailsPanel extends StatelessWidget {
  final Order order;

  const _OrderDetailsPanel({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section of order details
          Card(
            elevation: 0,
            color: Colors.red.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _getPaymentStatusText(order.paymentStatus),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      order.timeAgo ?? '00:00:00', // Use a default if timeAgo is null
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          // Cashier and Order Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.person, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.cashierName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('dd MMM yyyy HH:mm').format(order.orderDate),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      order.tableInfo,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8.0),
                    TextButton(
                      onPressed: () {
                        // Handle "Lihat Detail"
                      },
                      child: const Text(
                        'Lihat Detail',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Order Items Section
          Text(
            'Rincian Pesanan',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Order #${order.orderNumber} (${DateFormat('dd MMM yyyy, HH:mm').format(order.orderDate)} WIB)',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                final item = order.items[index];
                return _OrderDetailItem(item: item, itemNumber: index + 1);
              },
            ),
          ),
          // Actions for order details (e.g., Pay, Print) - not fully implemented in UI but common
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle print bill
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Cetak Bill'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle payment
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Bayar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return 'Sudah Dibayar';
      case PaymentStatus.notPaid:
        return 'Belum Dibayar';
    }
  }
}

// --- 10. Order Detail Item Widget ---

class _OrderDetailItem extends StatelessWidget {
  final OrderItem item;
  final int itemNumber;

  const _OrderDetailItem({required this.item, required this.itemNumber});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (item.description != null)
                  Text(
                    item.description!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                if (item.notes != null)
                  Text(
                    item.notes!,
                    style: const TextStyle(fontSize: 10, color: Colors.green),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NumberFormat.currency(
                  locale: 'id',
                  symbol: 'Rp',
                  decimalDigits: 0,
                ).format(item.price),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Handle remove item
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.red,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle change item
                    },
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: Colors.blue,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
