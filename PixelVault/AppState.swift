//
//  AppState.swift
//  PixelVault
//
//  Created by Tushar Mishra on 6/2/26.
//
import Foundation
import Combine
import Foundation

@MainActor
final class AppState: ObservableObject {
    @Published var statusText = "Ready"
    @Published var pendingCount = 0
    @Published var archivedCount = 0
    @Published var lastUploadText = "Never"
    @Published var isWorking = false
}
