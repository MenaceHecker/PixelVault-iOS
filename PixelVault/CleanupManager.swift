//
//  CleanupManager.swift
//  PixelVault
//
//  Created by Tushar Mishra on 6/3/26.
//
import Foundation
import Photos

struct ArchivedAsset: Codable {
    let id: String
    let assetLocalIdentifier: String
}

final class CleanupManager {
    private let api = PixelVaultAPI.shared
    private let photoService = PhotoLibraryService()

    func cleanupArchivedPhotos(appState: AppState) async {
        await MainActor.run {
            appState.isWorking = true
            appState.statusText = "Checking archived photos..."
        }

        let granted = await photoService.requestPermission()

        guard granted else {
            await MainActor.run {
                appState.statusText = "Photos permission denied."
                appState.isWorking = false
            }
            return
        }

        do {
            let archivedAssets = try await api.fetchArchivedAssets()

            guard !archivedAssets.isEmpty else {
                await MainActor.run {
                    appState.statusText = "No archived photos ready to delete."
                    appState.isWorking = false
                }
                return
            }

            let identifiers = archivedAssets.map { $0.assetLocalIdentifier }

            try await deleteAssets(localIdentifiers: identifiers)

            try await api.markIphoneDeleted(ids: archivedAssets.map { $0.id })

            await MainActor.run {
                appState.statusText = "Deleted \(archivedAssets.count) archived photos from iPhone."
                appState.archivedCount = 0
                appState.isWorking = false
            }

        } catch {
            await MainActor.run {
                appState.statusText = "Cleanup failed: \(error.localizedDescription)"
                appState.isWorking = false
            }
        }
    }

    private func deleteAssets(localIdentifiers: [String]) async throws {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: localIdentifiers, options: nil)

        guard assets.count > 0 else {
            return
        }

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.deleteAssets(assets)
            } completionHandler: { success, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if success {
                    continuation.resume(returning: ())
                } else {
                    continuation.resume(throwing: URLError(.cannotRemoveFile))
                }
            }
        }
    }
}
