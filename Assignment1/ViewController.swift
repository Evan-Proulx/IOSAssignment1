//
//  ViewController.swift
//  Assignment1
//
//  Created by Evan Proulx on 2024-09-12.
//

import UIKit

class ViewController: UIViewController {
    var movies = [Movie]()
    var actors = [Actor]()
    
    @IBOutlet weak var searchSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchType = "movie"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
    }
    
    
    //MARK: Datasources
    //tableview for movies
    lazy var datasource = UITableViewDiffableDataSource<Section, Movie>(tableView: tableView){
        tableview, indexpath, movie in
        let cell = tableview.dequeueReusableCell(withIdentifier: "movieCell", for: indexpath) as? MovieTableViewCell

        cell?.title.text = movie.title
        
        if let moviePosterPath = movie.poster{
            self.fetchImage(forPath: moviePosterPath, inCell: cell!)
        }
        return cell
    }
    
    //tableView for actors
    lazy var actorDatasource = UITableViewDiffableDataSource<Section, Actor>(tableView: tableView){
        tableview, indexpath, actor in
        let cell = tableview.dequeueReusableCell(withIdentifier: "movieCell", for: indexpath) as? MovieTableViewCell

        cell?.title.text = actor.name
        
        if let moviePosterPath = actor.profilePath{
            self.fetchImage(forPath: moviePosterPath, inCell: cell!)
        }
        return cell
    }
    //MARK: Snapshots
    //snapshot for movies
    func createSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        datasource.apply(snapshot,animatingDifferences: true)
    }
    //snapshot for actors
    func createActorSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Actor>()
        snapshot.appendSections([.main])
        snapshot.appendItems(actors)
        actorDatasource.apply(snapshot,animatingDifferences: true)
    }
    
    
    //MARK: Methods
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
        var urlString = "https://api.themoviedb.org/3/search/\(searchType)?query="
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
                    if self.searchType == "movie"{
                        let jsonDecoder = JSONDecoder()
                        let downloadedResults = try jsonDecoder.decode(Movies.self, from: fetchedData)
                        
                        self.movies.removeAll()
                        self.movies = downloadedResults.results
                        print(self.movies)
                        
                        DispatchQueue.main.async {
                            self.createSnapshot()
                        }
                    //get actor image
                    }else if self.searchType == "person"{
                        let jsonDecoder = JSONDecoder()
                        let downloadedResults = try jsonDecoder.decode(Actors.self, from: fetchedData)
                        
                        self.actors.removeAll()
                        self.actors = downloadedResults.results
                        print(self.actors)
                        
                        DispatchQueue.main.async {
                            self.createActorSnapshot()
                        }
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
    
    //sets search type when the swich changes state
    @IBAction func setSearch(_ sender: Any) {
        if searchType == "movie"{
            searchType = "person"
            createActorSnapshot()
        }else if searchType == "person"{
            searchType = "movie"
            createSnapshot()
        }
        
        print("SWITCHED: \(searchType)")
    }
    
    //send data to the detailView depending on the searchType
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let index = tableView.indexPathForSelectedRow else {return}
        let destinationVC = segue.destination as! DetailsViewController
        
        if searchType == "movie"{
            let movieToPass = datasource.itemIdentifier(for: index)
            destinationVC.selectedMovie = movieToPass
            destinationVC.detailType = searchType
        }else if searchType == "person"{
            let actorToPass = actorDatasource.itemIdentifier(for: index)
            destinationVC.selectedActor = actorToPass
            destinationVC.detailType = searchType
        }
    }
}



extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Test")
        guard let text = searchBar.text, !text.isEmpty else { return }
        if let movieURL = createUrl(text: text){
            print("test")
            getResults(url: movieURL)
        }
        searchBar.resignFirstResponder()
    }
}

