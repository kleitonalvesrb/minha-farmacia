//
//  TrocaViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 15/10/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class TrocaViewController: UIViewController {
    var tipoDeMsg = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // performSegueWithIdentifier("tabbar", sender: self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        if tipoDeMsg == 1{
            geraAlerta("Sucesso", mensagem: "Receita Salva com sucesso")
        }else{
            geraAlerta("Sucesso", mensagem: "Medicamento salvo com sucesso")
        }
    }
    func redirecionar(){
        performSegueWithIdentifier("tabbar", sender: self)

    }
    func geraAlerta(title: String, mensagem: String){
        let alerta = UIAlertController(title: title, message: mensagem, preferredStyle: .Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
            self.redirecionar()
        }))
        self.presentViewController(alerta, animated: false, completion: nil)
        
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
