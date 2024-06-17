//
//  APIService.swift
//  VideoPlayerSwiftUI
//
//  Created by Bechir Belkahla on 17/6/2024.
//

import Foundation

final class APIService {
    
    static let shared = APIService()
    private var session: URLSession
        
    //Creating an initializer for unit testing purpose
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    //Async method for getting data from the API
    func fetchData<T: Decodable>(url: String, type: T.Type) async throws -> [T] {
        //Creating an URL object from the URL string
        guard let url = URL(string: url) else {
            throw NetworkErrors.invalidURL
        }
        
        //Creating the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["accept": "application/json"]
        
        do {
            //Making the API call
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkErrors.invalidResponse
            }

            do {
                //Decoding the data inside our country object
                let decoder = JSONDecoder()
                return try decoder.decode([T].self, from: data)
            }
            catch {
                throw NetworkErrors.decodingError
            }
            
        } catch {
            throw NetworkErrors.requestFailed
        }
    }
}
