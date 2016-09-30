//
//  TelaPrincipalViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 05/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class TelaPrincipalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var btnMedicamento: UIBarButtonItem!
    @IBOutlet weak var ImageUsuario: UIImageView!
    @IBOutlet weak var tableView: UITableView!
 
    var user:Usuario!
    var titulos = [String]()
    var conteudo = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Usuario.sharedInstance
        ImageUsuario.image = user.foto
        
        populaArrayTitulos()
        populaConteudo()
    }

    func populaArrayTitulos(){
        titulos.append("Nome")
        titulos.append("Email")
        titulos.append("Sexo")
        titulos.append("Idade")
        titulos.append("Facebook")
    }
    func populaConteudo(){
     conteudo.append(user.nome)
     conteudo.append(user.email)
     conteudo.append(user.sexo)
     conteudo.append("idade")
     conteudo.append("facebook")
    }
    
    override func viewDidAppear(animated: Bool) {
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.translucent = false
        
        
        
        navigationBarAppearace.barTintColor = UIColor(red: 53.0/255.0, green: 168.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.title = "Perfil"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1        //return frutaAlfabetica.keys.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titulos.count
        
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PerfilTableViewCell
        //cell.textLabel?.text = self.items[indexPath.section][indexPath.row]
        cell.labelConteudo.text = conteudo[indexPath.row]
        cell.labelTitulo.text = titulos[indexPath.row]
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if titulos[indexPath.row].lowercaseString == "Nome".lowercaseString{
            let alerta = UIAlertController(title: "Informe o novo nome", message: nil, preferredStyle: .Alert)
            let trocaNome = UIAlertAction(title: "Salvar", style: .Default, handler: { (_) in
                let nome = alerta.textFields![0] as UITextField
                if nome.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
                    self.conteudo[indexPath.row] = nome.text!
                    self.tableView.reloadData()
                }else{
                    print("nao pode trocar")
                }

            })
            
            
            alerta.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Nome"
                textField.keyboardType = .EmailAddress
            }
            let cancelAction = UIAlertAction(title: "Cancelar", style: .Destructive) { (_) in }
            alerta.addAction(trocaNome)
            alerta.addAction(cancelAction)
            
            self.presentViewController(alerta, animated: true, completion: nil)
            
        }else if titulos[indexPath.row].lowercaseString == "Sexo".lowercaseString{
            print("alterar Sexo")
        }
    }
//    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PostCell
//    imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) in
//    if let imgDown = UIImage(data: data!){
//    cell.postedImage.image = imgDown
//    
//    }
//    }
//    
//    //cell.postedImage.image = UIImage(named: "camera (2).png")
//    cell.message.text = messages[indexPath.row]
//    cell.userName.text = userNames[indexPath.row]
//    // Configure the cell...
//    
//    return cell
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//       // return self.section [section ]
//        
//    }


}
