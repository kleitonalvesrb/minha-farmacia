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
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.hidden = true
        
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
        }else if tipoDeMsg ==  3{
            indicator.hidden = false
            indicator.startAnimating()
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), (1 * Int64(NSEC_PER_SEC)) / 2)
            dispatch_after(time, dispatch_get_main_queue()) {
                self.indicator.stopAnimating()
                self.indicator.hidden = true
                self.redirecionar()
            }

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
