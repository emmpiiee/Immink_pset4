//
//  CustomCell.swift
//  Immink-pset4
//
//  Created by Emma Immink on 11-05-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var Title: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
