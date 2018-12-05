//
//  favData.swift
//  moviesSearch
//
//  Created by Mostafa Diaa on 12/5/18.
//  Copyright © 2018 Mostafa Diaa. All rights reserved.
//

import Foundation
import UIKit
import Firebase
struct favData {
    var movieTitel : String
    var movieImg :String
    var year:String
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        movieTitel = snapshotValue["Movie Title"] as! String
        movieImg = snapshotValue["MovieImage"] as? String ?? "0"
        year = snapshotValue["Year"] as? String ?? "0"

    }
    
}
