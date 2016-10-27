//
//  Medicamento.swift
//  Farmácia
//
//  Created by Kleiton Batista on 20/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class Medicamento: NSObject {
    var id:Int!
    var fotoMedicamento: UIImage!
    var codBarras:String!
    var nome:String!
    var principioAtivo:String!
    var apresentacao:String!
    var laboratorio:String!
    var classeTerapeutica:String!
    var dosagemMedicamento: DosagemMedicamento!
    var notificacoes = [Notificacao]()
    static let medicamentoSharedInstance = Medicamento()

    
}
