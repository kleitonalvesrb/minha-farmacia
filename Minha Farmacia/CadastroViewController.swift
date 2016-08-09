//
//  CadastroViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 31/07/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class CadastroViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var campoSexo: UITextField!
    var pickerSexo = UIPickerView()
    let arraySexo = ["Masculino","Feminino","Outro","Prefiro não Informar"]
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerSexo.delegate = self
        pickerSexo.dataSource = self
        campoSexo.inputView = pickerSexo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arraySexo.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arraySexo[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        campoSexo.text = arraySexo[row]
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
