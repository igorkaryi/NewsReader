//
//  UkraineViewCell.swift
//  NewsReader
//
//  Created by Igor Karyi on 11/9/17.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

import UIKit

class UkraineViewCell: UITableViewCell {
    
    @IBOutlet weak var imgUkraineView: UIImageView!
    @IBOutlet weak var descUkraineLabel: UILabel!
    @IBOutlet weak var titleUkraineLabel: UILabel!
    @IBOutlet var dateUkraineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
