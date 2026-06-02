//
//  PhotoLibraryService.swift
//  PixelVault
//
//  Created by Tushar Mishra on 6/1/26.
//
import Photos
import UIKit

final class PhotoLibraryService {

    func requestPermission() async -> Bool {
        let currentStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch currentStatus {
        case .authorized, .limited:
            return true
        case .notDetermined:
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            return newStatus == .authorized || newStatus == .limited
        default:
            return false
        }
    }

    func fetchAssetCount() -> Int {
        PHAsset.fetchAssets(with: nil).count
    }

    func fetchAssetsAfterLastUpload() -> [PHAsset] {
        let lastUploadDate = UserDefaults.standard.object(forKey: "lastUploadDate") as? Date ?? .distantPast

        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        options.predicate = NSPredicate(format: "creationDate > %@", lastUploadDate as NSDate)

        let result = PHAsset.fetchAssets(with: options)

        var assets: [PHAsset] = []
        result.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }

        return assets
    }

    func getOriginalData(for asset: PHAsset) async throws -> (data: Data, filename: String, mediaType: String) {
        try await withCheckedThrowingContinuation { continuation in
            let resources = PHAssetResource.assetResources(for: asset)

            guard let resource = resources.first else {
                continuation.resume(throwing: URLError(.fileDoesNotExist))
                return
            }

            var data = Data()

            let options = PHAssetResourceRequestOptions()
            options.isNetworkAccessAllowed = true

            PHAssetResourceManager.default().requestData(
                for: resource,
                options: options,
                dataReceivedHandler: { chunk in
                    data.append(chunk)
                },
                completionHandler: { error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        let mediaType = asset.mediaType == .video ? "video" : "image"
                        continuation.resume(returning: (data, resource.originalFilename, mediaType))
                    }
                }
            )
        }
    }
}
