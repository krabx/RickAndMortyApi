//
//  NetworkManager.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 23.03.2023.
//

import Foundation

enum Links {
    case character
    case location
    case episode
    
    var url: URL {
        switch self {
        case .character:
            return URL(string: "https://rickandmortyapi.com/api/character")!
        case .location:
            return URL(string: "https://rickandmortyapi.com/api/location")!
        case .episode:
            return URL(string:"https://rickandmortyapi.com/api/episode")!
        }
    }
}

enum NetworkError: Error {
    case failURL
    case failData
    case failDecode
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init () {}
    
    func fetch<T: Decodable>(
        _ type: T.Type,
        from url: URL,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.failData))
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let dataModel = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dataModel))
                }
            } catch {
                completion(.failure(.failDecode))
            }
        }.resume()
    }
    
    func fetchImage(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.failData))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
}
