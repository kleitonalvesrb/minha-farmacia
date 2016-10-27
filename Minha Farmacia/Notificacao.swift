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
        Assumirá o #valor 0# assim que a notificacao for criada
        indica que nao esta atrasado nem em dias
        Assumirá o #valor 1# quando estive tomado na hora certa
        Assumirá o #valo -1# quando estiver em atraso
     */
    var confirmado:Int!
}
