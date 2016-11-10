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
    /**
        Método responsavel por verificar se os dados do usuario estao armazenados
     */
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
    /**
        Método responsavel por salvar os dados do usuario
     */
    func salvaUsuario(contexto : NSManagedObjectContext, usuario: Usuario){
        let user = NSEntityDescription.insertNewObjectForEntityForName("Usuario", inManagedObjectContext: contexto)
        let util = Util()
        user.setValue(usuario.nome, forKey: "nome")
        user.setValue(usuario.email, forKey: "email")
        user.setValue(usuario.senha, forKey: "senha")
        user.setValue(usuario.sexo, forKey: "sexo")
        user.setValue(usuario.id, forKey: "id")
        user.setValue(usuario.idFacebook, forKey: "id_facebook")
        user.setValue(usuario.dataNascimento, forKey: "data_nascimento")
        user.setValue(util.convertImageToNSData(usuario.foto), forKey: "foto")
        do{
            try contexto.save()
            print("Salvou o usuario")
        }catch{
           print("De erro")
        }
    }
    /**
        Busca dados do usuario
     */
    func recuperaDadosUsuario(contexto : NSManagedObjectContext) -> Usuario{
        let request = NSFetchRequest(entityName: "Usuario")
        let user = Usuario()
        request.returnsObjectsAsFaults = false
        do{
            let util = Util()
            let results = try contexto.executeFetchRequest(request)
            for result in results as! [NSManagedObject]{
                user.nome = result.valueForKey("nome") as! String
                user.email = result.valueForKey("email") as! String
                user.senha = result.valueForKey("senha") as! String
                user.sexo = result.valueForKey("sexo") as! String
                user.idFacebook = result.valueForKey("id_facebook") as! String
                user.id = result.valueForKey("id") as! Int
                user.dataNascimento = result.valueForKey("data_nascimento") as? NSDate
                user.foto = util.convertNSDataToImage(result.valueForKey("foto") as! NSData)
            }
            
        }catch{
            print("deu ruim ao recuperar dados do usuario")
            return Usuario()
        }
        return user
    }
    func deletaDadosUsuario(contexto: NSManagedObjectContext){
        let request = NSFetchRequest(entityName: "Usuario")
        request.returnsObjectsAsFaults = false
        do{
            let results = try contexto.executeFetchRequest(request)
            for result in results as! [NSManagedObject]{
                contexto.deleteObject(result)
                print("deletando usuario")
            }
        }catch{
            print("Erro ao excluir dados do usuário")
        }
    }
    /*
     //        var user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: contexto)
     //        user.setValue("Arnaldo", forKey: "nome")
     //        user.setValue("Macho", forKey: "sexo")
     //        user.setValue(NSDate(), forKey: "data_nascimento")
     //        do{
     //            try contexto.save()
     //        }catch{
     //            print("error")
     //        }
     
     */
    
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
