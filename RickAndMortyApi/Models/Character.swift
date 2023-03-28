//
//  Character.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 20.03.2023.
//

import Foundation

struct Character: Decodable {
    let name: String
    let status: String
    let species: String
    let origin: Origin
    let location: Origin
    let image: String
    let episode: [String]
    
    init(
        name: String,
        status: String,
        species: String,
        origin: Origin,
        location: Origin,
        image: String,
        episode: [String]
    ) {
        self.name = name
        self.status = status
        self.species = species
        self.origin = origin
        self.location = location
        self.image = image
        self.episode = episode
    }
    
    init(characterData: [String: Any]) {
        name = characterData["name"] as? String ?? ""
        status = characterData["status"] as? String ?? ""
        species = characterData["species"] as? String ?? ""
        origin = characterData["origin"] as? Origin ?? Origin(name: "", url: "")
        location = characterData["location"] as? Origin ?? Origin(name: "", url: "")
        image = characterData["image"] as? String ?? ""
        episode = characterData["episode"] as? [String] ?? [""]
    }
    
    static func getCharacters(from value: Any) -> [Character] {
        guard let resultsData = value as? [String:Any] else { return [] }
        guard let charactersData = resultsData["results"] as? [[String:Any]] else {
            return []
        }
        
        return charactersData.map { Character(characterData: $0) }
    }
}

struct Origin: Decodable {
    let name: String
    let url: String
}

struct Info: Decodable {
    let pages: Int
    let next: String?
    let prev: String?
    
    static func getInfo(from value: Any) -> Info {
        guard let resultsData = value as? [String: Any] else {
            return Info(pages: 0, next: "", prev: "")
        }
        guard let infoData = resultsData["info"] as? [String: Any] else {
            return Info(pages: 0, next: "", prev: "")
        }
        
        let info = Info(
            pages: infoData["pages"] as? Int ?? 0,
            next: infoData["next"] as? String,
            prev: infoData["prev"] as? String
        )
        return info
    }
}

struct Location: Decodable {
    let name: String
    let type: String
    let dimension: String
    let residents: [Character]
    
    init(name: String, type: String, dimension: String, residents: [Character]) {
        self.name = name
        self.type = type
        self.dimension = dimension
        self.residents = residents
    }
    
    init(locationsData: [String: Any]) {
        name = locationsData["name"] as? String ?? ""
        type = locationsData["type"] as? String ?? ""
        dimension = locationsData["dimension"] as? String ?? ""
        residents = locationsData["residents"] as? [Character] ?? []
    }
    
    static func getLocations(from value: Any) -> [Location] {
        guard let resultsData = value as? [String: Any] else { return [] }
        guard let locationsData = resultsData["results"] as? [[String: Any]] else {
            return []
        }
        
        return locationsData.map { Location(locationsData: $0) }
    }
}

struct Episode: Decodable {
    let name: String
    let episode: String
    
    init(name: String, episode: String) {
        self.name = name
        self.episode = episode
    }
    
    init(episodeData: [String: Any]) {
        name = episodeData["name"] as? String ?? ""
        episode = episodeData["episode"] as? String ?? ""
    }
    
    static func getEpisodes(from value: Any) -> [Episode] {
        guard let resultsData = value as? [String: Any] else { return [] }
        guard let episodesData = resultsData["results"] as? [[String: Any]] else {
            return []
        }
        return episodesData.map { Episode(episodeData: $0) }
    }
}
