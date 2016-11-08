//
//  MaisViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 05/11/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class MaisViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let titulos = ["Quem Faz?","Sobre","Ajuda","Contato"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mais"

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1        //return frutaAlfabetica.keys.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titulos.count
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{
            performSegueWithIdentifier("quemFaz", sender: self)
        }else if indexPath.row == 1{
            performSegueWithIdentifier("sobre", sender: self)
        }else if indexPath.row == 2{
            performSegueWithIdentifier("ajuda", sender: self)
        }else if indexPath.row == 3{
            performSegueWithIdentifier("contato", sender: self)
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MaisTableViewCell
        cell.lblTItulo.text = titulos[indexPath.row]
//        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//        cell.tintColor = UIColor.redColor()
        
        //Set UITableViewCellAccessoryType.Checkmark here if necessary
        cell.accessoryType = .DisclosureIndicator

        return cell
        
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
