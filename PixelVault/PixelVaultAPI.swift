//
//  PixelVaultAPI.swift
//  PixelVault
//
//  Created by Tushar Mishra on 6/2/26.
//

import Foundation

final class PixelVaultAPI {
    static let shared = PixelVaultAPI()

    private let baseURL = URL(string: "https://pixel-vault-two.vercel.app")!

    func uploadAsset(
        data: Data,
        filename: String,
        assetLocalIdentifier: String,
        takenAt: Date?,
        mediaType: String
    ) async throws {
        let url = baseURL.appendingPathComponent("/api/upload")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        func addField(_ name: String, _ value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        addField("assetLocalIdentifier", assetLocalIdentifier)
        addField("filename", filename)
        addField("mediaType", mediaType)

        if let takenAt {
            addField("takenAt", ISO8601DateFormatter().string(from: takenAt))
        }

        addField("size", "\(data.count)")

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
