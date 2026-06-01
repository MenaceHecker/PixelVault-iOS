//
//  ContentView.swift
//  PixelVault
//
//  Created by Tushar Mishra on 5/27/26.
//

import SwiftUI

struct ContentView: View {

    @State private var statusText = "Ready"

    private let photoService = PhotoLibraryService()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Text("PixelVault")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Button("Upload New Photos") {
                    Task {
                        statusText = "Checking permissions..."

                        let granted = await photoService.requestPermission()

                        if granted {
                            let count = photoService.fetchAssetCount()
                            statusText = "Found \(count) photos/videos"
                        } else {
                            statusText = "Photos permission denied"
                        }
                    }
                }
                .buttonStyle(.borderedProminent)

                Text(statusText)

                Spacer()
            }
            .padding()
        }
    }
}
