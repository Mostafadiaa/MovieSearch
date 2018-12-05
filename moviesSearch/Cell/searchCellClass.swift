//
//  searchCellClass.swift
//  moviesSearch
//
//  Created by Mostafa Diaa on 12/4/18.
//  Copyright © 2018 Mostafa Diaa. All rights reserved.
//

import UIKit

class searchCellClass: UITableViewCell {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var year: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
