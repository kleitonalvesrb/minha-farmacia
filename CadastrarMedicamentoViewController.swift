//
//  CadastrarMedicamentoViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 17/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class CadastrarMedicamentoViewController: UIViewController {

    @IBOutlet weak var lbl: UILabel!
    var str:String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl.text = str

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
