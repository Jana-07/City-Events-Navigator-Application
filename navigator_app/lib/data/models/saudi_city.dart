class SaudiCity {
  final String name;
  final String imageUrl;

  const SaudiCity({
    required this.name,
    required this.imageUrl,
  });

   @override
  String toString() => name;
}

// List of Saudi cities
final List<SaudiCity> saudiCities = [
  SaudiCity(
      name: 'Riyadh',
      imageUrl:
          'https://res.cloudinary.com/dcq4awvap/image/upload/v1745941619/Riyadh_yiwciy.jpg'),
  SaudiCity(
      name: 'Qassim',
      imageUrl:
          'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942323/Qassim_lrxebj.jpg'),
  SaudiCity(
      name: 'Jeddah',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942321/Jeddah_iwm21c.jpg'),
  SaudiCity(
      name: 'Mecca',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942321/Mecca_ddfjcu.jpg'),
  SaudiCity(
      name: 'Medina',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942323/Medina_g2gq4s.jpg'),
  SaudiCity(
      name: 'Dammam',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942322/Dammam_nym0ux.jpg'),
  SaudiCity(
      name: 'Khobar',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942321/Khobar_mf3puz.jpg'),
  SaudiCity(
      name: 'Taif',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942323/Taif_bmf3y4.jpg'),
  SaudiCity(
      name: 'Tabuk',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942320/Tabuk_alejav.jpg'),
  SaudiCity(
      name: 'Abha',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942323/Abha_kgjcgm.jpg'),
  SaudiCity(
      name: 'Yanbu',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942321/Yanbu_zxrkmr.jpg'),
  SaudiCity(
      name: 'Jizan',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942320/Jizan_nkwwte.jpg'),
];
