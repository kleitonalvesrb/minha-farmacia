//
//  TelaCadastroViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 09/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import Alamofire
class TelaCadastroViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var scroll: UIScrollView!

    
    @IBOutlet weak var fotoPerfil: UIImageView!
    @IBOutlet weak var campoDataNascimento: UITextField!
    @IBOutlet weak var campoSexo: UITextField!
    @IBOutlet weak var campoSenha: UITextField!
    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var campoNome: UITextField!
    @IBOutlet weak var btnEscolherImg: UIButton!
    let arraySexo = ["","Masculino", "Feminino", "Outro", "Prefiro não Informar"]

    var pickerSexo:UIPickerView = UIPickerView()
    
    //url padrao
    let urlPadrao = UrlWS()
    
    
    @IBOutlet weak var imgInfoEmail: UIImageView!
    @IBOutlet weak var btnCadastrar: UIButton!
    var user = Usuario.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCadastrar.layer.cornerRadius = 5
        btnEscolherImg.layer.cornerRadius = 5

        pickerSexo.dataSource = self
        pickerSexo.delegate = self
        campoSexo.inputView = pickerSexo

        campoSexo.delegate = self
        campoNome.delegate = self
        campoEmail.delegate = self
        campoSenha.delegate = self
        campoDataNascimento.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    


        configuracaoNavBar()

    }
    func configuracaoNavBar(){
        self.navigationController?.navigationBar.hidden = false
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationItem.title = "Cadastro"
//        //
//        let button = UIBarButtonItem(title: "Voltar", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(TelaCadastroViewController.goBack))
//        button.image = UIImage(named: "back.png")
//        self.navigationItem.leftBarButtonItem = button
//        self.navigationItem.leftBarButtonItem?.style
    }
    
    override func viewWillAppear(animated: Bool) {
        configuracaoNavBar()
    }

     func goBack(){
        performSegueWithIdentifier("voltarInicio", sender: self)
     }
 

