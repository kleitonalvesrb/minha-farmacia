//
//  ItensAjuda.swift
//  Farmácia
//
//  Created by Kleiton Batista on 09/11/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class ItensAjuda: NSObject {
    var descricao:String!
    var imagemString:String!
    var nome:String!
    
    init(desc:String, img:String, nome:String) {
        self.descricao = desc
        self.imagemString = img
        self.nome = nome
    }
}
