//
//  AjudaTableViewCell.swift
//  Farmácia
//
//  Created by Kleiton Batista on 09/11/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class AjudaTableViewCell: UITableViewCell {

    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var nomeItem: UILabel!
    @IBOutlet weak var descItem: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
