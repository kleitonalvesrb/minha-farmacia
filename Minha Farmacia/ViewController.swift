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
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let permissions = ["public_profile"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user: PFUser?, error: NSError?) in
            if let erro = error{
                print(erro)
            }else{
                if let usuario = user{
                    print(usuario)
                }
            }
        }
        print(PFUser.currentUser()?.username)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

