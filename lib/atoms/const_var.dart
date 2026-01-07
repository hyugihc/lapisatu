import 'package:lapis_satu/atoms/enum_var.dart';

class AppVar {
  static const Map<Category, List<String>> subCategory = {
    Category.penduduk: [
      'Kependudukan dan Migrasi',
      'Tenaga Kerja',
      'Pendidikan',
      'Kesehatan',
      'Konsumsi dan Pendapatan',
      'Perlindungan Sosial',
      'Pemukiman dan Perumahan',
      'Hukum dan Kriminal',
      'Budaya',
      'Aktivitas Politik dan Komunitas Lainnya',
      'Penggunaan Waktu',
    ],
    Category.ekonomi: [
      'Statistik Makroekonomi',
      'Neraca Ekonomi',
      'Statistik Bisnis',
      'Statistik Sektoral',
      'Keuangan Pemerintah, Fiskal dan Statistik Sektor Publik',
      'Perdagangan Internasional dan Neraca Pembayaran',
      'Harga-Harga',
      'Biaya Tenaga Kerja',
      'Ilmu Pengetahuan, Teknologi, dan Inovasi',
      'Pertanian, Kehutanan, Perikanan',
      'Energi',
      'Pertambangan, Manufaktur, Konstruksi',
      'Transportasi',
      'Pariwisata',
      'Perbankan, Asuransi dan Finansial',
    ],
    Category.multidomain: [
      'Lingkungan',
      'Statistik Regional dan Statistik Area Kecil',
      'Statistik dan Indikator Multi-Domain',
      'Buku Tahunan dan Ringkasan Sejenis',
      'Kondisi Tempat Tinggal, Kemiskinan, dan Permasalahan Sosial Lintas Sektor',
      'Gender dan Kelompok Populasi Khusus',
      'Masyarakat Informasi',
      'Globalisasi',
      'Indikator Millenium Development Goals (MDGs)',
      'Perkembangan Berkelanjutan',
      'Kewiraswastaan',
    ],
  };
}
