//
//  Util.swift
//  Farmácia
//
//  Created by Kleiton Batista on 30/07/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class Util: NSObject {
    
    func isVazio(txt : String) -> Bool{
            return txt == ""
    }
    func valida(email:String, senha:String ) -> String{
        return "\(email) e \(senha)"
    }
    
    
}
