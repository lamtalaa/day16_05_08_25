//
//  NetworkManager.swift
//  AASearch
//
//  Created by Yassine Lamtalaa on 5/8/25.
//

import Foundation

enum ApiError: Error {
    case invalidUrl
    case invalidResponse
    case jsonParsingFailed(String)
}

class NetworkManager {
    
    func doApi<T: Decodable>(endPoint: String, modelName: T.Type) async throws -> T where T: Decodable {
        guard let url = URL(string: endPoint) else {
            throw ApiError.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode( modelName.self, from: data)
    }
}
