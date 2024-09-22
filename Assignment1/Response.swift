//
//  Response.swift
//  Assignment1
//
//  Created by Evan Proulx on 2024-09-22.
//

import Foundation

import Foundation

// Root struct to hold the page and results
struct Responses: Codable, Hashable {
    let results: [Response]
}

// General result item struct
struct Response: Codable, Hashable {
    let id: Int
    let mediaType: String
    let name: String?
    let originalName: String?
    let title: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let adult: Bool
    let originalLanguage: String?
    let genreIds: [Int]?
    let popularity: Double?
    let voteAverage: Double?
    let voteCount: Int?
    let firstAirDate: String?
    let releaseDate: String?
    let originCountry: [String]?
    let gender: Int?
    let knownForDepartment: String?
    let knownFor: [KnownFor]?
    let video: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case name
        case originalName = "original_name"
        case title
        case originalTitle = "original_title"
        case overview = "overview"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case adult
        case originalLanguage = "original_language"
        case genreIds = "genre_ids"
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
        case releaseDate = "release_date"
        case originCountry = "origin_country"
        case gender
        case knownForDepartment = "known_for_department"
        case knownFor = "known_for"
        case video
    }
}

// Struct for items inside "known_for"
struct KnownFor: Codable, Hashable {
    let id: Int
    let mediaType: String
    let title: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let adult: Bool
    let originalLanguage: String?
    let genreIds: [Int]
    let popularity: Double
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let video: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case title
        case originalTitle = "original_title"
        case overview = "overview"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case adult
        case originalLanguage = "original_language"
        case genreIds = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case video
    }
}
