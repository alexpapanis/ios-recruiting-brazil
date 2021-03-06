//
//  MovieDetailViewController.swift
//  Movs
//
//  Created by Alexandre Papanis on 30/03/19.
//  Copyright © 2019 Papanis. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class MovieDetailViewController: UIViewController {

    //MARK: Variables
    let defaults = UserDefaults.standard
    let disposeBag = DisposeBag()
    
    var movieViewModel: MovieViewModel?
    var isFavorited: Bool = false
    var favoriteMoviesId: [Int] = []
    
    //MARK: IB Outlets
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lbMovieTitle: UILabel!
    @IBOutlet weak var lbMovieYear: UILabel!
    @IBOutlet weak var lbGenres: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var btFavorite: UIButton!
    
    //MARK: IB Actions
    @IBAction func addOrRemoveFavorite(_ sender: UIButton) {
        favoriteMoviesId = defaults.array(forKey: "favoriteMoviesId") as? [Int] ?? []
        
        if favoriteMoviesId.contains(movieViewModel!.id) {
            removeMovieFromFavorites()
        } else {
            addMovieToFavorites()
        }
        
    }
    
    //MARK: UIViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupUI()
        setupNavBar()
        
    }
    
    //MARK: setup UI
    fileprivate func setupUI() {
        
        self.lbMovieTitle.text = movieViewModel?.title
        self.lbMovieYear.text = movieViewModel?.releaseDate
        self.lbGenres.text = movieViewModel?.genres
        self.lbDescription.text = movieViewModel?.description
        
        self.imgMovie.lock(duration: 0)
        self.imgMovie.image = nil
        movieViewModel!.coverLocalPathObservable.subscribe(onNext: { coverLocalPath in
            guard let coverLocalPath = coverLocalPath else { return }
            
            do {
                let url = URL(fileURLWithPath: coverLocalPath)
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                self.imgMovie.image = image
            } catch {
                self.imgMovie.image = UIImage(named: "movieNegative")
                print(error)
            }
            self.imgMovie.unlock()
        }).disposed(by: disposeBag)
        
        favoriteMoviesId = defaults.array(forKey: "favoriteMoviesId") as? [Int] ?? []
        if favoriteMoviesId.contains(movieViewModel!.id) {
            markMovieAsFavorite()
        }
        else {
            unmarkMovieAsFavorite()
        }
    
    }
    
    //MARK: other methods
    fileprivate func markMovieAsFavorite(){
        isFavorited = true
        btFavorite.setImage(UIImage(named: "favorite_full_icon"), for: .normal)
    }
    
    fileprivate func unmarkMovieAsFavorite(){
        isFavorited = false
        btFavorite.setImage(UIImage(named: "favorite_gray_icon"), for: .normal)
    }
    
    fileprivate func addMovieToFavorites(){
        FavoriteMovie.addFavoriteMovie(movieViewModel: movieViewModel!)
        movieViewModel!.isFavorited = true
        markMovieAsFavorite()
        FirebaseAnalyticsHelper.addFavoriteEventLogger(movieId: movieViewModel!.id, movieTitle:movieViewModel!.title )
    }
    
    fileprivate func removeMovieFromFavorites() {
        FavoriteMovie.removeFavoriteMovie(id: movieViewModel!.id)
        movieViewModel!.isFavorited = false
        unmarkMovieAsFavorite()
        FirebaseAnalyticsHelper.removeFavoriteEventLogger(movieId: movieViewModel!.id, movieTitle:movieViewModel!.title )
    }
    
    fileprivate func setupNavBar(){
        navigationItem.largeTitleDisplayMode = .never
    }
    
}
