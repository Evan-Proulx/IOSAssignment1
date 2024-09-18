//
//  Actor.swift
//  Assignment1
//
//  Created by Evan Proulx on 2024-09-18.
//

import Foundation


struct Actors: Codable, Hashable {
    var results: [Actor]
}

struct Actor: Codable, Hashable {
    let adult: Bool
    let gender: Int
    let id: Int
    let knownForDepartment: String?
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let knownFor: [Media]
    
    // To handle snake_case from JSON keys
    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case knownFor = "known_for"
    }
    
    // Adding Hashable conformance for `Actor`
    static func == (lhs: Actor, rhs: Actor) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.originalName == rhs.originalName &&
               lhs.knownFor == rhs.knownFor
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(originalName)
        hasher.combine(knownFor)
    }
}

struct Media: Codable, Hashable {
    let backdropPath: String?
    let id: Int
    let title: String?
    let originalTitle: String?
    let overview: String
    let posterPath: String?
    let mediaType: String
    let adult: Bool
    let originalLanguage: String
    let genreIDs: [Int]
    let popularity: Double
    let releaseDate: String?
    let firstAirDate: String?
    let voteAverage: Double
    let voteCount: Int
    
    // To handle snake_case from JSON keys
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult
        case originalLanguage = "original_language"
        case genreIDs = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    // Adding Hashable conformance for `Media`
    static func == (lhs: Media, rhs: Media) -> Bool {
        return lhs.id == rhs.id && lhs.mediaType == rhs.mediaType
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(mediaType)
    }
}
