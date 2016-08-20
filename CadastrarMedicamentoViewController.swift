//
//  CadastrarMedicamentoViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 17/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class CadastrarMedicamentoViewController: UIViewController {
    var user = Usuario.sharedInstance
    @IBOutlet weak var lbl: UILabel!
    var str:String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl.text = str
        let medica = Medicamento()
        medica.fotoMedicamento = UIImage(named: "remedio.png")
        user.medicamento.append(medica)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

        
        self.navigationItem.title = "Cadastro"
        
        let button = UIBarButtonItem(title: "Voltar", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(TelaCadastroViewController.goBack))
        button.image = UIImage(named: "back.png")
        self.navigationItem.leftBarButtonItem = button
        self.navigationItem.leftBarButtonItem?.style
    }
    func goBack(){
        performSegueWithIdentifier("voltarListaMedicamentos", sender: self)
        

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
