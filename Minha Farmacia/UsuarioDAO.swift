//
//  UsuarioDAO.swift
//  Farmácia
//
//  Created by Kleiton Batista on 21/10/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import CoreData
class UsuarioDAO: NSObject {
    func verificaUserLogado(contexto : NSManagedObjectContext) -> Bool{
        let request = NSFetchRequest(entityName: "Usuario")
        request.returnsObjectsAsFaults = false
        do{
            let results = try contexto.executeFetchRequest(request)
            return results.count > 0
            
        }catch{
            print("Error ao verificar se contem usuario")
        }
        return false;
    }
    
    /*let request = NSFetchRequest(entityName: "User")
    request.returnsObjectsAsFaults = false
    request.predicate = NSPredicate(format: "nome = %@", "Kleiton")
    do{
    let results = try contexto.executeFetchRequest(request)
    if results.count == 0 {
    print("Vazio")
    }else{
    for result in results as! [NSManagedObject]{
    print("-------")
    print(result.valueForKey("nome"))
    print(result.valueForKey("data_nascimento"))
    }            }
    }catch{
    print("error")
    }*/

}
