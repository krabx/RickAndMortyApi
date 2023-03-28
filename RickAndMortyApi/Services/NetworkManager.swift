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
            return "https://rickandmortyapi.com/api/location"
        case .episode:
            return "https://rickandmortyapi.com/api/episode"
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init () {}
    
    func fetchInfo(from url: String?, completion: @escaping (Result<Info, AFError>) -> Void){
        guard let url else { return }
        AF.request(url).responseJSON { dataResponse in
            guard let statusCode = dataResponse.response?.statusCode else { return }
            if (200..<300).contains(statusCode) {
                switch dataResponse.result {
                case .success(let value):
                    let info = Info.getInfo(from: value)
                    completion(.success(info))
                case .failure(let error):
                    print(error)
                }
            } else {
                guard let error = dataResponse.error else { return }
                print(error)
            }
        }
    }
    
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
    
    func fetchLocations(from url: String, completion: @escaping (Result<[Location], AFError>) -> Void) {
        AF.request(url).responseJSON { dataResponse in
            guard let statusCode = dataResponse.response?.statusCode else { return }
            
            if (200...299).contains(statusCode) {
                switch dataResponse.result {
                case .success(let value):
                    let locations = Location.getLocations(from: value)
                    completion(.success(locations))
                case .failure(let error):
                    completion(.failure(error))
                }
            } else {
                guard let error = dataResponse.error else { return }
                print(error)
            }
        }
    }
    
    func fetchEpisodes(from url: String, completion: @escaping (Result<[Episode], AFError>) -> Void) {
        AF.request(url).responseJSON { dataResponse in
            guard let statusCode = dataResponse.response?.statusCode else { return }
            
            if (200...299).contains(statusCode) {
                switch dataResponse.result {
                case .success(let value):
                    let episodes = Episode.getEpisodes(from: value)
                    completion(.success(episodes))
                case .failure(let error):
                    completion(.failure(error))
                }
            } else {
                guard let error = dataResponse.error else { return }
                print(error)
            }
        }
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
}
