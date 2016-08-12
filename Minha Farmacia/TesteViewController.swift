//
//  TesteViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 30/07/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import Alamofire
class TesteViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnCadastrar: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    
    var user = Usuario.sharedInstance
    

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIApplication.sharedApplication().statusBarStyle = .LightContent

        
        scroll.scrollEnabled = false
        self.senha.delegate = self
        self.email.delegate = self
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TesteViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func viewDidAppear(animated: Bool) {
        if user.nome != nil{
            print("vai trocar")
            user.nome = ""
            print("trocou? ->\(user.nome)<-")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        
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
        }
    }

    func dismissKeyboard() ->Void{
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scroll.setContentOffset(CGPointMake(0, 0), animated: true)
        scroll.scrollEnabled = false
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
  
    
    func showAlert(title: String, msg: String, titleBtn: String){
        let alerta = UIAlertController(title: title, message:msg, preferredStyle: .Alert)
        alerta.addAction(UIAlertAction(title: titleBtn, style: .Default, handler: { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alerta, animated: true, completion: nil)
    }
 
    @IBAction func login(sender: AnyObject) {
        let util = Util()
        if (util.isVazio(email.text!) || util.isVazio(senha.text!)){
            showAlert("Ops!", msg: "Os campos email e senha devem ser informados!", titleBtn: "OK")
        }else{
            print("redireciona")
           fazLogin(email.text!, senha: senha.text!)
        }
    }
    
    @IBAction func loginFacebook(sender: AnyObject) {
        //let permission = ["public_profile"]
        //PFFacebookUtils.logInInBackgroundWithReadPermissions(permission)
        //pegaDadosFacebook()
        
    }
    /* Realiza login*/
    func fazLogin(email:String, senha:String) -> Void{
        let url = "http://192.168.0.12:8080/WebService/cliente/login/\(email)-\(senha)"
        Alamofire.request(.GET, url).authenticate(user: email, password: senha).responseJSON { (response) in
            if let JSON = response.result.value{
                
                if JSON.count != nil{
                    
                    self.user.nome = (JSON["nome"] != nil ? JSON["nome"] as! String : "")
                    self.user.email = (JSON["email"] != nil ? JSON["email"] as! String : "")
                    //tratar dados idFacebook
                    if let idFacebook:String = JSON["idFacebook"] as? String{
                        self.user.idFacebook = idFacebook
                    }else{
                        self.user.idFacebook = "nao informado"
                    }
                    //trata idade
                    if let idadeString:String = JSON["idade"] as? String{
                        self.user.idade = Int(idadeString)
                    }else{
                        self.user.idade = 0;
                    }
                    print(self.user.idade)
                    self.user.senha = (JSON["senha"] != nil ? JSON["senha"] as! String : "")
                    //trata sexo
                    if let sexo:String = JSON["sexo"] as? String{
                        self.user.sexo = sexo
                    }else{
                        self.user.sexo = "Não informado"
                    }
                    //trata imagem
                    if let imgString:String = JSON["foto"] as? String{
                        if imgString.characters.count > 10{
                            self.user.foto = self.user.convertStringToImage(imgString)
                        }else{
                            if self.user.sexo.lowercaseString == "masculino"{
                                self.user.foto = UIImage(named: "homem.png")
                            }else if self.user.sexo.lowercaseString == "feminino"{
                                self.user.foto = UIImage(named: "mulher.png")
                            }else{
                                self.user.foto = UIImage(named: "indefinido.png")
                            }
                        }
                    }else{
                        if self.user.sexo.lowercaseString == "masculino"{
                            self.user.foto = UIImage(named: "homem.png")
                        }else if self.user.sexo.lowercaseString == "feminino"{
                            self.user.foto = UIImage(named: "mulher.png")
                        }else{
                            self.user.foto = UIImage(named: "indefinido.png")
                        } //<-- adc um avatar de acordo com o sexo
                    }
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let resultViewController = storyBoard.instantiateViewControllerWithIdentifier("login") as! TelaPrincipalViewController
                    
                    self.presentViewController(resultViewController, animated:true, completion:nil)

                }else{
                    
                    self.showAlert("Ops", msg: "Usuário ou Senha incorreto!", titleBtn: "ok")
                }
            }

            
        }
    }
  
//        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//            if segue.identifier == "logoutMotorista"{
//                navigationController?.setNavigationBarHidden(true, animated: false)
//                PFUser.logOut()
//            }else if segue.identifier == "verPedido"{
//                if let destination = segue.destinationViewController as? RequestViewController{
//                    destination.requestLocation = locations[(tableView.indexPathForSelectedRow?.row)!]
//                    destination.requestUserName = userNames[(tableView.indexPathForSelectedRow?.row)!]
//                }
//            }
//        }
    
//
    /*
     Alamofire.request(.GET, url).responseJSON { (response) in
     if let JSON = response.result.value{
     if JSON.count != nil{
     print("aki")
     isAutenticado = true
     
     self.user.nome = (JSON["nome"] != nil ? JSON["nome"] as! String : "")
     self.user.email = (JSON["email"] != nil ? JSON["email"] as! String : "")
     //tratar dados idFacebook
     if let idFacebook:String = JSON["idFacebook"] as? String{
     self.user.idFacebook = idFacebook
     }else{
     self.user.idFacebook = "nao informado"
     }
     //trata idade
     if let idadeString:String = JSON["idade"] as? String{
     print(idadeString,"<--")
     self.user.idade = Int(idadeString)
     }else{
     self.user.idade = 0;
     print("nao conseguiu")
     }
     print(self.user.idade)
     self.user.senha = (JSON["senha"] != nil ? JSON["senha"] as! String : "")
     //trata sexo
     if let sexo:String = JSON["sexo"] as? String{
     self.user.sexo = sexo
     }else{
     self.user.sexo = "Não informado"
     }
     //trata imagem
     if let imgString:String = JSON["foto"] as? String{
     if imgString.characters.count > 10{
     self.user.foto = self.user.convertStringToImage(imgString)
     }else{
     if self.user.sexo.lowercaseString == "masculino"{
     self.user.foto = UIImage(named: "homem.png")
     }else if self.user.sexo.lowercaseString == "feminino"{
     self.user.foto = UIImage(named: "mulher.png")
     }else{
     self.user.foto = UIImage(named: "indefinido.png")
     }
     }
     }else{
     if self.user.sexo.lowercaseString == "masculino"{
     self.user.foto = UIImage(named: "homem.png")
     }else if self.user.sexo.lowercaseString == "feminino"{
     self.user.foto = UIImage(named: "mulher.png")
     }else{
     self.user.foto = UIImage(named: "indefinido.png")
     } //<-- adc um avatar de acordo com o sexo
     }
     //self.performSegueWithIdentifier("loginEfetuado", sender: self)
     }else{
     self.showAlert("Ops", msg: "Usuário ou Senha incorreto!", titleBtn: "ok")
     }
     }
     if isAutenticado{
     self.performSegueWithIdentifier("loginEfetuado", sender: self)
     }
     }
*/
    
    
    
    
    
    
    
    
    
    
    
    
    
        /*Pega os dados do facebook e salva no usuario corrente*/
    func pegaDadosFacebook(){
       
        
//        let requisicao = FBSDKGraphRequest(graphPath: "me", parameters:["fields":"id, name, gender,age_range, email"])
//        requisicao.startWithCompletionHandler { (connection, result, error) in
//            if error != nil{
//                print(error)
//
//            }else if let resultado = result{
//                let dados = resultado as! NSDictionary
//                let idade = dados["age_range"] as! NSDictionary
//                PFUser.currentUser()?["nome"] = dados["name"] as? String
//                PFUser.currentUser()?["sexo"] = dados["gender"] as? String
//                PFUser.currentUser()?.email = dados["email"] as? String
//                PFUser.currentUser()?["idade"] = idade["min"] as? Int
//                PFUser.currentUser()?.saveInBackgroundWithBlock({ (sucesso, error) in
//                    if sucesso{
//                        print("deu bom")
//                    }else{
//                        print(error?.userInfo["error"])
//                    }
//                })
//            }
        }
    }
   
    

