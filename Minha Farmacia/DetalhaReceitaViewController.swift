//
//  DetalhaReceitaViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 21/10/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class DetalhaReceitaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var imgReceita: UIImageView!
    @IBOutlet weak var descricao: UITextView!
    @IBOutlet weak var dataCadastro: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        let userDefautls = NSUserDefaults.standardUserDefaults()
        var posicaoArray = -1
        if let posicaoArrayMedicamento = userDefautls.stringForKey("posicaoReceita"){
            posicaoArray = Int(posicaoArrayMedicamento)!
        }else{
            print("DEU RUIM")
        }
        let user = Usuario.sharedInstance
        let receita = user.receitas[posicaoArray]
        imgReceita.image = receita.fotoReceita
        if receita.descricao.characters.count != 0{
            descricao.text = receita.descricao
        }else{
            descricao.text = "Para está receita não foi adicionado nenhuma nota!"
        }
        let util = Util()
        print(util.formataDataPadrao(receita.dataCadastro))
        dataCadastro.text = util.formataPadraoCompleto("\(receita.dataCadastro)")
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
