import 'package:flutter/material.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/universal/layout/header_banner.dart';
import 'package:lentera_karir/widgets/universal/inputs/search_bar.dart';

/// Halaman Help Center
/// Menampilkan FAQ untuk membantu user
class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  int? expandedIndex;

  final List<Map<String, String>> faqs = [
    {
      'question': 'Saya lupa kata sandi akun saya, apa yang harus dilakukan?',
      'answer':
          'Klik "Lupa Kata Sandi" pada halaman Login. Masukkan email yang terdaftar, dan kami akan mengirimkan instruksi untuk mengatur ulang kata sandi Anda.',
    },
    {
      'question': 'Metode pembayaran apa saja yang tersedia?',
      'answer':
          'Kami menerima berbagai metode pembayaran termasuk transfer bank, e-wallet (GoPay, OVO, Dana), dan kartu kredit/debit. Semua transaksi dijamin aman.',
    },
    {
      'question': 'Di mana saya bisa melihat sertifikat yang sudah saya dapatkan?',
      'answer':
          'Sertifikat Anda dapat dilihat di menu Profile > Sertifikat Saya. Anda juga bisa mengunduh dan membagikannya langsung dari halaman tersebut.',
    },
    {
      'question': 'Video pembelajaran tidak bisa diputar, bagaimana solusinya?',
      'answer':
          'Pastikan koneksi internet Anda stabil. Coba tutup dan buka kembali aplikasi. Jika masih bermasalah, hapus cache aplikasi atau hubungi tim support kami.',
    },
    {
      'question': 'Apakah kelas di Lentera Karir bisa diakses selamanya?',
      'answer':
          'Ya, setelah Anda membeli kelas, Anda dapat mengaksesnya kapan saja tanpa batas waktu. Materi pembelajaran akan selalu tersedia di akun Anda.',
    },
    {
      'question': 'Apakah saya bisa mendapatkan pengembalian dana (refund)?',
      'answer':
          'Pengembalian dana dapat dilakukan dalam 7 hari pertama setelah pembelian jika Anda belum menyelesaikan lebih dari 20% materi kelas. Hubungi tim support untuk proses refund.',
    },
    {
      'question': 'Apakah saya bisa mengubah alamat email yang terdaftar?',
      'answer':
          'Ya, Anda bisa mengubah email di menu Profile > Settings > Ubah Email. Kami akan mengirimkan kode verifikasi ke email baru Anda untuk konfirmasi.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Header Banner dengan gradient
          HeaderBanner(
            height: 170,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Back button
                    CustomBackButton(
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      'Help Center untuk membantu\napapun tentang Lentera Karir',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textOnDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        height: 1.3,
                      )
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(31, 24, 31, 24),
                    child: CustomSearchBar(
                      hintText: 'Cari jenis masalahmu',
                    ),
                  ),

                  // FAQ Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 31),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FAQ',
                          style: AppTextStyles.heading4.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // FAQ Items
                        ...List.generate(faqs.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildFAQItem(
                              question: faqs[index]['question']!,
                              answer: faqs[index]['answer']!,
                              isExpanded: expandedIndex == index,
                              onTap: () {
                                setState(() {
                                  expandedIndex =
                                      expandedIndex == index ? null : index;
                                });
                              },
                            ),
                          );
                        }),
                        const SizedBox(height: 40),
                      ],
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

  Widget _buildFAQItem({
    required String question,
    required String answer,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: AppTextStyles.body2.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 12),
                Text(
                  answer,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
