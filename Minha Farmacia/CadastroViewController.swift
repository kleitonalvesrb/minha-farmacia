//
//  CadastroViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 31/07/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class CadastroViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var campoSexo: UITextField!
    var pickerSexo = UIPickerView()
    let arraySexo = ["Masculino","Feminino","Outro","Prefiro não Informar"]
    
    var scroll : UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        pickerSexo.delegate = self
//        pickerSexo.dataSource = self
//        campoSexo.inputView = pickerSexo
//        
//        campoSexo.delegate = self
        //scroll = UIScrollView(frame: CGRectMake(0,0,0,0))
        scroll = UIScrollView()
        scroll.scrollEnabled = false;
        scroll.contentSize = CGSizeMake(0, self.view.frame.height + 1000) // coloca o scroll do tamanho da view + 90
        view.addSubview(scroll)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CadastroViewController.dismissKeyboard)))
        
    }
    @IBAction func voltar(sender: AnyObject) {
        print(": aki")
        performSegueWithIdentifier("cancelar", sender: self)
    }
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews();
        
        self.scroll.frame = self.view.bounds; // Instead of using auto layout
        self.scroll.contentSize.height = 3000; // Or whatever you want it to be.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissKeyboard(){
        self.view.endEditing(true)
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
