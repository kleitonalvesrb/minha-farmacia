//
//  TableViewCellPerfil.swift
//  Farmácia
//
//  Created by Kleiton Batista on 16/10/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class TableViewCellPerfil: UITableViewCell {

    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelConteudo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
