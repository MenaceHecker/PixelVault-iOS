//
//  PhotoLibraryService.swift
//  PixelVault
//
//  Created by Tushar Mishra on 6/1/26.
//
import Photos

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
        let assets = PHAsset.fetchAssets(with: nil)
        return assets.count
    }
}
