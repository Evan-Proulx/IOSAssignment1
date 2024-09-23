//
//  FavoriteViewController.swift
//  Assignment1
//
//  Created by Evan Proulx on 2024-09-23.
//

import UIKit

class FavoriteViewController: UIViewController {
    //MARK: Properties
    var movies = [Movie]()    
    var movieStore = MovieStore()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieStore.getMovies()
        movies = movieStore.getAllMovies
        print("MOVIES: \(movies)")
        
        createSnapshot()
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
    
    //Send movie data to the detailView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let index = tableView.indexPathForSelectedRow else {return}
        let destinationVC = segue.destination as? DetailsViewController
        
        let movieToPass = datasource.itemIdentifier(for: index)
        destinationVC?.selectedMovie = movieToPass
        destinationVC?.movieStore = movieStore
    }

}
