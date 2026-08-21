//
//  RootView.swift
//  PixelVault
//
//  Created by Tushar Mishra on 5/27/26.
//

import SwiftUI

// MARK: - Tab Definition

enum PVTab: String, CaseIterable {
    case library  = "Library"
    case upload   = "Upload"
    case settings = "Settings"

    var icon: String {
        switch self {
        case .library:  "photo.stack"
        case .upload:   "arrow.up.circle"
        case .settings: "gearshape"
        }
    }
}

// MARK: - Root View

struct RootView: View {
    @State private var selectedTab: PVTab = .library

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(PVTab.allCases, id: \.self) { tab in
                tabContent(for: tab)
                    .tabItem {
                        Label(tab.rawValue, systemImage: tab.icon)
                    }
                    .tag(tab)
            }
        }
        .tint(.pvPrimary)
    }

    @ViewBuilder
    private func tabContent(for tab: PVTab) -> some View {
        switch tab {
        case .library:
            // Phase 3: replaced by LibraryView
            ContentView()
        case .upload:
            // Phase 5: replaced by UploadView
            PlaceholderView(title: "Upload", icon: "arrow.up.circle.fill")
        case .settings:
            // Phase 8: replaced by SettingsView
            PlaceholderView(title: "Settings", icon: "gearshape.fill")
        }
    }
}

// MARK: - Placeholder (removed once real views exist)

struct PlaceholderView: View {
    let title: String
    let icon:  String

    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.lg) {
                Image(systemName: icon)
                    .font(.system(size: 56, weight: .thin))
                    .foregroundStyle(LinearGradient.pvBrand)

                Text(title)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.pvTextPrimary)

                Text("Coming in a future phase")
                    .font(.subheadline)
                    .foregroundStyle(.pvTextSecondary)
            }
            .navigationTitle(title)
        }
    }
}

// MARK: - Preview

#Preview {
    RootView()
}
