//
//  ViewController.swift
//  Minha Farmacia
//
//  Created by Kleiton Batista on 28/07/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var txt: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.scrollEnabled = false
        scroll.contentSize = CGSizeMake(0, 0)
        /*Configuraçao para remover o teclado ao clicar fora do campo*/
//        self.senha.delegate = self
//        self.email.delegate = self
//        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
//        /*Fim configuração teclado*/
       
    }
//    func dismissKeyboard()->Void{
//        view.endEditing(true)
//    }

    func textFieldDidBeginEditing(textField: UITextField) {
        if (txt == textField){
            scroll.scrollEnabled = true
            scroll.setContentOffset(CGPointMake(0, 250), animated: true)
            scroll.contentSize = CGSizeMake(0, 1000)

        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        scroll.setContentOffset(CGPointMake(0, 0), animated: true)
      scroll.scrollEnabled = false


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
    }
    

    @IBAction func loginFB(sender: AnyObject) {
    }
    @IBAction func registrar(sender: AnyObject) {
    }
    
        
    
    /* let permissions = ["public_profile"]
     PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user: PFUser?, error: NSError?) in
     if let erro = error{
     print(erro)
     }else{
     if let usuario = user{
     print(usuario)
     }
     }
     }
     print(PFUser.currentUser()?.username)*/
}

