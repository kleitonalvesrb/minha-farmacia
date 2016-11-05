//
//  MaisTableViewCell.swift
//  Farmácia
//
//  Created by Kleiton Batista on 05/11/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class MaisTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var lblTItulo: UILabel!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
