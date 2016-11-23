//
//  DetalhaReceitaViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 21/10/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import Alamofire
class DetalhaReceitaViewController: UIViewController,UIScrollViewDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var imgReceita: UIImageView!
    @IBOutlet weak var descricao: UITextView!
    @IBOutlet weak var dataCadastro: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var receitaDeletar = Receita()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        imgReceita.userInteractionEnabled = true
        imgReceita.addGestureRecognizer(tapGestureRecognizer)
   
        self.scroll.minimumZoomScale = 1.0
        self.scroll.maximumZoomScale = 6.0
        if self.view.frame.height > 665{
            scroll.scrollEnabled = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    func imageTapped(img: AnyObject)
    {
        if VerificarConexao().isConnectedToNetwork(){
            deletarReceita()
        }else{
            self.geraAlerta("Sem conexão!", mensagem: "Para excluir a receita é necessário que tenha conexão, tente novamente mais tarde!")
        }
    }
    
    /**
        Deletar a receita no servidor
     */
    func deletarReceita(){
        let alerta = UIAlertController(title: "Deletar receita", message: "", preferredStyle: .ActionSheet)
        let deletar = UIAlertAction(title: "Deletar", style: .Destructive) { (alert: UIAlertAction!) in
            print("deletar a receita aki ->\(self.receitaDeletar.id)<-")
            Alamofire.request(.DELETE, UrlWS().urlDeletaReceitaId(self.receitaDeletar.id!), parameters: nil, encoding: .JSON, headers: nil).responseJSON(completionHandler: { (response) in
                if response.response?.statusCode == 200 {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }else{
                    self.geraAlerta("Ops!", mensagem: "Não foi possível deletar a receita. Tente novamente mais tarde!")
                }
            })

        }
       
       
        let cancel = UIAlertAction(title: "Cancelar", style: .Cancel) { (alert: UIAlertAction!) in
            //self.geraAlerta("Foto de Perfil", mensagem: "Tudo bem, você poderá escolher uma foto mais tarde!")
        }
   
        alerta.addAction(deletar)
        alerta.addAction(cancel)
        
        self.presentViewController(alerta, animated: true, completion: nil)
    }
    
    func geraAlerta(title: String, mensagem: String){
        let alerta = UIAlertController(title: title, message: mensagem, preferredStyle: .Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }

    override func viewWillAppear(animated: Bool) {
//        let btnTrash =  UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: nil)
        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: nil)
        //        self.navigationItem.rightBarButtonItem.
        let userDefautls = NSUserDefaults.standardUserDefaults()
        var posicaoArray = -1
        if let posicaoArrayMedicamento = userDefautls.stringForKey("posicaoReceita"){
            posicaoArray = Int(posicaoArrayMedicamento)!
        }else{
            print("DEU RUIM")
        }
        let user = Usuario.sharedInstance
        let receita = user.receitas[posicaoArray]
        print("---> id \(receita.id!)")
        receitaDeletar = receita
        imgReceita.image = receita.fotoReceita
        if receita.descricao.characters.count != 0{
            descricao.text = receita.descricao
        }else{
            descricao.text = "Para está receita não foi adicionado nenhuma nota!"
        }
        let util = Util()
        print(util.formataDataPadrao(receita.dataCadastro))
        dataCadastro.text = util.formataPadraoCompleto("\(receita.dataCadastro)")
        
//        
//        self.myUIScrollView.maximumZoomScale = 5.0
//        self.myUIScrollView.minimumZoomScale = 0.5
//        self.myUIScrollView.delegate = self
//        
//        self.myUIScrollView.addSubview(imgReceita)
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return self.imgReceita
    }
//    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//        return imgReceita
//        
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
