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
    var id: Int
    var title: String
    var overview: String
    var votes: Double
    var releaseDate: String?
    var poster: String?
    var backdrop: String?
    
    enum CodingKeys: String, CodingKey{
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case poster = "poster_path"
        case backdrop = "backdrop_path"
        case votes = "vote_average"
    }
}
