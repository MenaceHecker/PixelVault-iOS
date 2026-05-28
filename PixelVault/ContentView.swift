//
//  ContentView.swift
//  PixelVault
//
//  Created by Tushar Mishra on 5/27/26.
//

import SwiftUI

struct ContentView: View {
    @State private var statusText = "Ready"
    @State private var pendingCount = 0
    @State private var archivedCount = 0
    @State private var lastUploadText = "Never"

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
                    infoRow("Pending on Pixel", "\(pendingCount)")
                    infoRow("Ready to Delete", "\(archivedCount)")
                    infoRow("Last Upload", lastUploadText)
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Button {
                    statusText = "Upload flow coming next"
                } label: {
                    Text("Upload New Photos")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    statusText = "Cleanup flow coming next"
                } label: {
                    Text("Clean Up Archived Photos")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Text(statusText)
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

#Preview {
    ContentView()
}
