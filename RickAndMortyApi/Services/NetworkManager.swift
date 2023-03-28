//
//  NetworkManager.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 23.03.2023.
//

import Foundation
import Alamofire

enum Link {
    case character
    case location
    case episode
    
    var url: String {
        switch self {
        case .character:
            return "https://rickandmortyapi.com/api/character"
        case .location:
            return "https://rickandmortyapi.com/api/character"
        case .episode:
            return "https://rickandmortyapi.com/api/character"
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
    
    func fetchCharacters(from url: String, completion: @escaping (Result<[Character], AFError>) -> Void) {
        AF.request(url)
            .responseJSON { dataResponse in
            guard let statusCode = dataResponse.response?.statusCode else { return }
            
            if (200...299).contains(statusCode) {
                switch dataResponse.result {
                case .success(let value):
                    let characters = Character.getCharacters(from: value)
                    completion(.success(characters))
                case .failure(let error):
                    completion(.failure(error))
                }
            } else {
                guard let error = dataResponse.error else { return }
                print(error)
            }
        }
    }
    
    func fetch<T: Decodable>(
        _ type: T.Type,
        from url: String?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    {
        guard let correctURL = url, let url = URL(string: correctURL) else {
            completion(.failure(.failURL))
            return
        }
        
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
    
    func fetchData(from url: String, completion: @escaping (Result<Data, AFError>) -> Void) {
        AF.request(url).responseData { dataResponse in
            guard let statusCode = dataResponse.response?.statusCode else { return }
            if (200..<300).contains(statusCode) {
                switch dataResponse.result {
                case .success(let imageData):
                    completion(.success(imageData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchImage(
        from url: String,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
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
