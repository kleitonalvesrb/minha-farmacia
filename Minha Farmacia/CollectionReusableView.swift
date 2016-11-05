//
//  CollectionReusableView.swift
//  Farmácia
//
//  Created by Kleiton Batista on 05/11/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var lblTitulo: UILabel!
    
    override func prepareForReuse() {
        lblTitulo.text = ""
    }
}
