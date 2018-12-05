//
//  movieData.swift
//  moviesSearch
//
//  Created by Mostafa Diaa on 12/4/18.
//  Copyright © 2018 Mostafa Diaa. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
struct movieData {
    var movieTitel : String
    var movieImg :String
    var year:String
    
    init(movieTitel:String,movieImg:String,year:String) {
        self.movieImg = movieImg
        self.movieTitel = movieTitel
        self.year = year
    }
    

    
}
