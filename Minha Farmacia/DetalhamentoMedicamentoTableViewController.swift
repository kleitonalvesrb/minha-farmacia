//
//  DetalhamentoMedicamentoTableViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 24/09/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class DetalhamentoMedicamentoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    let frutas = ["Abacate","Amora","Banana","Beterraba","Carambola","Ameixa","Uva","Roma","Rucula","Pitanga","Manga","Caja","Morango","Melancia","Melao","Abobora"]
//    var frutaAlfabetica = [String:[String]]()
//  
//    var dados = [String:[String]]()

    var medicamento = Medicamento.medicamentoSharedInstance
    var items = [[String]]()
    @IBOutlet weak var imgMedicamento: UIImageView!
    let section = ["Dados Medicamento", "Medicamentos em Atraso"]
    
    // campoDosagem.text = String(medicamento.dosagemMedicamento.quantidade) + tipoMedicamentoApresentacaoDosagem(medicamento.dosagemMedicamento.tipoMedicamento)
//    campoIntervaloEntreDose.text = String(medicamento.dosagemMedicamento.intervaloDose) + " Hora(s)"
//    campoDuracaoTratamento.text = String(medicamento.dosagemMedicamento.periodoTratamento) + " Dia(s)"
//    imgMedicamento.image = medicamento.fotoMedicamento
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        barraNavegacao()
        
        
        
       
    }
    override func viewWillAppear(animated: Bool) {
        let userDefautls = NSUserDefaults.standardUserDefaults()
        var posicaoArray = -1
        if let posicaoArrayMedicamento = userDefautls.stringForKey("posicaoMedicamento"){
           posicaoArray = Int(posicaoArrayMedicamento)!
        }else{
            print("DEU RUIM")
        }
        let user = Usuario.sharedInstance
        medicamento = user.medicamento[posicaoArray]
        print("===========================")
        print(medicamento.dosagemMedicamento.intervaloDose,"  Intervalo")
        let arrayAtrasos = ["23/10/2016 ás 12:30",
                            "24/10/2014 ás 00:30",
                            "24/10/2016 ás 12:30",
                            "23/10/2016 ás 12:30",
                            "24/10/2014 ás 00:30",
                            "24/10/2016 ás 12:30",
                            "23/10/2016 ás 12:30",
                            "24/10/2014 ás 00:30",
                            "24/10/2016 ás 12:30"]
        
        imgMedicamento.image = medicamento.fotoMedicamento
        items = [["Inicio em :     23/10/2016 13:30",
            "Intervalo:      \(medicamento.dosagemMedicamento.intervaloDose):00 Horas",
            "Período:        \(medicamento.dosagemMedicamento.periodoTratamento) Dias",
            "Dosagem:       \(medicamento.dosagemMedicamento.quantidade) \(tipoMedicamentoApresentacaoDosagem(medicamento.dosagemMedicamento.tipoMedicamento))"]]
        
        items.append(arrayAtrasos)

    }
//    func barraNavegacao(){
//        self.navigationController?.navigationBar.hidden = false
//        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
//        
//        
//        self.navigationItem.title = "Dados Medicamento"
//        
//        let button = UIBarButtonItem(title:"", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(CadastrarMedicamentoViewController.goBack))
//        
//        button.image = UIImage(named: "arrow-back2.png")
//        self.navigationItem.leftBarButtonItem = button
//        self.navigationItem.leftBarButtonItem?.style
//    }
  


    func goBack(){
        performSegueWithIdentifier("dadosGoToMedicamentos", sender: self)
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.section.count        //return frutaAlfabetica.keys.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items [section ].count

        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.items[indexPath.section][indexPath.row]
        
        return cell
    
    }
     func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.section [section ]
        
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
