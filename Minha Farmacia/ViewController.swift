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
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*Configuraçao para remover o teclado ao clicar fora do campo*/
        self.senha.delegate = self
        self.email.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        /*Fim configuração teclado*/
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
     

    }
    func dismissKeyboard()->Void{
        view.endEditing(true)
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
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//            self.view.frame.origin.y += keyboardSize.height
//        }
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

