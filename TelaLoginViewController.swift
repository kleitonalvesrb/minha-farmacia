//
//  TelaLoginViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 20/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class TelaLoginViewController: UIViewController {

    @IBOutlet weak var btnEntrar: UIButton!
    @IBOutlet weak var btnEntrarFacebook: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnEntrar.layer.cornerRadius = 6
        
        btnEntrarFacebook.layer.cornerRadius = 6
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
