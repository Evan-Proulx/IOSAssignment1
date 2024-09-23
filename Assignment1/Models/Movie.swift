//
//  Movie.swift
//  Assignment1
//
//  Created by Evan Proulx on 2024-09-12.
//

import Foundation

enum Section{
    case main
}

struct Movies: Codable{
    var results: [Movie]
}

struct Movie:Codable,Hashable{
    static var lastId: Int = 0
    
    var id: Int
    var backdropPath: String?
    var title: String
    var overview: String?
    var posterPath: String?
    var releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
            case id
            case backdropPath = "backdrop_path"
            case title
            case overview = "overview"
            case posterPath = "poster_path"
            case releaseDate = "release_date"
        }
    
    init(backdropPath: String?, title: String, overview: String?, posterPath: String?, releaseDate: String?) {
            self.id = Movie.lastId
            Movie.lastId += 1
            self.backdropPath = backdropPath
            self.title = title
            self.overview = overview
            self.posterPath = posterPath
            self.releaseDate = releaseDate
        }
}
