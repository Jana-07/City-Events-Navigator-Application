import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navigator_app/data/models/event.dart';


final List<Event> eventsList = [

  // Event(
  //   id: '',
  //   title: 'Buraidah Date Festival',
  //   description: 'Annual celebration showcasing the region\'s finest dates, competitions, exhibitions, and cultural performances.',
  //   startDate: DateTime(2025, 5, 1),
  //   endDate:   DateTime(2025, 5, 10),
  //   location: GeoPoint(26.3609, 43.9750),
  //   address: 'King Khalid Cultural Centre, Buraidah',
  //   creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
  //   city: 'Qassim',
  //   organizerName: 'Qassim Dates Authority',
  //   organizerProfilePictureUrl: '',
  //   category: 'Festival',
  //   price: 0.0,
  //   tags: ['dates','culture','food'],
  //   ticketURL: '',
  //   createdAt: DateTime.now(),
  // ), // 

  // Event(
  //   id: '',
  //   title: 'Qassim Camel Festival',
  //   description: 'Traditional camel races and beauty contests set against the desert backdrop.',
  //   startDate: DateTime(2025, 5, 5),
  //   endDate:   DateTime(2025, 5, 14),
  //   location: GeoPoint(26.2950, 43.7600),
  //   address: 'Al-Sulaimi Camel Track, Buraidah',
  //   city: 'Qassim',
  //   creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
  //   organizerName: 'Camel Racing Federation',
  //   category: 'Sport',
  //   price: 30.0,
  //   tags: ['camel','race','heritage'],
  //   createdAt: DateTime.now(),
  // ), // 

  // Event(
  //   id: '',
  //   title: 'Qassim Heritage Week',
  //   description: 'Live demonstrations of crafts, folk music, and traditional dress exhibitions.',
  //   startDate: DateTime(2025, 4, 28),
  //   endDate:   DateTime(2025, 5, 2),
  //   location: GeoPoint(26.3340, 43.9780),
  //   address: 'Buraidah Old Town',
  //   city: 'Qassim',
  //   creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
  //   organizerName: 'Qassim Cultural Council',
  //   category: 'Cultural',
  //   price: 0.0,
  //   tags: ['heritage','crafts','music'],
  //   ticketURL: '',
  //   createdAt: DateTime.now(),
  // ), // 

  // Event(
  //   id: '',
  //   title: 'Qassim Art & Culture Festival',
  //   description: 'Contemporary art installations, live painting, and sculpture garden tours.',
  //   startDate: DateTime(2025, 5, 12),
  //   endDate:   DateTime(2025, 5, 18),
  //   location: GeoPoint(26.3550, 43.9850),
  //   address: 'Al-Qassim University Grounds, Buraidah',
  //   city: 'Qassim',
  //   creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
  //   organizerName: 'Qassim University Arts Dept.',
  //   category: 'Galllery',
  //   price: 10.0,
  //   tags: ['art','exhibition','culture'],
  //   createdAt: DateTime.now(),
  // ), // 

  // Event(
  //   id: '',
  //   title: 'Qassim Marathon',
  //   description: 'Half and full marathon routes through Buraidah\'s scenic parks.',
  //   startDate: DateTime(2025, 5, 20),
  //   endDate:   DateTime(2025, 5, 20),
  //   location: GeoPoint(26.3609, 43.9750),
  //   address: 'King Khalid Park, Buraidah',
  //   city: 'Qassim',
  //   creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
  //   organizerName: 'Saudi Athletics Federation',
  //   category: 'Sport',
  //   price: 25.0,
  //   tags: ['running','sports','health'],
  //   createdAt: DateTime.now(),
  // ), // 

  // 6. Riyadh
  Event(
    id: '',
    title: 'Riyadh Season, Winter Wonderland',
    description: 'Ice-skating, carnival rides, and nightly fireworks in Boulevard Riyadh City.',
    startDate: DateTime(2025, 4, 15),
    endDate:   DateTime(2025, 5, 15),
    location: GeoPoint(24.7136, 46.6753),
    address: 'Boulevard Riyadh City',
    city: 'Riyadh',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Riyadh Season Authority',
    category: 'Festival',
    price: 50.0,
    tags: ['family','rides','fireworks'],
    createdAt: DateTime.now(),
  ), // 

  // 7. Riyadh
  Event(
    id: '',
    title: 'Diriyah E-Prix',
    description: 'Formula E electric street race around historic Diriyah.',
    startDate: DateTime(2025, 4, 26),
    endDate:   DateTime(2025, 4, 27),
    location: GeoPoint(24.6880, 46.5700),
    address: 'Diriyah Circuit, Diriyah',
    city: 'Riyadh',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Formula E Holdings',
    category: 'Sport',
    price: 120.0,
    tags: ['racing','electric','sport'],
    createdAt: DateTime.now(),
  ), // 

  // 8. Jeddah
  Event(
    id: '',
    title: 'Jeddah Art Promenade',
    description: 'Open-air sculpture and street-art showcase along the Corniche.',
    startDate: DateTime(2025, 4, 20),
    endDate:   DateTime(2025, 6, 30),
    location: GeoPoint(21.5433, 39.1728),
    address: 'Jeddah Corniche',
    city: 'Jeddah',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Jeddah Downtown Co.',
    category: 'Exhibition',
    price: 0.0,
    tags: ['art','sculpture','free'],
    ticketURL: '',
    createdAt: DateTime.now(),
  ), // 

  // 9. Jeddah
  Event(
    id: '',
    title: 'Jeddah Yacht Show',
    description: 'Luxury yacht display and marine lifestyle expo.',
    startDate: DateTime(2025, 5, 5),
    endDate:   DateTime(2025, 5, 8),
    location: GeoPoint(21.5126, 39.1647),
    address: 'Jeddah Islamic Port',
    city: 'Jeddah',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Arab Marine Union',
    category: 'Exhibition',
    price: 15.0,
    tags: ['boats','marine','expo'],
    createdAt: DateTime.now(),
  ), // 

  // 10. AlUla
  Event(
    id: '',
    title: 'AlUla Hot Air Balloons Glow Show',
    description: 'Nightly illumination of colored balloons against the desert canyon.',
    startDate: DateTime(2025, 4, 24),
    endDate:   DateTime(2025, 4, 25),
    location: GeoPoint(26.7250, 37.9120),
    address: 'AlUla Desert Plateau',
    city: 'AlUla',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Royal Commission for AlUla',
    category: 'Galllery',
    price: 40.0,
    tags: ['balloons','night','spectacle'],
    createdAt: DateTime.now(),
  ), // 

  // 11. Taif
  Event(
    id: '',
    title: 'Taif Rose Festival',
    description: 'Celebration of Taif\'s famed Damask roses with workshops and perfume markets.',
    startDate: DateTime(2025, 5, 1),
    endDate:   DateTime(2025, 5, 7),
    location: GeoPoint(21.2854, 40.4168),
    address: 'Taif Rose Gardens',
    city: 'Taif',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Taif Agricultural Commission',
    category: 'Festival',
    price: 10.0,
    tags: ['roses','flowers','workshops'],
    createdAt: DateTime.now(),
  ), // 

  // 12. Abha
  Event(
    id: '',
    title: 'Abha Flower Festival',
    description: 'Vibrant floral displays on the mountain terraces, live folk music.',
    startDate: DateTime(2025, 5, 10),
    endDate:   DateTime(2025, 5, 20),
    location: GeoPoint(18.2160, 42.5053),
    address: 'Abha Asir Park',
    city: 'Abha',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Asir Regional Gov.',
    category: 'Festival',
    price: 0.0,
    tags: ['flowers','music','culture'],
    ticketURL: '',
    createdAt: DateTime.now(),
  ), // 

  // 13. Dammam
  Event(
    id: '',
    title: 'Dammam Corniche Festival',
    description: 'Food trucks, craft bazaars, and waterfront concerts.',
    startDate: DateTime(2025, 4, 30),
    endDate:   DateTime(2025, 5, 5),
    location: GeoPoint(26.4207, 50.0888),
    address: 'Prince Mohammed Bin Fahd Corniche',
    city: 'Dammam',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Eastern Province Authority',
    category: 'Festival',
    price: 0.0,
    tags: ['food','music','bazaar'],
    ticketURL: '',
    createdAt: DateTime.now(),
  ), // 

  // 14. Medina
  Event(
    id: '',
    title: 'Medina Date Market Expo',
    description: 'Trade fair featuring premium dates, packaging innovations, and tastings.',
    startDate: DateTime(2025, 5, 3),
    endDate:   DateTime(2025, 5, 7),
    location: GeoPoint(24.5247, 39.5692),
    address: 'Madina Exhibition Center',
    city: 'Medina',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Madina Dates Board',
    category: 'Exhibition',
    price: 5.0,
    tags: ['dates','expo','trade'],
    createdAt: DateTime.now(),
  ), // 

  // 15. Mecca
  Event(
    id: '',
    title: 'Mecca Hajj Preparation Expo',
    description: 'Seminars, equipment displays, and health awareness for pilgrims.',
    startDate: DateTime(2025, 4, 28),
    endDate:   DateTime(2025, 5, 2),
    location: GeoPoint(21.3891, 39.8579),
    address: 'Mecca Conference Center',
    city: 'Mecca',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Hajj Ministry',
    category: 'Conference',
    price: 0.0,
    tags: ['hajj','expo','seminar'],
    ticketURL: '',
    createdAt: DateTime.now(),
  ), // 

  // 16. Hail
  Event(
    id: '',
    title: 'Hail International Rally',
    description: 'Cross-country rally through the desert landscapes of Hail Province.',
    startDate: DateTime(2025, 5, 15),
    endDate:   DateTime(2025, 5, 18),
    location: GeoPoint(27.5218, 41.6900),
    address: 'Various stages across Hail',
    city: 'Hail',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Saudi Motorsport Org.',
    category: 'Sport',
    price: 100.0,
    tags: ['rally','motorsport','desert'],
    createdAt: DateTime.now(),
  ), // 

  // 17. Tabuk
  Event(
    id: '',
    title: 'Tabuk Wine & Olive Expo',
    description: 'Showcasing Tabuk\'s burgeoning wine and olive oil producers.',
    startDate: DateTime(2025, 5, 8),
    endDate:   DateTime(2025, 5, 12),
    location: GeoPoint(28.3838, 36.5555),
    address: 'Tabuk Expo Grounds',
    city: 'Tabuk',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Tabuk Agri Board',
    category: 'Exhibition',
    price: 20.0,
    tags: ['wine','olive','food'],
    createdAt: DateTime.now(),
  ), // 

  // 18. AlKhobar
  Event(
    id: '',
    title: 'AlKhobar Food Carnival',
    description: 'International cuisines, live cooking demos, and kids\' play zone.',
    startDate: DateTime(2025, 1, 29),
    endDate:   DateTime(2025, 2, 2),
    location: GeoPoint(26.2172, 50.1971),
    address: 'Khobar Corniche Park',
    city: 'AlKhobar',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Eastern Province Tours',
    category: 'Festival',
    price: 10.0,
    tags: ['food','family','live'],
    createdAt: DateTime.now(),
  ), // 

  // 20. AlQatif
  Event(
    id: '',
    title: 'AlQatif Heritage Village Fair',
    description: 'Traditional games, folk dance, and regional crafts bazaar.',
    startDate: DateTime(2025, 5, 2),
    endDate:   DateTime(2025, 5, 6),
    location: GeoPoint(26.5667, 50.0167),
    address: 'AlQatif Old Town',
    city: 'AlQatif',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Qatif Heritage Society',
    category: 'Cultural',
    price: 0.0,
    tags: ['heritage','dance','crafts'],
    ticketURL: '',
    createdAt: DateTime.now(),
  ), // 

  // 21. Yanbu
  Event(
    id: '',
    title: 'Yanbu Diving Challenge',
    description: 'Open-water scuba diving competition and marine conservation workshops.',
    startDate: DateTime(2025, 4, 27),
    endDate:   DateTime(2025, 4, 29),
    location: GeoPoint(24.0889, 38.0634),
    address: 'Yanbu Coral Reefs',
    city: 'Yanbu',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Red Sea Conservancy',
    category: 'Sport',
    price: 80.0,
    tags: ['diving','marine','conservation'],
    createdAt: DateTime.now(),
  ), // 

  // 22. NEOM
  Event(
    id: '',
    title: 'NEOM Tech Forum',
    description: 'Cutting-edge talks on AI, robotics, and sustainable infrastructure.',
    startDate: DateTime(2025, 5, 14),
    endDate:   DateTime(2025, 5, 16),
    location: GeoPoint(27.0000, 36.0000),
    address: 'NEOM Bay Conference Center',
    city: 'NEOM',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'NEOM Authority',
    category: 'Tech',
    price: 150.0,
    tags: ['tech','ai','sustainability'],
    createdAt: DateTime.now(),
  ), // 

  // 23. Jizan
  Event(
    id: '',
    title: 'Jizan Mango Festival',
    description: 'Celebrating the harvest with tastings, cook-offs, and farmer\'s markets.',
    startDate: DateTime(2025, 5, 18),
    endDate:   DateTime(2025, 5, 23),
    location: GeoPoint(16.8892, 42.5510),
    address: 'Jizan Agricultural Park',
    city: 'Jizan',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Jizan Agri Board',
    category: 'Festival',
    price: 5.0,
    tags: ['mango','food','culture'],
    createdAt: DateTime.now(),
  ), //  


  // 27. AlKharj
  Event(
    id: '',
    title: 'AlKharj Date & Camel Market',
    description: 'Traditional weekly market trading dates and camel livestock.',
    startDate: DateTime(2025, 4, 26),
    endDate:   DateTime(2025, 4, 26),
    location: GeoPoint(24.1549, 47.3124),
    address: 'AlKharj Old Market',
    city: 'AlKharj',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'AlKharj Municipality',
    category: 'Food',
    price: 0.0,
    tags: ['market','dates','camel'],
    ticketURL: '',
    createdAt: DateTime.now(),
  ), // 

  // 28. Hafr Al-Batin
  Event(
    id: '',
    title: 'Hafr Al-Batin Folk Dance Gala',
    description: 'Showcasing dances from across the Kingdom, with audience workshops.',
    startDate: DateTime(2025, 5, 6),
    endDate:   DateTime(2025, 5, 6),
    location: GeoPoint(28.4328, 45.9601),
    address: 'Hafr Cultural Hall',
    city: 'Hafr Al-Batin',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Northern Arts Council',
    category: 'Cultural',
    price: 15.0,
    tags: ['dance','cultural','workshop'],
    createdAt: DateTime.now(),
  ), // 

  // 30. Riyadh
  Event(
    id: '',
    title: 'Riyadh International Book Fair',
    description: 'Publishers, authors, and literary workshops at Riyadh Front.',
    startDate: DateTime(2025, 5, 10),
    endDate:   DateTime(2025, 5, 18),
    location: GeoPoint(24.7741, 46.7386),
    address: 'Riyadh Front Exhibition Center',
    city: 'Riyadh',
    creatorID: '7stAvIBK3aRYkh0TOD2YtC1qWjJ2',
    organizerName: 'Saudi Publishers Assoc.',
    category: 'Exhibition',
    price: 0.0,
    tags: ['books','culture','workshops'],
    createdAt: DateTime.now(),
  ), // 

];
