//
//  QuemFazTableViewCell.swift
//  Farmácia
//
//  Created by Kleiton Batista on 07/11/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class QuemFazTableViewCell: UITableViewCell {

    @IBOutlet weak var fotoPerfil: UIImageView!
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var btnLinkedin: UIButton!
    @IBOutlet weak var lblCargo: UILabel!
    @IBAction func acaoBtn(sender: AnyObject) {
        
//        let url = NSURL(string: "https://google.com")!
        
        let url = NSURL(string: (btnLinkedin.titleLabel?.text!)!)!
        UIApplication.sharedApplication().openURL(url)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
