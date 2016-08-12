//
//  TelaCadastroViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 09/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class TelaCadastroViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var scroll: UIScrollView!

    
    let arraySexo = ["Masculino", "Feminino", "Outro", "Prefiro não Informar"]
// 
//    @IBOutlet weak var scroll: UIScrollView!
//    @IBOutlet weak var campoDataNascimento: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //scroll.scrollEnabled = true
        

        //scroll.contentSize = CGSizeMake(0,3000)
        
////
////       scroll.scrollEnabled = false // habilita o scroll
////        scroll.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height + 900) // coloca o scroll do tamanho da view + 90
////
//        pickerSexo.dataSource = self
//        pickerSexo.delegate = self
//        campoSexo.inputView = pickerSexo
//        
//        campoSexo.delegate = self
//        campoNome.delegate = self
//        campoEmail.delegate = self
//        campoSenha.delegate = self
//        campoDataNascimento.delegate = self
////
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    


        

    }
    
//    override func viewWillLayoutSubviews()
//    {
//        super.viewWillLayoutSubviews();
//        
//        self.scroll.frame = self.view.bounds; // Instead of using auto layout
//        self.scroll.contentSize.height = 3000; // Or whatever you want it to be.
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*Retirar o teclado*/
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
//    func textFieldDidBeginEditing(textField: UITextField) {
//        if textField == campoDataNascimento{
//            let dataPickerView: UIDatePicker = UIDatePicker()
//            dataPickerView.datePickerMode = UIDatePickerMode.Date
//            campoDataNascimento.inputView = dataPickerView
//            dataPickerView.addTarget(self, action: #selector(TelaCadastroViewController.getValueDatePicker), forControlEvents: UIControlEvents.ValueChanged)
//        }else{
//            print("outro campo")
//        }
//    }
//    /*Pegar o valor da data*/
//    func getValueDatePicker(sender: UIDatePicker){
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
//        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
//        campoDataNascimento.text = dateFormatter.stringFromDate(sender.date)
//        
//    }
//   
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
//        campoSexo.text = arraySexo[row]
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