//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*Retirar o teclado*/
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == campoDataNascimento{
            let dataPickerView: UIDatePicker = UIDatePicker()
            dataPickerView.maximumDate = NSDate()
            dataPickerView.locale = NSLocale(localeIdentifier: "pt-BR")
            dataPickerView.datePickerMode = UIDatePickerMode.Date
            
            campoDataNascimento.inputView = dataPickerView
            
            dataPickerView.addTarget(self, action: #selector(TelaCadastroViewController.getValueDatePicker), forControlEvents: UIControlEvents.ValueChanged)
        }else if textField != campoEmail && campoEmail.text! != ""{
//            print(campoEmail.text)
            verificaDisponibilidadeEmail(campoEmail.text!)
           
        }
    }/*
        verifica a disponibilidade do email inserido, caso o email já tenha sido cadastrado
        uma mensagem de email já utilizado irá aparecer e um x irá aparecer no campo de email
        indicando que o mesmo está indisponivel, caso o email ainda não tenha sido cadastrado
        uma imagem de ok será exibida no campo de email
     */
    func verificaDisponibilidadeEmail(email:String) -> Void{
    
        let emailDic = ["email":email]
        
        Alamofire.request(.GET, urlPadrao.urlConsultaDisponibilidadeEmail(email), parameters: emailDic).responseJSON { (response) in
            if let JSON = response.result.value{
                if JSON.count != nil{
                    if JSON["email"] as! String == ""{
                            self.imgInfoEmail.image = UIImage(named: "ok.png")
                            self.btnCadastrar.userInteractionEnabled = true
                    }else{
                        self.imgInfoEmail.image = UIImage(named: "negado.png")
                        self.btnCadastrar.userInteractionEnabled = false
//                        self.geraAlerta("Email já utilizado", mensagem: "Caso tenha perdido o a senha, vá em recuperar senha na tela de login!")
                    }
                    
                }else{// else de verificacao do retorno diferente de nulo
                    self.geraAlerta("Erro", mensagem: "Ocorreu um erro inesperado, tente novamente mais tarde!")
                }
            }else{// else verificacao da conversao para json
                self.geraAlerta("Erro", mensagem: "Ocorreu um erro inesperado, tente novamente mais tarde!")
                    print(response.timeline.latency)
            }
            
        }//fim requisica
    }//fim da funcao
    /*Pegar o valor da data*/
    func getValueDatePicker(sender: UIDatePicker){
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "pt-BR")
    
        campoDataNascimento.text = dateFormatter.stringFromDate(sender.date)
        
    }
   
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arraySexo.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arraySexo[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        campoSexo.text = arraySexo[row]
    }
    
    /*
        Realiza o cadastro do usuario no servidor
     */
  
    @IBAction func realizarCadastro(sender: AnyObject) {
        let valida = Util()
        
        if valida.isVazio(campoNome.text!) || valida.isVazio(campoEmail.text!) || valida.isVazio(campoSenha.text!) ||
                        valida.isVazio(campoSexo.text!) || valida.isVazio(campoDataNascimento.text!){
            
            
            geraAlerta("Ops", mensagem: "Todos os campos devem ser informados")
            
        }else{
            btnCadastrar.userInteractionEnabled = false
            let url = urlPadrao.urlCadastrarUsuario()
            
            let usuario = ["nome": campoNome.text!,
                           "email": campoEmail.text!,
                           "senha": campoSenha.text!,
                           "sexo":campoSexo.text!,
                           "dataNascimentoString":campoDataNascimento.text!,
                           "foto":user.convertImageToString(fotoPerfil.image!)]
            
            Alamofire.request(.POST, url, parameters: usuario, encoding: .JSON, headers: nil).responseJSON(completionHandler: { (response) in
                print("---->",response.result,"<-----")
                if response.result.isSuccess{
                    
                    
                    //self.geraAlerta("Sucesso", mensagem: "Cadastro realizado com Sucesso")
                 self.populaUsuario()
                 self.performSegueWithIdentifier("cadastroTelaPrincipal", sender: self)
                    

                }else{
                    print(response.description,"<-------")
                    self.geraAlerta("Falha", mensagem: "Não foi possível completar o cadastro, tente novamente mais tarde!")
                }
                self.btnCadastrar.userInteractionEnabled = true 
                print(response.result)
                print(response.result.value)
            })
        
                
            
            
            
//            Alamofire.request(.POST, "http://minhafarmacia-env.us-west-2.elasticbeanstalk.com/cliente/inserir", parameters: usuario, encoding: .JSON, headers: nil).responseJSON(completionHandler: { (response) in
//                
//                if response.result.isSuccess{
//                    
//                    //self.geraAlerta("Sucesso", mensagem: "Cadastro realizado com Sucesso")
//                    self.populaUsuario()
//                    self.performSegueWithIdentifier("cadastroTelaPrincipal", sender: self)
//                    
//                    
//                }else{
//                    print(response.description,"<-------")
//                    self.geraAlerta("Falha", mensagem: "Não foi possível completar o cadastro, tente novamente mais tarde!")
//                }
//                self.btnCadastrar.userInteractionEnabled = true
//                print(response.result)
//                print(response.result.value)
//            })

            
            
            
        }
    }
    func populaUsuario(){
        user.nome = campoNome.text!
        user.email = campoEmail.text!
        user.sexo = campoSexo.text!
        user.idFacebook = ""
        user.foto = fotoPerfil.image!
        
    }
    /*+2*/
   
    @IBAction func escolherFoto(sender: AnyObject) {
        formaDeCapturaFotoPerfil()
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
            self.geraAlerta("Foto de Perfil", mensagem: "Tudo bem, você poderá escolher uma foto mais tarde!")
        }
        alerta.addAction(takeApicture)
        alerta.addAction(chooseAPicutre)
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
        fotoPerfil.image = image
    }
}
