//
//  NotificacaoDAO.swift
//  Farmácia
//
//  Created by Kleiton Batista on 27/10/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import CoreData
class NotificacaoDAO: NSObject {
    func gravaNotificacao(contexto:NSManagedObjectContext, notificacao:Notificacao, idDosagem:Int){
        print("------->\(idDosagem)")
        let notif = NSEntityDescription.insertNewObjectForEntityForName("Notificacao", inManagedObjectContext: contexto)
        notif.setValue(notificacao.id, forKey: "id_notificacao")
        notif.setValue(notificacao.confirmado, forKey: "confirmado")
        notif.setValue(notificacao.dataNotificacao, forKey: "data_notificacao")
        notif.setValue(idDosagem, forKey: "id_dosagem")
        do{
            try contexto.save()
            print("notificacao salva com sucesso")
        }catch{
            print("Erro ao salvar a notificacao")
        }
    }
    
/**
 busca a dosagem pelo id do medicamento
 */
func buscaNotificacaoIdDosagem(contexto: NSManagedObjectContext, idDosagem: Int) -> Array<Notificacao>{
    let request = NSFetchRequest(entityName: "Notificacao")
    request.returnsObjectsAsFaults = false
    request.predicate = NSPredicate(format: "id_dosagem = %i", idDosagem)
    var notificacoes = [Notificacao]()
    do{
        let results = try contexto.executeFetchRequest(request)
        for result in results as! [NSManagedObject]{
            let notificacao = Notificacao()
            notificacao.id = result.valueForKey("id_notificacao") as? Int
            notificacao.confirmado = result.valueForKey("confirmado") as? Int
            notificacao.dataNotificacao = result.valueForKey("data_notificacao") as? NSDate
            notificacoes.append(notificacao)
        }
    }catch{
        print("erro ao buscar dosagem indicada")
    }
    return notificacoes
}


}
