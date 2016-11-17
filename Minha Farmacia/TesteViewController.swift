
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
    
    
    @IBOutlet weak var btnOutraConta: UIButton!
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
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        //        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        //        print(UIApplication.sharedApplication().applicationIconBadgeNumber)
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexto: NSManagedObjectContext = appDel.managedObjectContext
        let usuarioDao = UsuarioDAO()
        
        if usuarioDao.verificaUserLogado(contexto) {
            btnOutraConta.hidden = false
            btnOutraConta.userInteractionEnabled = true
            let usuario = usuarioDao.recuperaDadosUsuario(contexto)
            user.nome = usuario.nome
            user.email = usuario.email
            user.dataNascimento = usuario.dataNascimento
            user.id = usuario.id
            user.foto = usuario.foto
            user.idFacebook = usuario.idFacebook
            user.medicamento = usuario.medicamento
            user.receitas = usuario.receitas
            user.senha = usuario.senha
            user.sexo = usuario.sexo
            email.text = user.email
            email.userInteractionEnabled = false
        }else{
            btnOutraConta.hidden = true
            btnOutraConta.userInteractionEnabled = false
            
            print("Nao tem nenhum usuario cadastrado")
        }
        
        
        //       print(UsuarioDAO().recuperaDadosUsuario(contexto).nome)
        self.title = "Login"
        
        //        let app:UIApplication = UIApplication.sharedApplication();
        //        let eventArray:NSArray = app.scheduledLocalNotifications!;
        //        print("qtd ---->\(eventArray.count)<-----")
        
        
        
        
        
        //        for i in eventArray{
        //            //print(i)
        ////           UIApplication.sharedApplication().cancelLocalNotification(i as! UILocalNotification)
        //        }
        //        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //        let contexto: NSManagedObjectContext = appDel.managedObjectContext
        //        for m in MedicamentoDAO().recuperarMedicamentos(contexto){
        //            print("Id remedio \(m.id) ID dosagem \(m.dosagemMedicamento.id)")
        //            for n in m.dosagemMedicamento.notificacoes{
        //                print("Notificacoes ->\(n.id)")
        //                print("Data => \(n.dataNotificacao)")
        //            }
        //        }
        
        //
        
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
    
    @IBAction func btnEntrarOutraConta(sender: AnyObject) {
        self.apagaDadosUsuario()
        self.apagaNotificacoesFuturas()
        self.redirecionaPaginaLogin()
    }
    func apagaDadosUsuario(){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexto: NSManagedObjectContext = appDel.managedObjectContext
        
        UsuarioDAO().deletaDadosUsuario(contexto)
        MedicamentoDAO().deletaMedicamentos(contexto)
        DosagemDAO().deletaDosagem(contexto)
        NotificacaoDAO().deletaNotificacoes(contexto)
        //UIControl().sendAction(Selector("suspend"), to: UIApplication.sharedApplication(), forEvent: nil)
        
    }
    func apagaNotificacoesFuturas(){
        let app:UIApplication = UIApplication.sharedApplication();
        let eventArray:NSArray = app.scheduledLocalNotifications!;
        print("qtd ---->\(eventArray.count)<-----")
        
        for i in eventArray{
            UIApplication.sharedApplication().cancelLocalNotification(i as! UILocalNotification)
        }
        
    }
    func redirecionaPaginaLogin(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let telaLogin = storyBoard.instantiateViewControllerWithIdentifier("telaLogin") as! TesteViewController
        self.presentViewController(telaLogin, animated:false, completion:nil)
    }
    override func viewWillAppear(animated: Bool) {
        configuraNavBar()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
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
            //            performSegueWithIdentifier("cadastrar", sender: self)
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
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexto: NSManagedObjectContext = appDel.managedObjectContext
        let usuarioDao = UsuarioDAO()
        if !usuarioDao.verificaUserLogado(contexto){
            
            let verficaConexao = VerificarConexao()
            if verficaConexao.isConnectedToNetwork(){
                let util = Util()
                if (util.isVazio(email.text!) || util.isVazio(senha.text!)){
                    showAlert("Ops!", msg: "Os campos email e senha devem ser informados!", titleBtn: "OK")
                }else{
                    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                    
                    utilidades.configuraLabelInformacao(info, comInvisibilidade: false, comIndicador: activityIndicator, comInvisibilidade:     false, comAnimacao: true)
                    
                    fazLogin(email.text!, senha: senha.text!)
                }
            }else{
                showAlert("Sem Conexão", msg: "Para fazer login é necessário que tenha uma conexão! Verifique sua conexão e tente novamente", titleBtn: "OK")
            }
        }else{
            self.user = usuarioDao.recuperaDadosUsuario(contexto)
            validaUsuario(user)
        }
    }
    func validaUsuario(usuario : Usuario){
        let util = Util()
        if (util.isVazio(email.text!) || util.isVazio(senha.text!)){
            showAlert("Ops!", msg: "Os campos email e senha devem ser informados!", titleBtn: "OK")
        }else{
            if user.senha == senha.text!{
                print("por aqui")
                self.performSegueWithIdentifier("LoginTelaMedicamento", sender: self)
            }else{
                showAlert("Ops!", msg: "A senha informada não corresponde", titleBtn: "Ok")
            }
        }
    }
    
    //    @IBAction func loginFacebook(sender: AnyObject) {
    //    }
    @IBAction func loginFacebook(sender: AnyObject) {
        var usuarioFacebook = Usuario()
        Util().configuraLabelInformacao(info, comInvisibilidade: false, comIndicador: activityIndicator, comInvisibilidade: false, comAnimacao: true)
        let permissions = ["public_profile"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user: PFUser?, error: NSError?) in
            if let erro = error{
                print(erro)
            }else{
                if let _ = user{
                    let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, gender, email, age_range"])
                    graphRequest.startWithCompletionHandler { (connection, result, error) in
                        if error != nil{
                            print(error)
                        }else if let resultados = result{
                            
                            
                            let dados = resultados as! NSDictionary
                            let userId = dados["id"] as! String
                            let facebookProfilePictureUrl = "https://graph.facebook.com/\(userId)/picture?type=large"
                            
                            let idade = dados.valueForKey("age_range")?.valueForKey("min")
                            
//                            print("idade é \()")
                            
                            usuarioFacebook.email = dados.valueForKey("email") as? String
                            usuarioFacebook.idFacebook = dados.valueForKey("id") as? String
                            usuarioFacebook.nome = dados.valueForKey("name") as? String
                            usuarioFacebook.sexo = (dados.valueForKey("gender") as? String)?.lowercaseString == "male".lowercaseString ? "Masculino" : "Feminino"
                            usuarioFacebook.dataNascimento = Util().getAnoNascimentoUserFacebook(Int(idade! as! NSNumber))
                            if let fbPicUrl = NSURL(string: facebookProfilePictureUrl){
                                if let data = NSData(contentsOfURL: fbPicUrl){
                                    usuarioFacebook.foto =  UIImage(data: data)
                                    
                                    print("Usuario: \(usuarioFacebook.nome)")
                                    print("Email : \(usuarioFacebook.email)")
                                    print("Sexo: \(usuarioFacebook.sexo)")
                                    print("id: \(usuarioFacebook.idFacebook)")
                                    print("DataNasciemtno: \(usuarioFacebook.dataNascimento)")
                                    print("tamanho foto: \(data.length)")
                                }
                            }
                            
                            Alamofire.request(.GET, UrlWS().urlConsultaUsuarioCadastradoFacebook(usuarioFacebook.idFacebook), parameters: ["idFacebook":usuarioFacebook.idFacebook], encoding: .JSON, headers: nil).responseJSON { (response) in
                                
                                print(response.response?.statusCode)
                                print(response.response?.statusCode)

                                if response.response?.statusCode == 200{
                                    Util().configuraLabelInformacao(self.info, comInvisibilidade: true, comIndicador: self.activityIndicator, comInvisibilidade: true, comAnimacao: false)
                                    self.showAlert("Resultado", msg: "Encontramos um perfil cadastrado em nossa base, podemos realizar o login", titleBtn: "ok")
                                }else{
                                    let usuario = ["nome": usuarioFacebook.nome,
                                        "email": usuarioFacebook.email,
                                        "senha": usuarioFacebook.idFacebook,
                                        "sexo":usuarioFacebook.sexo,
                                        "dataNascimentoString": "\(usuarioFacebook.dataNascimento)",
                                        "foto":usuarioFacebook.convertImageToString(usuarioFacebook.foto),
                                        "idFacebook":usuarioFacebook.idFacebook]
                                    
                                    Alamofire.request(.POST, UrlWS().urlCadastraUsuarioFacebook(), parameters: usuario, encoding: .JSON, headers: nil).responseJSON(completionHandler: { (response) in
                                        if response.result.isSuccess{
                                            
                                            self.populaUsuario(usuarioFacebook)
                                            self.navigationController?.navigationBar.hidden = true
                                            self.performSegueWithIdentifier("LoginTelaMedicamento", sender: self)

                                        }else{
                                            self.showAlert("Ops!", msg: "Tivemos um problema ao concluir cadastro, tente novamente mais tarde", titleBtn: "OK")
                                        }
                                    })
                                    Util().configuraLabelInformacao(self.info, comInvisibilidade: true, comIndicador: self.activityIndicator, comInvisibilidade: true, comAnimacao: false)
                                    
                                }
                                
                            }
                            
                        }
                    }
                }else{
                    print("nao quis")
                }
            }
        }
    }
   
    func populaUsuario(userFacebook: Usuario){
        user.nome = userFacebook.nome
        user.email = userFacebook.email
        user.sexo = userFacebook.sexo
        user.idFacebook = userFacebook.idFacebook
        user.foto = userFacebook.foto
        user.senha = userFacebook.idFacebook
        user.dataNascimento = userFacebook.dataNascimento
        user.id = 1
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexto: NSManagedObjectContext = appDel.managedObjectContext
        UsuarioDAO().salvaUsuario(contexto, usuario: user)
        
        
    }
    override func viewDidAppear(animated: Bool) {
        //        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //        let contexto: NSManagedObjectContext = appDel.managedObjectContext
        //        if UsuarioDAO().verificaUserLogado(contexto){
        //            performSegueWithIdentifier("LoginTelaMedicamento", sender: self)
        //        }
    }
    /* Realiza login*/
    func fazLogin(email:String, senha:String) -> Void{
        
        
        
        
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
                        print(dataString)
                        let dataCadastro = dataString[dataString.startIndex.advancedBy(0)...dataString.startIndex.advancedBy(9)]
                        print(dataCadastro)
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        dateFormatter.locale = NSLocale.currentLocale()
                        dateFormatter.timeZone = NSTimeZone.localTimeZone()
                        var date2:NSDate!
                        date2 = dateFormatter.dateFromString(dataCadastro)
                        self.user.dataNascimento = date2
                        print("--->\(self.user.dataNascimento)<-----")
                    }
                    //                    if let dataString = JSON.objectForKey("dataNascimento") as? String{
                    //                       print("---------> dataString \(dataString)")
                    //                        let dateString = dataString.stringByReplacingOccurrencesOfString("Z", withString: "")
                    //                        print("---------> tratado \(dateString)")
                    //
                    //                        let dateFormatter = NSDateFormatter() //Instância do date Formatter
                    //                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    //                        let date:NSDate
                    //                        date = dateFormatter.dateFromString(dateString)!
                    //                        self.user.dataNascimento = date
                    //                    }
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



