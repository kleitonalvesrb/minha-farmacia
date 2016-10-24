//
//  TesteViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 30/07/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import ParseFacebookUtilsV4
import CoreData
class TesteViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnCadastrar: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var user = Usuario.sharedInstance
    
    // padrao da url
    let urlPadrao = UrlWS()
    let utilidades = Util()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let usuarioDao = UsuarioDAO()
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexto: NSManagedObjectContext = appDel.managedObjectContext

//        if usuarioDao.verificaUserLogado(contexto) {
//            print(usuarioDao.recuperaDadosUsuario(contexto).nome)
//        }else{
//            print("Nao tem nenhum usuario cadastrado")
//        }
        
        configuraNavBar()
        
        btnLogin.layer.cornerRadius = 5
        btnFacebook.layer.cornerRadius = 5
        utilidades.configuraLabelInformacao(info, comInvisibilidade: true, comIndicador: activityIndicator, comInvisibilidade: true, comAnimacao: false)
//        utilidades.configuraLabelInformacao(info, comVisibilidade: true, comIndicador: activityIndicator, comVisibilidade: true, comStatus: false)
    
       // scroll.scrollEnabled = false
        self.senha.delegate = self
        self.email.delegate = self
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TesteViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        

    }

    override func viewWillAppear(animated: Bool) {
        configuraNavBar()
    }
    
    func configuraNavBar(){
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.hidden = true
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
    }
