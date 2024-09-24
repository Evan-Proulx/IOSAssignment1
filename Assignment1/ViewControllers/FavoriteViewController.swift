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

        tableView.delegate = self
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
        snapshot.appendItems(movieStore.getAllMovies)
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
    
    func deleteAlert(){
        
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

//allow for swiping on row to delete record
extension FavoriteViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove"){
            _, _, completionHandler in
            guard let itemToRemove = self.datasource.itemIdentifier(for: indexPath) else{return}
            
            //alert before deleting
            let alert = UIAlertController(title: "DELETE", message: "Are you sure you want to delte?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive){
                _ in
                //delete movie
                self.movieStore.removeMovie(movie: itemToRemove)
                self.createSnapshot()
                
                completionHandler(true)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel){
                _ in
            })
            //show alert
            self.present(alert, animated: true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor.red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
