//
//  DetailsViewController.swift
//  Assignment1
//
//  Created by Evan Proulx on 2024-09-16.
//

import UIKit

class DetailsViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    var selectedMovie: Movie!
    var movieList: MovieList!
    
    var coreDataStack = CoreDataStack(modelName: "MovieModel")

    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        //set data
        movieTitle.text = selectedMovie.movieTitle
        details.text = selectedMovie.movieDetails
        date.text = "Release Date: \(selectedMovie.movieRelease)"
        //get image from url
        fetchImage(forPath: selectedMovie.moviePoster)
        //set custom font for title
        if let customFont = UIFont(name: "ProtestGuerrilla-Regular", size: 33){
            movieTitle.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: customFont)
        }
    }
    
    func fetchImage(forPath path:String){
        let initialPath = "https://image.tmdb.org/t/p/w500/"
        let posterPath = initialPath + path
        
        guard let imageURL = URL(string: posterPath) else {
            print("Can't make this url: \(posterPath)")
            return
        }
        let imageFetch = URLSession.shared.downloadTask(with: imageURL){
            url, response, error in
            
            if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data){
                //set image
                DispatchQueue.main.async{
                    self.detailImage.image = image
                }
            }
        }
        imageFetch.resume()
    }
    
    @IBAction func addToFavorites(_ sender: UIBarButtonItem) {
        //display animation and add movie to list
        let addedAnimation = CustomAnimation()
        addedAnimation.frame = view.bounds
        addedAnimation.isOpaque = false
        
        view.addSubview(addedAnimation)
        view.isUserInteractionEnabled = false
        
        //check if movie already in list
        guard let movies = movieList.movies as? Set<Movie> else{return}
        
        print(movies)
        if movies.contains(selectedMovie){
            addedAnimation.dialogTitle = NSString("Already Added")
            addedAnimation.dialogFillColour = UIColor.yellow
        }else{
            movieList.addToMovies(selectedMovie)
            addedAnimation.dialogTitle = NSString("Movie Added")
            addedAnimation.dialogFillColour = UIColor.green
        }
        
        coreDataStack.saveContext()
        
        addedAnimation.showDialog()
        let delay = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }

}
