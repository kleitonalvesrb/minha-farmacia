//
//  CadastroReceitaViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 18/10/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import Alamofire
class CadastroReceitaViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var scroll: UIScrollView!
    var acrescimo:CGFloat!
    @IBOutlet weak var constraintFundo: NSLayoutConstraint!

//    @IBOutlet weak var btnEscolherFoto: UIButton!
    @IBOutlet weak var imgReceita: UIImageView!
    @IBOutlet weak var campoDescricao: UITextView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnSalvar: UIButton!
    var setFoto = false
    var user = Usuario.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let util = Util()
        util.configuraLabelInformacao(lblInfo, comInvisibilidade: true, comIndicador: activity, comInvisibilidade: true, comAnimacao: false)
        
        btnSalvar.layer.cornerRadius = 5
//        btnEscolherFoto.layer.cornerRadius = 5
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        imgReceita.userInteractionEnabled = true
        imgReceita.addGestureRecognizer(tapGestureRecognizer)
       
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
        
       

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CadastroReceitaViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CadastroReceitaViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    /*Retirar o teclado*/
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func adjustingHeight(show:Bool, notification:NSNotification) {
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        // 3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        // 4
        let changeInHeight = (CGRectGetHeight(keyboardFrame) + 40) * (show ? 1 : -1)
        acrescimo = (CGRectGetHeight(keyboardFrame)) * (show ? 1 : -1)
        //5
        UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
            self.constraintFundo.constant += changeInHeight
        })
        
    }
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(true, notification: notification)
        
        scroll.setContentOffset(CGPoint(x: 0, y: acrescimo - 40), animated: true)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(false, notification: notification)
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    /**
        Acao do botao para escolher a foto
     */
    func imageTapped(img: AnyObject)
    {
        formaDeCapturaFotoPerfil()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CadastroReceitaViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CadastroReceitaViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)

    }
//    @IBAction func escolherFoto(sender: AnyObject) {
//        formaDeCapturaFotoPerfil()
//    }
    /**
        acao do botao que ira salvar os dados
     */
    @IBAction func salvar(sender: AnyObject) {
        let util = Util()
        if setFoto{
            util.configuraLabelInformacao(lblInfo, comInvisibilidade: false, comIndicador: activity, comInvisibilidade: false, comAnimacao: true)
            scroll.userInteractionEnabled = false
            btnSalvar.userInteractionEnabled = false
            salvarReceitaServidor()
        }else{
            geraAlerta("Ops", mensagem: "Você precisa cadastrar uma foto \(NSDate())")
        }
        
    }
    /**
        O método é responsavel por cadasrar a receita no servidor
     */
    func salvarReceitaServidor(){
        let url = UrlWS()
        let util = Util()
        Alamofire.request(.PUT, url.urlInsereReceitaUsuario(user.email), parameters: criaDicReceita() as? [String : AnyObject], encoding: .JSON, headers: nil).responseJSON{(response) in
            if response.response?.statusCode == 200{
                self.redireciona()
            }
            util.configuraLabelInformacao(self.lblInfo, comInvisibilidade: true, comIndicador: self.activity, comInvisibilidade: true, comAnimacao: false)
            self.scroll.userInteractionEnabled = true
            self.btnSalvar.userInteractionEnabled = true

        }
    }
    func redireciona(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("nextView") as! TrocaViewController
        nextViewController.tipoDeMsg = 1
        self.presentViewController(nextViewController, animated:false, completion:nil)

        
    }
    func criaDicReceita() -> AnyObject{
        
        let dataString = "\(NSDate())"
        let util = Util()
        let dicReceita = ["dataCadastroReceitaString":dataString,
                          "fotoReceitaString":util.convertImageToString(imgReceita.image!),
                          "descricao":campoDescricao.text!]
        
        return dicReceita
    }
    
    func geraAlerta(title: String, mensagem: String){
        let alerta = UIAlertController(title: title, message: mensagem, preferredStyle: .Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }

    
    
    func formaDeCapturaFotoPerfil(){
        let alerta = UIAlertController(title: "Escolher foto de Perfil", message: "", preferredStyle: .ActionSheet)
        let takeApicture = UIAlertAction(title: "Câmera", style: .Default) { (alert: UIAlertAction!) in
            self.definirFoto(true)
        }
        let chooseAPicutre = UIAlertAction(title: "Galeria", style: .Default) { (alert: UIAlertAction!) in
            self.definirFoto(false)
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .Cancel) { (alert: UIAlertAction!) in
        }
        alerta.addAction(takeApicture)
        alerta.addAction(chooseAPicutre)
        alerta.addAction(cancel)
        
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }
    
    func definirFoto(camera : Bool){
        let img = UIImagePickerController()
        img.delegate = self
        /*Define a forma que a foto será selecionada, camera ou galeria*/
        if camera {
            img.sourceType = UIImagePickerControllerSourceType.Camera
        }else{
            img.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        img.allowsEditing = false
        self.presentViewController(img, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        imgReceita.image = image
        setFoto = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CadastroReceitaViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CadastroReceitaViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)

    }

    /*
     /*Verifica se é o tamanho de tela do Iphone 5 / 5s / SE*/
     if self.view.frame.height == 568{
     scroll.scrollEnabled = true // habilita o scroll
     scroll.contentSize = CGSizeMake(0, self.view.frame.height + 90) // coloca o scroll do tamanho da view + 90
     
     if senha == textField{
     scroll.scrollEnabled = true
     scroll.setContentOffset(CGPointMake(0, 90), animated: true) // se clicar na senha sobe a view
     }
     }else if self.view.frame.height == 480{ /*Verificar se a tela é do iphone 4*/
     scroll.scrollEnabled = true
     scroll.contentSize = CGSizeMake(0, self.view.frame.height + 150)
     
     if senha == textField{
     scroll.setContentOffset(CGPointMake(0, 150), animated: true)
     }
     }*/

}
