import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toko_jaket_1123150107/core/constants/app_colors.dart';
import 'package:toko_jaket_1123150107/features/cart/data/models/cart_model.dart';
import 'package:toko_jaket_1123150107/features/cart/presentation/providers/cart_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().fetchCart();
    });
  }

  String _formatPrice(double price) {
    final str = price.toInt().toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp. ${buffer.toString().split('').reversed.join()}';
  }

  Future<void> _confirmClearCart(BuildContext context, CartProvider cartProv) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kosongkan Keranjang'),
        content: const Text(
          'Apakah kamu yakin ingin menghapus semua item dari keranjang?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await cartProv.clearCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProv, _) {
              final hasItems =
                  cartProv.cart != null && cartProv.cart!.items.isNotEmpty;
              if (!hasItems) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Hapus Semua',
                onPressed: () => _confirmClearCart(context, cartProv),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProv, _) {
          if (cartProv.status == CartStatus.loading ||
              cartProv.status == CartStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cartProv.status == CartStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(cartProv.error ?? 'Terjadi kesalahan'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    onPressed: () => cartProv.fetchCart(),
                  ),
                ],
              ),
            );
          }

          final cart = cartProv.cart;
          if (cart == null || cart.items.isEmpty) {
            return _EmptyCartView();
          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => cartProv.fetchCart(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) => _CartItemCard(
                      item: cart.items[i],
                      formatPrice: _formatPrice,
                      onRemove: () => cartProv.removeItem(cart.items[i].id),
                      onDecrease: () {
                        final qty = cart.items[i].quantity - 1;
                        if (qty <= 0) {
                          cartProv.removeItem(cart.items[i].id);
                        } else {
                          cartProv.updateItem(cart.items[i].id, qty);
                        }
                      },
                      onIncrease: () => cartProv.updateItem(
                        cart.items[i].id,
                        cart.items[i].quantity + 1,
                      ),
                    ),
                  ),
                ),
              ),
              _CartBottomBar(
                total: cart.total,
                formatPrice: _formatPrice,
                onCheckout: () {
                  Navigator.pushNamed(context, '/checkout');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Empty Cart View ────────────────────────────────────────
class _EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: AppColors.primary.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Keranjang Kosong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Yuk, cari jaket keren untukmu!',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Mulai Belanja'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

// ── Cart Item Card ─────────────────────────────────────────
class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final String Function(double) formatPrice;
  final VoidCallback onRemove;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _CartItemCard({
    required this.item,
    required this.formatPrice,
    required this.onRemove,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Product Image
              Container(
                width: 100,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: item.product.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          item.product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => _placeholder(),
                        ),
                      )
                    : _placeholder(),
              ),
              // Product Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.product.category.isNotEmpty)
                            Text(
                              item.product.category,
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary.withOpacity(0.7),
                              ),
                            ),
                          const SizedBox(height: 2),
                          Text(
                            item.product.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatPrice(item.product.price),
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primary.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _QtyButton(
                            icon: Icons.remove,
                            onTap: onDecrease,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          _QtyButton(
                            icon: Icons.add,
                            onTap: onIncrease,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Delete & Total
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(Icons.delete_outline, color: Color(0xFFE57373)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Text(
                      formatPrice(item.subtotal),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: AppColors.primary.withOpacity(0.05),
        child: Icon(Icons.image, color: AppColors.primary.withOpacity(0.2)),
      );
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}

// ── Cart Bottom Bar ────────────────────────────────────────
class _CartBottomBar extends StatelessWidget {
  final double total;
  final String Function(double) formatPrice;
  final VoidCallback onCheckout;

  const _CartBottomBar({
    required this.total,
    required this.formatPrice,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                formatPrice(total),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onCheckout,
            child: const Text('Lanjut Checkout'),
          ),
        ],
      ),
    );
  }
}
