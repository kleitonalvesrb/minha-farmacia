//
//  Notificacao.swift
//  Farmácia
//
//  Created by Kleiton Batista on 27/10/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class Notificacao: NSObject {
    var id:Int!
    var dataNotificacao:NSDate!
    /**
     Assumirar o valor 0 quando nao houver nenhum tipo de status, ou seja assim que for
     feito o cadastro nao estará em atraso nem em dias
     Assumirar o valor -1 quando o medicamento estiver em atraso
     assumirar o valor 1 quando o medicamento estiver em dias
     */

    var confirmado:Int!
}
