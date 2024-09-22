//
//  DetailsViewController.swift
//  Assignment1
//
//  Created by Evan Proulx on 2024-09-16.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    var selectedMovie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()

        //set data based on detail type
        movieTitle.text = selectedMovie?.title
        details.text = selectedMovie?.overview
        //tv shows dont have release dates
        if let releaseDate = selectedMovie?.releaseDate{
            date.text = "Release Date \(releaseDate)"
        }
        //get image from url
        if let posterPath = selectedMovie?.posterPath {
            fetchImage(forPath: posterPath)
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
