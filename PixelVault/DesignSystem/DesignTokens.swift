//
//  DesignTokens.swift
//  PixelVault
//
//  Created by Tushar Mishra on 5/27/26.
//

import SwiftUI

// MARK: - Color Tokens

extension Color {
    /// Primary brand – deep indigo
    static let pvPrimary     = Color(hue: 0.69, saturation: 0.82, brightness: 0.88)
    /// Accent – vivid violet
    static let pvAccent      = Color(hue: 0.76, saturation: 0.75, brightness: 0.95)
    /// Success – teal-green
    static let pvSuccess     = Color(hue: 0.48, saturation: 0.72, brightness: 0.78)
    /// Warning – amber
    static let pvWarning     = Color(hue: 0.10, saturation: 0.88, brightness: 0.96)
    /// Destructive – coral-red
    static let pvDestructive = Color(hue: 0.01, saturation: 0.80, brightness: 0.92)

    /// Background (system-aware)
    static let pvBackground  = Color(.systemBackground)
    /// Grouped background
    static let pvGrouped     = Color(.secondarySystemBackground)
    /// Surface (card / sheet)
    static let pvSurface     = Color(.tertiarySystemBackground)

    /// Primary text
    static let pvTextPrimary   = Color(.label)
    /// Secondary text
    static let pvTextSecondary = Color(.secondaryLabel)
}

// MARK: - Gradient Tokens

extension LinearGradient {
    /// Primary brand gradient (top-leading → bottom-trailing)
    static let pvBrand = LinearGradient(
        colors: [.pvPrimary, .pvAccent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Spacing Tokens

enum Spacing {
    static let xxs: CGFloat =  4
    static let xs:  CGFloat =  8
    static let sm:  CGFloat = 12
    static let md:  CGFloat = 16
    static let lg:  CGFloat = 24
    static let xl:  CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Radius Tokens

enum Radius {
    static let sm:   CGFloat =  8
    static let md:   CGFloat = 12
    static let lg:   CGFloat = 16
    static let xl:   CGFloat = 24
    static let full: CGFloat = 999
}

// MARK: - Shadow

struct PVShadow {
    let color:  Color
    let radius: CGFloat
    let x:      CGFloat
    let y:      CGFloat

    /// Subtle card lift
    static let card = PVShadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
    /// Elevated modal
    static let elevated = PVShadow(color: Color.black.opacity(0.20), radius: 24, x: 0, y: 8)
}

extension View {
    func pvShadow(_ shadow: PVShadow = .card) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
