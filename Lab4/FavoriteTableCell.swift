//
//  FavoriteTableCell.swift
//  Lab4
//
//  Created by Reis Sirdas on 3/8/17.
//  Copyright © 2017 sirdas. All rights reserved.
//

import UIKit

class FavoriteTableCell: UITableViewCell {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
