//
//  WorldTableViewCell.swift
//  NewsReader
//
//  Created by Igor Karyi on 11/9/17.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

import UIKit

class WorldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgWorldView: UIImageView!
    @IBOutlet weak var descWorldLabel: UILabel!
    @IBOutlet weak var titleWorldLabel: UILabel!
    @IBOutlet var dateWorldLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
