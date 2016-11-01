//
//  DescricaoTecViewCell.swift
//  Farmácia
//
//  Created by Kleiton Batista on 31/10/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class DescricaoTecViewCell: UITableViewCell {

    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblConteudo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
