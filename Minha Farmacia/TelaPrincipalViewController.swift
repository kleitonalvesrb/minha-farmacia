//
//  TelaPrincipalViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 05/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class TelaPrincipalViewController: UIViewController {

    @IBOutlet weak var ImageUsuario: UIImageView!
    @IBOutlet weak var nomeUsuario: UILabel!
    @IBOutlet weak var emailUsuario: UILabel!
    @IBOutlet weak var sexoUsuario: UILabel!
    @IBOutlet weak var idadeUsuario: UILabel!
    @IBOutlet weak var idFacebook: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
