//
//  AjudaTableViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 09/11/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class AjudaTableViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var itensAjuda = [ItensAjuda]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       

        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        itensAjuda.append(ItensAjuda(desc: "Medicamentos sendo tomados regularmente.", img: "green_marker.png", nome: "Marcador em dias"))
        itensAjuda.append(ItensAjuda(desc: "Medicamentos cujas dosagens estão em atraso.", img: "red_marker.png", nome: "Marcador em atraso"))
        itensAjuda.append(ItensAjuda(desc: "Medicamentos cujas dosagens foram concluídas ao final do tratamento.", img: "blue_marker.png", nome: "Marcador Concluído"))
        
    }
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1        //return frutaAlfabetica.keys.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itensAjuda.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AjudaTableViewCell
        cell.imgItem.image = UIImage(named:itensAjuda[indexPath.row].imagemString)
        cell.nomeItem.text = itensAjuda[indexPath.row].nome
        cell.descItem.text = itensAjuda[indexPath.row].descricao
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