//    override func viewDidAppear(animated: Bool) {
//        self.navigationController?.navigationBar.hidden = true
//
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(textField: UITextField) {
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

    func dismissKeyboard() ->Void{
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //scroll.setContentOffset(CGPointMake(0, 0), animated: true)
        //scroll.scrollEnabled = false
    }
  
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if email == textField{
            senha.becomeFirstResponder() // passa para o proximo campo
        }else{
            login(self) // chama a acao do botao
        }
        return true
    }
  
    /**
        Botão cadastro, acao que leva para tela de cadastro
     */
    @IBAction func Cadastrar(sender: AnyObject) {
        let verificaConexao = VerificarConexao()
        if verificaConexao.isConnectedToNetwork(){
            performSegueWithIdentifier("cadastrar", sender: self)
        }else{
            showAlert("Sem Conexão", msg: "Para fazer login é necessário que tenha uma conexão! Verifique sua conexão e tente novamente", titleBtn: "OK")
        }
    }
    
    /**
     Apresenta alerta na tela
     */
    func showAlert(title: String, msg: String, titleBtn: String){
        let alerta = UIAlertController(title: title, message:msg, preferredStyle: .Alert)
        alerta.addAction(UIAlertAction(title: titleBtn, style: .Default, handler: { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alerta, animated: true, completion: nil)
    }
//
//    @IBAction func login(sender: AnyObject) {
//    }
    @IBAction func login(sender: AnyObject) {
        let verficaConexao = VerificarConexao()
        if verficaConexao.isConnectedToNetwork(){
            let util = Util()
            if (util.isVazio(email.text!) || util.isVazio(senha.text!)){
                showAlert("Ops!", msg: "Os campos email e senha devem ser informados!", titleBtn: "OK")
            }else{
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()

                utilidades.configuraLabelInformacao(info, comInvisibilidade: false, comIndicador: activityIndicator, comInvisibilidade: false, comAnimacao: true)
                
                fazLogin(email.text!, senha: senha.text!)
            }
        }else{
            showAlert("Sem Conexão", msg: "Para fazer login é necessário que tenha uma conexão! Verifique sua conexão e tente novamente", titleBtn: "OK")
        }
    }
    
//    @IBAction func loginFacebook(sender: AnyObject) {
//    }
    @IBAction func loginFacebook(sender: AnyObject) {

               //let permission = ["public_profile"]
        //PFFacebookUtils.logInInBackgroundWithReadPermissions(permission)
        //pegaDadosFacebook()
        
    }
    /* Realiza login*/
    func fazLogin(email:String, senha:String) -> Void{
        
//        Alamofire.request(.POST, "").authenticate(user: <#T##String#>, password: <#T##String#>)
        
        
        
        let url = urlPadrao.urlRealizaLogin(email, senha: senha)
        //let url = "http://minhafarmacia-env.us-west-2.elasticbeanstalk.com:80/cliente/login/\(email)-\(senha)"
        print(url)
        Alamofire.request(.GET,  url).authenticate(user: email, password: senha).responseJSON { (response) in
            if let JSON = response.result.value{
                print("------->\(response.result.isSuccess) ")
                if JSON.count != nil{
                    
                    if let idUsuario = JSON.objectForKey("idUsuario") as? String{
                        self.user.id = Int(idUsuario)
                        
                    }
                    if let nomeUsuario = JSON.objectForKey("nome") as? String{
                        self.user.nome = nomeUsuario
                    }
                    if let email = JSON.objectForKey("email") as? String{
                        self.user.email = email
                    }
                    if let idFacebook = JSON.objectForKey("idFacebook") as? String{
                        self.user.idFacebook = idFacebook
                    }else{
                        self.user.idFacebook = "Não Informado"
                    }
                    if let dataString = JSON.objectForKey("dataNascimento") as? String{
                       print("---------> dataString \(dataString)")
                        let dateString = dataString.stringByReplacingOccurrencesOfString("Z", withString: "")
                        print("---------> tratado \(dateString)")

                        let dateFormatter = NSDateFormatter() //Instância do date Formatter
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        let date:NSDate
                        date = dateFormatter.dateFromString(dateString)!
                        self.user.dataNascimento = date
                    }
                    if let senha = JSON.objectForKey("senha") as? String{
                        self.user.senha = senha
                    }
                    if let sexo = JSON.objectForKey("sexo") as? String{
                        self.user.sexo = sexo
                    }
                    if let fotoString = JSON.objectForKey("foto") as? String{
                        self.user.foto = self.tratarImagemUsuario(fotoString)
                    }else{
                        self.user.foto = UIImage(named: "homem.png")
                    }
                    
                    /*
                     Salvar usuario no banco
                     */
                    let udao = UsuarioDAO()
                    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    let contexto: NSManagedObjectContext = appDel.managedObjectContext
                    if !udao.verificaUserLogado(contexto){
                        udao.salvaUsuario(contexto, usuario: self.user)
                    }
                    
                    self.utilidades.configuraLabelInformacao(self.info, comInvisibilidade: true, comIndicador: self.activityIndicator, comInvisibilidade: true, comAnimacao: false)
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                   

                    self.performSegueWithIdentifier("LoginTelaMedicamento", sender: self)
       
                    

                }else{
                    
                    self.showAlert("Ops", msg: "Usuário ou Senha incorreto!", titleBtn: "ok")
                }
            }

               self.utilidades.configuraLabelInformacao(self.info, comInvisibilidade: true, comIndicador: self.activityIndicator, comInvisibilidade: true, comAnimacao: false)
            UIApplication.sharedApplication().endIgnoringInteractionEvents()

        }
    }
    

    func tratarImagemUsuario(imgStr: String)-> UIImage{
        var image = UIImage()
        let util = Util()
        if imgStr.characters.count > 10{
            image = util.convertStringToImage(imgStr)
        }else{
            image = UIImage(named: "homem.png")!
        }
        return image
    }
    
    func trataData(dataString:String) ->NSDate{
        let strDate = dataString //"2015-10-06T15:42:34Z"
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "pt-BR")
        var date = NSDate()
        date = dateFormatter.dateFromString(strDate)!
        print(date)
        return date
    }

    /**
        Recuperar senha
        O metodo irá gerar um alert que irá receber o email do usuario e posteriormente irá fazer uma requisição 
      no ws pendido a recuperação da senha
     */
    @IBAction func recuperarSenha(sender: AnyObject) {
        let conexao = VerificarConexao()
        if conexao.isConnectedToNetwork(){
            let alert = UIAlertController(title: "Recuperar Senha", message: "Digite o email cadastrado", preferredStyle: .Alert)
            let recuperaSenha = UIAlertAction(title: "Recuperar", style: .Default) { (_) in
                let emailText = alert.textFields![0] as UITextField
                // realizar a requisição com o email informado
                if emailText.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
                    let dicEmail = ["email":emailText.text!]
                    // apresenta o carregamento
                    self.info.hidden = false
                    self.activityIndicator.hidden = false
                    self.activityIndicator.startAnimating()
                    
                    //Solicitar a requisição com email inforamdo
                    Alamofire.request(.GET,self.urlPadrao.urlRecuperarSenha(emailText.text!),parameters: dicEmail ).responseJSON(completionHandler: { (response) in
                        if let JSON = response.result.value{ // verifica se a responsta é valida
                            if JSON.count != nil{ // verifica se possui conteudo
                                if JSON.objectForKey("email") as! String != ""{ // verifica se o servidor repondeu que encontrou o email
                                    self.showAlert("Recuperação de Senha", msg: "Em instantes você receberá um e-mail com sua senha", titleBtn: "OK")
                                }else{// não encontrou o email da mensagem de alerta
                                    self.showAlert("Recuperação de Senha", msg: "O e-mail informado não está cadastrado", titleBtn: "OK")
                                }
                            }
                        }
                        // retira o carregamento da view
                        self.info.hidden = true
                        self.activityIndicator.hidden = true
                        self.activityIndicator.stopAnimating()
                    })
                }
        
        
        }
        
        
            alert.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "E-mail"
                textField.keyboardType = .EmailAddress
            }
            let cancelAction = UIAlertAction(title: "Cancelar", style: .Destructive) { (_) in }
            alert.addAction(recuperaSenha)
            alert.addAction(cancelAction)
        
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            showAlert("Sem Conexão", msg: "Para fazer login é necessário que tenha uma conexão! Verifique sua conexão e tente novamente", titleBtn: "OK")

        }
        
    }
    
        /*Pega os dados do facebook e salva no usuario corrente*/
    func pegaDadosFacebook(){
       
        
    }
}
   
    

