//
//  DetalhamentoMedicamentoViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 23/09/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class DetalhamentoMedicamentoViewController: UIViewController {

    @IBOutlet weak var imgMedicamento: UIImageView!
    @IBOutlet weak var campoDataInicioTratamento: UITextField!
    @IBOutlet weak var campoIntervaloEntreDose: UITextField!
    @IBOutlet weak var campoDosagem: UITextField!
    @IBOutlet weak var campoDuracaoTratamento: UITextField!
    
    var medicamento:Medicamento = Medicamento()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        campoDosagem.text = String(medicamento.dosagemMedicamento.quantidade) + tipoMedicamentoApresentacaoDosagem(medicamento.dosagemMedicamento.tipoMedicamento)
        campoIntervaloEntreDose.text = String(medicamento.dosagemMedicamento.intervaloDose) + " Hora(s)"
        campoDuracaoTratamento.text = String(medicamento.dosagemMedicamento.periodoTratamento) + " Dia(s)"
        imgMedicamento.image = medicamento.fotoMedicamento
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tipoMedicamentoApresentacaoDosagem(tipo: String) -> String{
        if medicamento.dosagemMedicamento.tipoMedicamento == "Xarope"{
            return " ML"
        }else if medicamento.dosagemMedicamento.tipoMedicamento == "Gotas"{
            return " Gotas"
        }else{
            return " Comprimido"
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
