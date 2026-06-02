//
//  UploadManager.swift
//  PixelVault
//
//  Created by Tushar Mishra on 6/2/26.
//


import Foundation
import Photos

final class UploadManager {
    private let photoService = PhotoLibraryService()
    private let api = PixelVaultAPI.shared

    func uploadNewPhotos(appState: AppState) async {
        await MainActor.run {
            appState.isWorking = true
            appState.statusText = "Requesting Photos permission..."
        }

        let granted = await photoService.requestPermission()

        guard granted else {
            await MainActor.run {
                appState.statusText = "Photos permission denied."
                appState.isWorking = false
            }
            return
        }

        let assets = photoService.fetchAssetsAfterLastUpload()

        guard !assets.isEmpty else {
            await MainActor.run {
                appState.statusText = "No new photos/videos to upload."
                appState.isWorking = false
            }
            return
        }

        var uploadedCount = 0

        for asset in assets {
            do {
                let file = try await photoService.getOriginalData(for: asset)

                try await api.uploadAsset(
                    data: file.data,
                    filename: file.filename,
                    assetLocalIdentifier: asset.localIdentifier,
                    takenAt: asset.creationDate,
                    mediaType: file.mediaType
                )

                uploadedCount += 1

                await MainActor.run {
                    appState.statusText = "Uploaded \(uploadedCount)/\(assets.count)"
                }

            } catch {
                await MainActor.run {
                    appState.statusText = "Upload failed after \(uploadedCount) files."
                    appState.isWorking = false
                }
                return
            }
        }

        UserDefaults.standard.set(Date(), forKey: "lastUploadDate")

        await MainActor.run {
            appState.statusText = "Uploaded \(uploadedCount) files successfully."
            appState.lastUploadText = Date().formatted(date: .abbreviated, time: .shortened)
            appState.isWorking = false
        }
    }
}
