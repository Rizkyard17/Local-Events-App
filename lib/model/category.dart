import 'package:flutter/material.dart';  // Hapus cupertino.dart karena tidak digunakan

class Category {
  final int categoryId;     // Gunakan int untuk categoryId
  final String name;        // String untuk name
  final IconData icon;      // IconData untuk icon (bukan String)

  Category({
    required this.categoryId,  // Gunakan required karena semua field wajib diisi
    required this.name,
    required this.icon,
  });
}

// Definisi kategori-kategori
final allCategory = Category(
  categoryId: 0,
  name: "All",
  icon: Icons.search,
);

final musicCategory = Category(
  categoryId: 1,
  name: "Music",
  icon: Icons.music_note,
);

final meetUpCategory = Category(
  categoryId: 2,
  name: "Meetup",
  icon: Icons.location_on,
);

final golfCategory = Category(
  categoryId: 3,
  name: "Golf",
  icon: Icons.golf_course,
);

final birthdayCategory = Category(
  categoryId: 4,
  name: "Birthday",
  icon: Icons.cake,
);

// List semua kategori
final categories = [
  allCategory,
  musicCategory,
  meetUpCategory,
  golfCategory,
  birthdayCategory,
];