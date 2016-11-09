//
//  MaisViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 05/11/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import MessageUI
class MaisViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,MFMailComposeViewControllerDelegate {
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
//            performSegueWithIdentifier("contato", sender: self)
            configuraEnvioEmail()
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
    func configuraEnvioEmail(){
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }

    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
//        let imageData: NSData = UIImagePNGRepresentation(UIImage(named: "logo.png")!)!
//        mailComposerVC.addAttachmentData(imageData, mimeType: "image/png", fileName: "logo.png")
        
        mailComposerVC.setToRecipients(["projetominhafarmacia@gmail.com"])
        mailComposerVC.setSubject("Contato")
//        mailComposerVC.setMessageBody("<h1>Ola pessoal</h1>", isHTML: true)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
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
