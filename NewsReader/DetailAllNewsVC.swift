//
//  DetailAllNewsVC.swift
//  NewsReader
//
//  Created by Igor Karyi on 13.11.2017.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

import UIKit

class DetailAllNewsVC: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artImage: UIImageView!
    @IBOutlet var descrTextView: UITextView!
    @IBOutlet var dateLabel: UILabel!
    
    var contentText: String!
    var contentImage: UIImage!
    var contentDescr: String!
    var contentDate: String!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if contentText != nil {
            self.titleLabel.text = contentText!
        }
        
        if contentImage != nil {
            self.artImage.image = contentImage!
        }
        
        if contentDescr != nil {
            self.descrTextView.text = contentDescr!
        }
        
        if contentDate != nil {
            self.dateLabel.text = contentDate!
        }
        
    }
}
