//
//  DosagemDAO.swift
//  Farmácia
//
//  Created by Kleiton Batista on 24/10/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import CoreData
class DosagemDAO: NSObject {
    /**
        Método responsavel por inserir a dosagem do medicamento no banco
        recebe a dosagem e o id do medicamento
     
     */
    func gravaDadoDosagemMedicamento(contexto : NSManagedObjectContext, dosagem : DosagemMedicamento, idMedicamento: Int){
        let dos = NSEntityDescription.insertNewObjectForEntityForName("Dosagem", inManagedObjectContext: contexto)
        dos.setValue(idMedicamento, forKey: "id_remedio_dosagem")
        dos.setValue(dosagem.tipoMedicamento, forKey: "tipo_medicamento")
        dos.setValue(dosagem.dosagem, forKey: "dosagem")
        dos.setValue(dosagem.intervaloDose, forKey: "intervalo_dose")
        dos.setValue(dosagem.periodoTratamento, forKey: "periodo_tratamento")
        dos.setValue(dosagem.quantidade, forKey: "quantidade")
        dos.setValue(dosagem.dataInicio, forKey: "data_inicio")
        dos.setValue(dosagem.id, forKey: "id_dosagem")
        do{
            try contexto.save()
        }catch{
            print("erro ao salvar a dosagem")
        }
    }
    /**
        busca a dosagem pelo id do medicamento
     */
    func buscaDosagemMedicamento(contexto: NSManagedObjectContext, idMedicamento: Int) -> DosagemMedicamento{
        let request = NSFetchRequest(entityName: "Dosagem")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id_remedio_dosagem = %i", idMedicamento)
        let dosagem = DosagemMedicamento()
        do{
            let results = try contexto.executeFetchRequest(request)
            for result in results as! [NSManagedObject]{
                dosagem.tipoMedicamento = result.valueForKey("tipo_medicamento") as? String
                dosagem.dosagem = result.valueForKey("dosagem") as? String
                dosagem.intervaloDose = result.valueForKey("intervalo_dose") as? Int
                dosagem.periodoTratamento = result.valueForKey("periodo_tratamento") as? Int
                dosagem.quantidade = result.valueForKey("quantidade") as? Double
                dosagem.dataInicio = result.valueForKey("data_inicio") as? NSDate
                dosagem.id = result.valueForKey("id_dosagem") as? Int
             }
        }catch{
            print("erro ao buscar dosagem indicada")
        }
        return dosagem
    }
    /**
     verifica se existe o medicamento com o id informado
     */
    func verificaDosagemId(contexto: NSManagedObjectContext, id : Int) -> Bool{
        let request = NSFetchRequest(entityName: "Dosagem")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id_dosagem = %i", id)
        do {
            let results = try contexto.executeFetchRequest(request)
            return results.count != 0
        }catch{
            print("erro ao verificar")
        }
        return false
    }

    
}
