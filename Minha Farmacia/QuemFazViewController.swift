//
//  QuemFazViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 07/11/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class QuemFazViewController:  UIViewController,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var desenvolvedores = [Desenvolvedor]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Desenvolvedores"
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        desenvolvedores.append(Desenvolvedor(idDesenvolvedor: desenvolvedores.count, nomeDesenvolvedor: "Kleiton Batista",fotoString:"kleiton3.jpeg" ,
            url: "https://br.linkedin.com/in/kleiton-batista-987214118", cargoDesenvolvedor: "Desenvolvedor iOS"))

        desenvolvedores.append(Desenvolvedor(idDesenvolvedor: desenvolvedores.count, nomeDesenvolvedor: "Igor Landim", fotoString: "igor.jpeg", url: "https://www.linkedin.com/in/igor-vicentin-738009118", cargoDesenvolvedor: "Requisitos"))
        
        desenvolvedores.append(Desenvolvedor(idDesenvolvedor: desenvolvedores.count, nomeDesenvolvedor: "Douglas Fernandes", fotoString: "douglas.jpeg", url: "https://br.linkedin.com/in/douglas-fernandes-25665012b", cargoDesenvolvedor: "Requisitos"))
//
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1        //return frutaAlfabetica.keys.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return desenvolvedores.count
        
        
    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if indexPath.row == 0{
//            performSegueWithIdentifier("quemFaz", sender: self)
//        }
//    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! QuemFazTableViewCell
        
        cell.nome.text = desenvolvedores[indexPath.row].nome
        cell.btnLinkedin.tag = desenvolvedores[indexPath.row].id
//        cell.fotoPerfil.image = desenvolvedores[indexPath.row].fotoPerfil
        cell.fotoPerfil.image = UIImage(named:desenvolvedores[indexPath.row].fotoPerfil)
        cell.lblCargo.text = desenvolvedores[indexPath.row].cargo
        cell.btnLinkedin.titleLabel?.text = desenvolvedores[indexPath.row].urlLinkedin
        
        return cell
        
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
