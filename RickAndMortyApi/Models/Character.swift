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
    let location: CharacterLocation
    let image: String
    let episode: [String]
    
    init(name: String, status: String, species: String, origin: Origin, location: CharacterLocation, image: String, episode: [String]) {
        self.name = name
        self.status = status
        self.species = species
        self.origin = origin
        self.location = location
        self.image = image
        self.episode = episode
    }
    
    init(CharacterData: [String: Any]) {
        name = CharacterData["name"] as? String ?? ""
        status = CharacterData["status"] as? String ?? ""
        species = CharacterData["species"] as? String ?? ""
        origin = CharacterData["origin"] as? Origin ?? Origin(name: "", url: "")
        location = CharacterData["location"] as? CharacterLocation ?? CharacterLocation(name: "", url: "")
        image = CharacterData["image"] as? String ?? ""
        episode = CharacterData["episode"] as? [String] ?? [""]
    }
    
    static func getCharacters(from value: Any) -> [Character] {
        guard let resultsData = value as? [String:Any] else { return []}
        guard let CharactersData = resultsData["results"] as? [[String:Any]] else { return []}
        return CharactersData.map { Character(CharacterData: $0) }
    }
}

struct Origin: Decodable {
    let name: String
    let url: String
}

struct CharacterLocation: Decodable {
    let name: String
    let url: String
}

struct AboutCharacters: Decodable {
    let info: Info
    let results: [Character]
}

struct Info: Decodable {
    let pages: Int
    let next: String?
    let prev: String?
}

struct AboutLocations: Decodable {
    let results: [Location]
}

struct Location: Decodable {
    let name: String
    let type: String
    let url: String
}

struct AboutEpisodes: Decodable {
    let results: [Episode]
}

struct Episode: Decodable {
    let name: String
    let episode: String
}


