//
//  MedicamentoCollectionViewCell.swift
//  Farmácia
//
//  Created by Kleiton Batista on 17/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class MedicamentoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var labelFundo: UILabel!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var imgIndicativaPontual: UIImageView!
    @IBOutlet weak var imgIndicativaAtraso: UIImageView!
    
    override func prepareForReuse() {
        imgIndicativaAtraso.image = nil
        img.image = UIImage(named: "Medications")
        imgIndicativaPontual.image = nil
    }
}
