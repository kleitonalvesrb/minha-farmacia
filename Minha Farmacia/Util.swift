//
//  Util.swift
//  Farmácia
//
//  Created by Kleiton Batista on 30/07/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4
import CoreData
class Util: NSObject {
    
    func isVazio(txt : String) -> Bool{
            return txt == ""
    }
    /**
     Inserir dados do usuario no banco de dados
     */
    func salvaUsuarioCoreData(usuario: Usuario){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let novoUsuario = NSEntityDescription.insertNewObjectForEntityForName("Usuario", inManagedObjectContext: context)
        
        novoUsuario.setValue(usuario.nome, forKey: "nome")
        novoUsuario.setValue(usuario.senha, forKey:"senha")
        novoUsuario.setValue(usuario.email, forKey:"email")
        novoUsuario.setValue(usuario.sexo, forKey: "sexo")
        novoUsuario.setValue("01/03/1995", forKey: "dataNascimento")
        novoUsuario.setValue(usuario.convertImageToString(usuario.foto), forKey: "fotoPerfil")
        novoUsuario.setValue(1, forKey: "id")
        do{
            try context.save()
        }catch{
            print("erro ao salvar")
        }
        
        
    }
    func buscarCoreData() -> Usuario{
        let user:Usuario = Usuario()
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        //busca quem tem o nome de kleiton
        request.predicate = NSPredicate(format: "userName = %@", "Kleiton")
        
        let busca = NSFetchRequest(entityName: "Usuario")
        do{
            
            let resultado = try context.executeFetchRequest(busca)
            if resultado.count > 0{
                for result in resultado as! [NSManagedObject]{
                    user.nome = result.valueForKey("nome") as! String
                    user.email = result.valueForKey("email") as! String
                    user.senha = result.valueForKey("senha") as! String
                    user.foto = user.convertStringToImage(result.valueForKey("fotoPerfil") as! String)
                    user.sexo = result.valueForKey("sexo") as! String
                    //user.idFacebook = result.valueForKey("id") as! String
                }
            }
        }catch{
            
        }
        return user
    }

}
