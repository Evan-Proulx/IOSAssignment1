//
//  ViewController.swift
//  Assignment1
//
//  Created by Evan Proulx on 2024-09-12.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Properties
    var movies = [Movie]()
    var mixedResponse = [Response]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
    }
    
    
    //MARK: Table
    lazy var datasource = UITableViewDiffableDataSource<Section, Movie>(tableView: tableView){
        tableview, indexpath, movie in
        let cell = tableview.dequeueReusableCell(withIdentifier: "movieCell", for: indexpath) as? MovieTableViewCell

        cell?.title.text = movie.title
        
        if let moviePosterPath = movie.posterPath{
            self.fetchImage(forPath: moviePosterPath, inCell: cell!)
        }
        return cell
    }
    
    //MARK: Methods
    func createSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        datasource.apply(snapshot,animatingDifferences: true)
    }
    
    func fetchImage(forPath path:String, inCell cell: MovieTableViewCell){
        let initialPath = "https://image.tmdb.org/t/p/w500/"
        
        let posterPath = initialPath + path
        
        guard let imageURL = URL(string: posterPath) else {
            print("Can't make this url: \(posterPath)")
            return
        }
        
        let imageFetch = URLSession.shared.downloadTask(with: imageURL){
            url, response, error in
            
            if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data){
                
                //add image to cell
                DispatchQueue.main.async {
                    cell.img.image = image
                }
            }
        }
        imageFetch.resume()
    }
    
    //creates url with search and api key
    func createUrl(text: String) -> URL?{
        //create url
        guard let cleanURL = text.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { fatalError("Can't make a url from: \(text)")}
        let api_key = "69ad4a4df621816f1475a08fc5291b7b"
        var urlString = "https://api.themoviedb.org/3/search/multi?query="
        urlString = urlString.appending(cleanURL)
        urlString = urlString.appending("&api_key=\(api_key)")
        
        print(urlString)
        
        return URL(string: urlString)
    }
    
    //gets data back from api request and converts to movie objects
    func getResults(url: URL){
        //get results
        let movieTask = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            if let dataError = error {
                print("Error fetching results: \(dataError.localizedDescription)")
            }else{
                guard let fetchedData = data else { return }
                print(fetchedData)
                do{
                //get movie poster
                    let jsonDecoder = JSONDecoder()
                    let downloadedResults = try jsonDecoder.decode(Responses.self, from: fetchedData)
                    
                    self.movies.removeAll()
                    //convert search results to Movie objects
                    self.mixedResponse = downloadedResults.results
                    self.getMoviesFromResponse()
                
                    //fill table with movies
                    DispatchQueue.main.async {
                        self.createSnapshot()
                    }
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
    
    //Filters through the api response by the media type and adds movies to the table
    func getMoviesFromResponse(){
        for response in mixedResponse {
            switch response.mediaType{
            case "movie":
                if let backdrop = response.backdropPath, let title = response.title, let releaseDate = response.releaseDate{
                    let movie = Movie(backdropPath: backdrop, title: title, overview: response.overview, posterPath: response.posterPath, releaseDate: releaseDate)
                    movies.append(movie)
                }
                break
            case "tv":
                if let backdrop = response.backdropPath, let title = response.name, let releaseDate = response.firstAirDate{
                    let movie = Movie(backdropPath: backdrop, title: title, overview: response.overview, posterPath: response.posterPath, releaseDate: releaseDate)
                    print(movie)
                    movies.append(movie)
                }
                break
            case "person":
                if let knownFor = response.knownFor{
                    for film in knownFor{
                        if let backdrop = film.backdropPath, let title = film.title, let releaseDate = film.releaseDate{
                            let movie = Movie(backdropPath: backdrop, title: title, overview: film.overview, posterPath: film.posterPath, releaseDate: releaseDate)
                            movies.append(movie)
                        }
                    }
                }
            default:
                return
            }
        }
    }
    
    //Send mvoie data to the detailView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let index = tableView.indexPathForSelectedRow else {return}
        let destinationVC = segue.destination as! DetailsViewController
        
            let movieToPass = datasource.itemIdentifier(for: index)
            destinationVC.selectedMovie = movieToPass
    }
}


//MARK: Delegates

//gets input from searchbar and sends it to the api search method
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        if let movieURL = createUrl(text: text){
            print("test")
            getResults(url: movieURL)
        }
        searchBar.resignFirstResponder()
    }
}

