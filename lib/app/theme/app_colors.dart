import 'package:flutter/material.dart';

/// Palette de couleurs "Dark Minimal" (noir & blanc) reprenant exactement
/// les tokens des maquettes HTML fournies par l'équipe.
///
/// NOTE POUR L'ÉQUIPE : si ce fichier existe déjà (créé par un autre
/// membre), fusionner les valeurs manquantes plutôt que d'écraser.
class AppColors {
  AppColors._();

  // Fonds
  static const Color background = Color(0xFF010101);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceContainerHigh = Color(0xFF272727);
  static const Color surfaceContainerLow = Color(0xFF161616);
  static const Color surfaceChip = Color(0xFF2A2A2A);

  // Bordures / séparateurs
  static const Color border = Color(0xFF2C2B2B);
  static const Color outline = Color(0xFF444748);

  // Textes
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF7C7979);
  static const Color textSecondary = Color(0xFFC8C6C5);

  // États
  //static const Color error = Color(0xFFFFB4AB);
  // Le design mock est strictement monochrome : "Healthy" / "Connected"
  // sont représentés en blanc, pas en vert.
  //static const Color success = Color(0xFFFFFFFF);

  //------------
    static const primary = Color(0xFF3D5AFE);
  static const secondary = Color(0xFF00BFA5);

  static const backgroundLight = Color(0xFFF7F8FA);
  static const backgroundDark = Color(0xFF0F1115);

  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF1A1D24);

  static const textPrimaryLight = Color(0xFF14151A);
  static const textPrimaryDark = Color(0xFFF2F3F5);

  static const textSecondaryLight = Color(0xFF6B7280);
  static const textSecondaryDark = Color(0xFF9AA0AC);

  static const success = Color(0xFF2ECC71);
  static const warning = Color(0xFFF5A623);
  static const error = Color(0xFFE74C3C);
}
