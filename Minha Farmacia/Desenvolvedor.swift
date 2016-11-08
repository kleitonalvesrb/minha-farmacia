//
//  Desenvolvedores.swift
//  Farmácia
//
//  Created by Kleiton Batista on 07/11/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class Desenvolvedor: NSObject {
    var id:Int!
    var nome:String!
    var fotoPerfil:String!
    var urlLinkedin:String!
    var cargo:String!
    
    init(idDesenvolvedor:Int, nomeDesenvolvedor:String,fotoString: String,url:String,cargoDesenvolvedor:String) {
        self.id = idDesenvolvedor
        self.nome = nomeDesenvolvedor
        self.fotoPerfil = fotoString
        self.urlLinkedin = url
        self.cargo = cargoDesenvolvedor
    }
}
