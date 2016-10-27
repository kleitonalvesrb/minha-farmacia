//
//  MedicamentoDAO.swift
//  Farmácia
//
//  Created by Kleiton Batista on 24/10/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import CoreData
class MedicamentoDAO: NSObject {
    /**
     Método responsável por armazenar os dados do medicamento do usuario no banco de dados
     */
    func gravarMedicamento(contexto: NSManagedObjectContext,medicamento: Medicamento, sicronizado: Bool){
        let medic = NSEntityDescription.insertNewObjectForEntityForName("Medicamento", inManagedObjectContext: contexto)
        let util = Util()
        let dosagemDao = DosagemDAO()
        medic.setValue(medicamento.id, forKey: "id_medicamento")
        medic.setValue(medicamento.apresentacao, forKey: "apresentacao")
        medic.setValue(medicamento.classeTerapeutica, forKey: "classe_terapeutica")
        medic.setValue(medicamento.codBarras, forKey: "cod_barras")
        medic.setValue(medicamento.laboratorio, forKey: "laboratorio")
        medic.setValue(medicamento.nome, forKey: "nome")
        medic.setValue(medicamento.principioAtivo, forKey: "principio_ativo")
        medic.setValue(sicronizado, forKey: "sicronizado")
        
        medic.setValue(util.convertImageToNSData(medicamento.fotoMedicamento), forKey: "foto_medicamento")
        
        for n in medicamento.notificacoes{
            NotificacaoDAO().salvarNotificacao(contexto, notificacao: n, idMedicamento: medicamento.id)
        }
        
        do{
            try contexto.save()
            dosagemDao.gravaDadoDosagemMedicamento(contexto, dosagem: medicamento.dosagemMedicamento, idMedicamento: medicamento.id)
            print("medicamento salvo")
        }catch{
            print("Erro ao salvar o medicamento")
        }
    }
    /**
     Verifica se existe medicamentos na base
     */
    func verificaExistenciaMedicamento(contexto: NSManagedObjectContext) -> Bool{
        let request = NSFetchRequest(entityName: "Medicamento")
        request.returnsObjectsAsFaults = false
        do{
            let results = try contexto.executeFetchRequest(request)
            return results.count != 0
        }catch{
            print("deu ruim")
            return false
        }
    }
    /**
     método responsavel por buscar todos os medicamentos que estao salvos no banco
     */
    func recuperarMedicamentos(contexto: NSManagedObjectContext) ->Array<Medicamento>{
        let request = NSFetchRequest(entityName: "Medicamento")
        request.returnsObjectsAsFaults = false
        var arrayMedicamento = [Medicamento]()
        let util = Util()
        let dosagemDao = DosagemDAO()
        do{
            let results = try contexto.executeFetchRequest(request)
            for result in results as! [NSManagedObject]{
                let medicamento = Medicamento()
                medicamento.id = result.valueForKey("id_medicamento") as! Int
                medicamento.apresentacao = result.valueForKey("apresentacao") as? String
                medicamento.classeTerapeutica = result.valueForKey("classe_terapeutica") as? String
                medicamento.codBarras = result.valueForKey("cod_barras") as? String
                medicamento.laboratorio = result.valueForKey("laboratorio") as? String
                medicamento.nome = result.valueForKey("nome") as? String
                medicamento.principioAtivo = result.valueForKey("principio_ativo") as? String
                medicamento.fotoMedicamento = util.convertNSDataToImage(result.valueForKey("foto_medicamento") as! NSData)
                medicamento.dosagemMedicamento = dosagemDao.buscaDosagemMedicamento(contexto, idMedicamento: medicamento.id)
                medicamento.notificacoes = NotificacaoDAO().buscaNotificacaoIdMedicamento(contexto, idMedicamento: medicamento.id)
                arrayMedicamento.append(medicamento)
            }
            print("Leus os medicamentos")
        }catch{
            print("Erro ao buscar os medicamentos")
        }
        return arrayMedicamento
    }
    /**
        verifica se existe o medicamento com o id informado
     */
    func verificaMedicamentoId(contexto: NSManagedObjectContext, id : Int) -> Bool{
        let request = NSFetchRequest(entityName: "Medicamento")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id_medicamento = %i", id)
        do {
            let results = try contexto.executeFetchRequest(request)
            return results.count != 0
        }catch{
                print("erro ao verificar")
        }
        return false
    }
    /**
        busca os medicamentos que nao foram sicronizados
     */
    func buscaMedicamentoNaoSicronizados(contexto: NSManagedObjectContext) -> Array<Medicamento>{
        let request = NSFetchRequest(entityName: "Medicamento")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "sicronizado = %@", NSNumber(bool: false))
        
        var arrayMedicamento = [Medicamento]()
        let util = Util()
        let dosagemDao = DosagemDAO()
        
        do{
            let results  = try contexto.executeFetchRequest(request)
            for result in results as! [NSManagedObject]{
                let medicamento = Medicamento()
                medicamento.id = result.valueForKey("id_medicamento") as! Int
                medicamento.apresentacao = result.valueForKey("apresentacao") as? String
                medicamento.classeTerapeutica = result.valueForKey("classe_terapeutica") as? String
                medicamento.codBarras = result.valueForKey("cod_barras") as? String
                medicamento.laboratorio = result.valueForKey("laboratorio") as? String
                medicamento.nome = result.valueForKey("nome") as? String
                medicamento.principioAtivo = result.valueForKey("principio_ativo") as? String
                medicamento.fotoMedicamento = util.convertNSDataToImage(result.valueForKey("foto_medicamento") as! NSData)
                medicamento.dosagemMedicamento = dosagemDao.buscaDosagemMedicamento(contexto, idMedicamento: medicamento.id)
                arrayMedicamento.append(medicamento)
            }
        }catch{
            print("erro ao buscar medicamentos nao sicronizados")
        }
        return arrayMedicamento
    }
    func atualizaMedicamentoSicronizado(contexto:NSManagedObjectContext){
        let request = NSFetchRequest(entityName: "Medicamento")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "sicronizado = %@", NSNumber(bool: false))
        
                do{
            let results  = try contexto.executeFetchRequest(request)
            for result in results as! [NSManagedObject]{
                result.setValue(true, forKey: "sicronizado")
                do{
                    try contexto.save()
                    print("atualizou")
                }catch{
                    print("erro")
                }
            }
        }catch{
            print("erro ao atualizar")
        }
        
    }
}
