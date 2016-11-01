//
//  DescricaoTecViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 31/10/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import CoreData
class DescricaoTecViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imgMedicamento: UIImageView!
    var arrayTitulos = [String]()
    var arrayConteudo = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Descrição"
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexto: NSManagedObjectContext = appDel.managedObjectContext
        let id = buscaMedicamento()
        print("---------> \(id) <-------")
        let medic = MedicamentoDAO().buscaMedicamentoId(contexto, id: id)
        criaArrayTitulos()
        criaArrayConteudo(medic)
        imgMedicamento.image = medic.fotoMedicamento
    
    }
    
    /**
     Busca o medicamento com base no medicamento selecionado na tela anterior
     */
    func buscaMedicamento()->Int{
        let userDefautls = NSUserDefaults.standardUserDefaults()
        var posicaoArray = -1
        if let posicaoArrayMedicamento = userDefautls.stringForKey("posicaoMedicamentoDescTec"){
            posicaoArray = Int(posicaoArrayMedicamento)!
        }else{
            print("DEU RUIM")
        }
        return posicaoArray
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    func criaArrayTitulos(){
        arrayTitulos.append("Código de Barras")
        arrayTitulos.append("Nome")
        arrayTitulos.append("Apresentação")
        arrayTitulos.append("Classe terapêutica")
        arrayTitulos.append("Princípio ativo")
        arrayTitulos.append("Laboratório")
    }
    func criaArrayConteudo(medic: Medicamento){
        arrayConteudo.append(medic.codBarras)
        arrayConteudo.append(medic.nome)
        arrayConteudo.append(medic.apresentacao)
        arrayConteudo.append(medic.classeTerapeutica)
        arrayConteudo.append(medic.principioAtivo)
        arrayConteudo.append(medic.laboratorio)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! DescricaoTecViewCell
        cell.lblTitulo.text = arrayTitulos[indexPath.row]
        cell.lblConteudo.text = arrayConteudo[indexPath.row]
        return cell
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objectArray[section].objects.count
        return arrayTitulos.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return objectArray.count
        return 1
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return objectArray[section].sectionName
        return "Descrição Técnica"
    }
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let title = UILabel()
        title.font = UIFont(name: "Futura", size: 18)!
        title.textColor = UIColor(red: 53.0/255.0, green: 168.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font=title.font
        header.textLabel?.textColor=title.textColor
        header.textLabel?.center.x = self.view.frame.width
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showAlert("", msg: arrayConteudo[indexPath.row], titleBtn: "OK")
    }
    func showAlert(title: String, msg: String, titleBtn: String){
        let alerta = UIAlertController(title: title, message:msg, preferredStyle: .Alert)
        alerta.addAction(UIAlertAction(title: titleBtn, style: .Default, handler: { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alerta, animated: true, completion: nil)
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
