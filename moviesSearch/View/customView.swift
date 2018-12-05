//
//  customView.swift
//  moviesSearch
//
//  Created by Mostafa Diaa on 12/4/18.
//  Copyright © 2018 Mostafa Diaa. All rights reserved.
//

import UIKit
@IBDesignable
class customView: UIView {

    @IBInspectable var cornerRedius:CGFloat = 0 //cornerRedius
        {
        didSet{
            self.layer.cornerRadius = cornerRedius
            
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0 //borderWidth
        {
        didSet{
            self.layer.borderWidth = borderWidth
            
        }
    }
    @IBInspectable var borderColor:UIColor = UIColor.clear
        {
        didSet{
            self.layer.borderColor = borderColor.cgColor
            
        }
    }
    

   
}
