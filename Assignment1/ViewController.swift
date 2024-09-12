//
//  ViewController.swift
//  Assignment1
//
//  Created by Evan Proulx on 2024-09-12.
//

import UIKit

class ViewController: UIViewController {
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    func createUrl(text: String) -> URL?{
        //create url
        var text = ""
        guard let cleanURL = text.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { fatalError("Can't make a url from: \(text)")}
        //TODO: - ADD YOUR API KEY HERE
        let api_key = "69ad4a4df621816f1475a08fc5291b7b"
        var urlString = "https://api.themoviedb.org/3/search/movie?query="
        urlString = urlString.appending(cleanURL)
        urlString = urlString.appending("&api_key=\(api_key)")
        
        print(urlString)
        
        return URL(string: urlString)
    }
    
    
    func getResults(url: URL){
        //get results
        let movieTask = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            if let dataError = error {
                print("Error fetching results: \(dataError.localizedDescription)")
            }else{
                guard let fetchedData = data else { return }
                
                do{
                    let jsonDecoder = JSONDecoder()
                    let downloadedResults = try jsonDecoder.decode(Movies.self, from: fetchedData)
                    
                    self.movies = downloadedResults.results
                    print(self.movies)
                    
//                    DispatchQueue.main.async {
//                        self.createSnapshot()
//                    }
                } catch DecodingError.valueNotFound(let type, let context){
                    print("Error - value not found \(type): \(context)")
                } catch DecodingError.typeMismatch(let type, let context){
                    print("Error - types do not match \(type): \(context)")
                } catch DecodingError.keyNotFound(let key, let context){
                    print("Error - missing key \(key): \(context)")
                } catch{
                    print("Problem decoding: \(error.localizedDescription)")
                }
            }
        }
        movieTask.resume()
    }
    
}



