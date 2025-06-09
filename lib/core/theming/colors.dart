import 'dart:ui';

import 'package:flutter/material.dart';

class ColorsManager {
  // Use Royal Indigo (#2A3E97) as your brand's leading color across headers, main buttons, and active states.
  static const Color royalIndigo = Color(0xFF2A3E97); // Main Blue

  // Apply Coral Blaze (#FF3D57) on action buttons like "Contact", "Book Now", or "Learn More".
  static const Color coralBlaze = Color(0xFFFF3D57); // Accent / CTA

  // Let the Mist White (#F9FAFC) dominate background to make content and controls pop.
  static const Color mistWhite = Color(0xFFF9FAFC); // Light Background

  // Pale Lavender Blue (#E1E4F0) - use in cards, elevated components. Balances well with the primary.
  static const Color paleLavenderBlue = Color(0xFFE1E4F0); // Light Surface

  // For a dark theme, reverse with Deep Charcoal (#1C1D26) as the base.
  static const Color deepCharcoal =
      Color(0xFF1C1D26); // Dark Surface (not used here)

  // Status Colors
  static const Color freshMint = Color(0xFF2ECC71); // Success
  static const Color brightGold = Color(0xFFF1C40F); // Warning
  static const Color softCrimson = Color(0xFFE74C3C); // Error

  // Text Colors
  static const Color graphiteBlack = Color(0xFF1A1A1A); // Primary Text
  static const Color slateGray = Color(0xFF6C7380); // Secondary Text

  // Keep consistency in button shapes and apply rounded corners (12–16px) with subtle shadows to modernize the feel.
}
