//
//  MovieStore.swift
//  Assignment1
//
//  Created by Evan Proulx on 2024-09-23.
//

import Foundation

import UIKit

class MovieStore{
    private var movies: [Movie] = []
    
    var numMovies: Int{
        return movies.count
    }
    
    var getAllMovies: [Movie]{
        return movies
    }
    
    var documentDirectory: URL?{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return(paths[0])
    }
    
    //Check if movie already exists in the array
    func alreadyInList(movie: Movie) -> Bool{
        if movies.contains(movie){
            return true
        }else{
            return false
        }
    }
    
    func addNewMovie(movie: Movie){
        movies.append(movie)
        saveMovies()
        print("MOVIES: \(numMovies)")
    }
    
    //If the selected movie exists in the list, remove it from the array and save
    func removeMovie(movie: Movie){
        for(index, storedMovie) in movies.enumerated(){
            if storedMovie.id == movie.id{
                movies.remove(at: index)
                saveMovies()
                return
            }
        }
    }
    
    func updateMovie(withId id: Int, updatedMovie: Movie) {
        for (index, movie) in movies.enumerated() {
            if movie.id == id {
                movies[index] = updatedMovie
                saveMovies()
                return
            }
        }
    }

    //Takes json url and updates it with the movie data
    func save(to url: URL){
        do{
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(movies)
            try jsonData.write(to: url)
            print("SAVED")
        } catch {
            print("Error encoding the JSON - \(error.localizedDescription)")
        }
    }
    
    //gets data from the json url and decodes it
    func retrieve(from url: URL){
        do{
            let jsonDecoder = JSONDecoder()
            let jsonData = try Data(contentsOf: url)
            movies = try jsonDecoder.decode([Movie].self, from: jsonData)
        } catch {
            print("Error decoding the JSON - \(error.localizedDescription)")
        }
    }
    
    //calls the save method with the correct file path to the json data
    func saveMovies(){
        guard let documentDirectory = documentDirectory else { return }
        let fileName = documentDirectory.appendingPathComponent("movieList.json")
        save(to: fileName)
    }
    
    //calls the retrieve method with the correct file path to the json data
    func getMovies(){
        guard let documentDirectory = documentDirectory else { return }
        let fileURL = documentDirectory.appendingPathComponent("movieList.json")
        retrieve(from: fileURL)
    }
}
