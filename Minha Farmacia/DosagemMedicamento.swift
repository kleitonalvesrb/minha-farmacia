//
//  DosagemMedicamento.swift
//  Farmácia
//
//  Created by Kleiton Batista on 10/09/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class DosagemMedicamento: NSObject {
    var id:Int!
    var tipoMedicamento: String!
    var dosagem: String!
    var intervaloDose: Int!
    var periodoTratamento: Int!
    var quantidade:Double!
    var dataInicio:NSDate!
    /**
        Data e hora da proxima dose
     */
    var proximaDose:NSDate!
    /**
        Array de notificacão para essa dose
     */
    var notificacoes = [Notificacao]()
    

}
