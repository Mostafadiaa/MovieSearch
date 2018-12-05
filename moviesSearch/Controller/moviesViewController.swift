//
//  moviesViewController.swift
//  moviesSearch
//
//  Created by Mostafa Diaa on 12/4/18.
//  Copyright © 2018 Mostafa Diaa. All rights reserved.
//

import UIKit

import Alamofire
import RxCocoa
import RxSwift
import SwiftyJSON
import Firebase

class moviesViewController: UIViewController {
    var ref: DatabaseReference!
    @IBOutlet var tabel: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var error = false
    var errorString:String!
    var movies: [movieData] = [] {
        didSet {
            self.tabel.reloadData()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.setImage(UIImage(), for: .clear, state: .normal)
        hideKeyboardWhenTappedAround()
        search()
        ref = Database.database().reference()

    }

    func search() {
        searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { element in
                let newElemnt: String = element.replacingOccurrences(of: " ", with: "%20")
                let url = "https://www.omdbapi.com/?apikey=4b68052b" + "&s=" + newElemnt
                Alamofire.request(url).responseJSON(completionHandler: { response in
                    let alamoError = response.result.error
                    if alamoError != nil{
                        self.error = true
                        self.errorString = alamoError!.localizedDescription
                       AlertController.showAlert(self, title: "Warning", message: "\(alamoError!.localizedDescription)")
                    }
                    else{
                        self.error = false
                        if let value = response.result.value {
                            let json = JSON(value)
                            print(json)
                            self.movies.removeAll()
                            
                            for movieName in json["Search"] {
                                guard let imgUrl = movieName.1["Poster"].string
                                    else {
                                        return
                                }
                                guard let movieTitel = movieName.1["Title"].string
                                    else {
                                        return
                                }
                                guard let year = movieName.1["Year"].string
                                    else {
                                        return
                                }
                                
                                let movie = movieData(movieTitel: movieTitel, movieImg: imgUrl, year: year)
                                self.movies.append(movie)
                                print(self.movies)
                            }
                        }
                    }
               
                })

            })
    }
}

extension moviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: searchCellClass = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! searchCellClass
        cell.movieName.text = movies[indexPath.row].movieTitel
        if let movieImageUrl = URL(string: movies[indexPath.row].movieImg) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: movieImageUrl) {
                    DispatchQueue.main.async {
                        cell.movieImage.image = UIImage(data: data)
                    }
                } else {
                    return
                }
            }
        }
        cell.year.text = movies[indexPath.row].year

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let fav = UIContextualAction(style: .normal, title: "Favourite") { (action, view, nil) in
            if self.error == true{
                return
            }
            else{
                let selectedMovie = self.movies[indexPath.row].movieTitel
                let selectedMovieyear = self.movies[indexPath.row].year
                let selectedMovieImage = self.movies[indexPath.row].movieImg
                self.ref.child("favourites").child("\(selectedMovie)").setValue(["Movie Title" : selectedMovie])
                self.ref.child("favourites").child("\(selectedMovie)").updateChildValues(["Year" : selectedMovieyear])
                self.ref.child("favourites").child("\(selectedMovie)").updateChildValues(["MovieImage" : selectedMovieImage])
                AlertController.showAlert(self, title: "Done", message: "Successfully Added To Favourites")
            }
            }
           
        fav.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        fav.image = #imageLiteral(resourceName: "heart.png")
       
        let config =  UISwipeActionsConfiguration(actions: [fav])
        config.performsFirstActionWithFullSwipe = false
        return config
        
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
