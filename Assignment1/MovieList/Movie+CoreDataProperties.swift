//
//  Movie+CoreDataProperties.swift
//  Assignment1
//
//  Created by Evan Proulx on 2024-09-26.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var movieTitle: String
    @NSManaged public var movieRelease: String
    @NSManaged public var moviePoster: String
    @NSManaged public var movieDetails: String
    @NSManaged public var movieList: MovieList?

}

extension Movie : Identifiable {

}
