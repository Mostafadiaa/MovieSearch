//
//  favViewController.swift
//  moviesSearch
//
//  Created by Mostafa Diaa on 12/4/18.
//  Copyright © 2018 Mostafa Diaa. All rights reserved.
//

import Firebase
import UIKit

class favViewController: UIViewController {
    var ref: DatabaseReference!
    @IBOutlet var favTabel: UITableView!
    var favItems: [favData] = [] {
        didSet {
            self.favTabel.reloadData()
        }
    }

    override func viewWillLayoutSubviews() {
        ref = Database.database().reference()
        ref.child("favourites").observeSingleEvent(of: .value) { snapshot,error in
            var gData: [favData] = []
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let lisitem = favData(snapshot: child)
                gData.append(lisitem)
                self.favItems = gData
                self.favTabel.reloadData()
            }
            if let error = error {
               print(" helloe \(error.description)")
                return
            }
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension favViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: favCellClass = favTabel.dequeueReusableCell(withIdentifier: "favCell") as! favCellClass
        let dataTableItems = favItems[indexPath.row]
        cell.favMovieName.text = dataTableItems.movieTitel
        cell.year.text = dataTableItems.year
        if let movieImageUrl = URL(string: dataTableItems.movieImg) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: movieImageUrl) {
                    DispatchQueue.main.async {
                        cell.favMovieimage.image = UIImage(data: data)
                    }
                } else {
                    return
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            let selectedMovie = self.favItems[indexPath.row].movieTitel
            self.ref.child("favourites").child(selectedMovie).removeValue()
            self.favTabel.reloadData()
            self.favItems.remove(at: indexPath.row)
             AlertController.showAlert(self, title: "Done", message: "Deleted Successfully From Favourites")
        }
     

        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}
