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
    /**
        Método responsavel por inserir um notificacao
     
     */
    func salvarNotificacao(contexto:NSManagedObjectContext, notificacao:Notificacao, idMedicamento:Int){
        let notif = NSEntityDescription.insertNewObjectForEntityForName("Notificacao", inManagedObjectContext: contexto)
        notif.setValue(notificacao.dataNotificacao, forKey: "data_notificacao")
        notif.setValue(notificacao.confirmado, forKey: "confirmado")
        notif.setValue(notificacao.id, forKey: "id_notificacao")
        notif.setValue(idMedicamento, forKey: "id_medicamento")
        
        do{
            try contexto.save()
            print("salvou a notificacao")
        }catch{
            print("Houve um erro ao cadastrar uma notificação")
        }
    }
    /**
        método responsavel por buscar todas as notificacoes de um medicamento pelo seu #id#
     */
    func buscaNotificacaoIdMedicamento(contexto:NSManagedObjectContext, idMedicamento:Int) ->Array<Notificacao>{
        let request = NSFetchRequest(entityName: "Notificacao")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id_medicamento = %i", idMedicamento)
        var notificacoes = [Notificacao]()
        do{
            let results = try contexto.executeFetchRequest(request)
            for result in results as! [NSManagedObject]{
                let notificacao = Notificacao()
                    notificacao.dataNotificacao = result.valueForKey("data_notificacao") as? NSDate
                    notificacao.confirmado = result.valueForKey("confirmado") as? Int
                    notificacao.id = result.valueForKey("id_notificacao") as? Int
                    notificacoes.append(notificacao)
            }
        }catch{
            print("erro ao buscar dosagem indicada")
        }
        return notificacoes

    }
}
