//
//  ContentView.swift
//  PixelVault
//
//  Created by Tushar Mishra on 5/27/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()

    private let uploadManager = UploadManager()
    private let cleanupManager = CleanupManager()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("PixelVault")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("iPhone photo relay")
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 12) {
                    infoRow("Pending on Pixel", "\(appState.pendingCount)")
                    infoRow("Ready to Delete", "\(appState.archivedCount)")
                    infoRow("Last Upload", appState.lastUploadText)
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Button {
                    Task {
                        await uploadManager.uploadNewPhotos(appState: appState)
                    }
                } label: {
                    Text(appState.isWorking ? "Working..." : "Upload New Photos")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(appState.isWorking)

                Button {
                    appState.statusText = "Cleanup coming next"
                } label: {
                    Text("Clean Up Archived Photos")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(appState.isWorking)

                Text(appState.statusText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding()
        }
    }

    private func infoRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}
