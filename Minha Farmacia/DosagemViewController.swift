//
//  DosagemViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 09/09/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class DosagemViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var medicamento: Medicamento = Medicamento()
    
    @IBOutlet weak var btnSalvar: UIButton!
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var campoPeriodo: UITextField!
    @IBOutlet weak var campoIntervalo: UITextField!
    @IBOutlet weak var campoDataInicio: UITextField!
    @IBOutlet weak var campoDosagem: UITextField!
    @IBOutlet weak var tipoDosagemSwitch: UISwitch!
    @IBOutlet weak var imgMedicamento: UIImageView!
    
    var pickerDosagem:UIPickerView = UIPickerView() //0
    var pickerIntervalo: UIPickerView = UIPickerView() // 1
    var pickerPeriodo: UIPickerView = UIPickerView() // 2
    var pickerDosagemComprimido: UIPickerView = UIPickerView()//3
    
    var arrayDosage = [String]()
    var arrayIntervalo = [String]()
    var arrayPeriodo = [String]()
    var arrayComprimido = ["1/4", "1/3", "1/2", "1",
                           "1 1/4", "1 1/3", "1 1/2", "2",
                           "2 1/4", "2 1/3", "2 1/2", "3",
                           "3 1/4", "3 1/3", "3 1/2", "4"]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDeleganteFields()
        configuraPicker()
        populaArray()
        imgMedicamento.image = medicamento.fotoMedicamento
        
        self.navigationController?.navigationBar.hidden = true
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DosagemViewController.dismissKeyboard)))
        
        

        // Do any additional setup after loading the view.
    }
    func configuraPicker(){
        pickerDosagem.delegate = self
        pickerDosagem.dataSource = self
        pickerIntervalo.delegate = self
        pickerIntervalo.dataSource = self
        pickerPeriodo.delegate = self
        pickerPeriodo.dataSource = self
        pickerDosagemComprimido.delegate = self
        pickerDosagemComprimido.dataSource = self
        
        campoDosagem.inputView = pickerDosagemComprimido
        campoIntervalo.inputView = pickerIntervalo
        campoPeriodo.inputView = pickerPeriodo
        
        
        pickerDosagem.tag = 0
        pickerIntervalo.tag = 1
        pickerPeriodo.tag = 2
        pickerDosagemComprimido.tag = 3
        
    }
    func setDeleganteFields(){
        campoPeriodo.delegate = self
        campoIntervalo.delegate = self
        campoDataInicio.delegate = self
        campoDosagem.delegate = self
    }
    
    @IBAction func salvar(sender: AnyObject) {
    }
    // alterar o tipo de dosagem, alterar de ML para MG
    @IBAction func switchTipoDosagem(sender: AnyObject) {
        if sender.on == true{
            campoDosagem.inputView = pickerDosagemComprimido
        }else{
            campoDosagem.inputView = pickerDosagem
        }
    }
    func populaArray(){
        //populando array de dosagem
        arrayPeriodo.append("")
        
        for i in 1...40{
           
            arrayDosage.append("\(Double(i) * 0.5) ML ")
        }
        //populando array de periodo
        arrayPeriodo.append("")
        arrayPeriodo.append("Todos os Dias")
        for i in 1...45{
            arrayPeriodo.append("\(i) Dias")
        }
        arrayIntervalo.append("")
        for i in 1...24{
            arrayIntervalo.append("\(i) Horas")
        }
        
    }
    func dismissKeyboard(){
        if self.view.frame.height == 480{
            alteraPosicaoTelaTamanhoScroll(150)
        }else{
            alteraPosicaoTelaTamanhoScroll(20)
        }
        
        self.view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return arrayDosage.count
        }else if pickerView.tag == 1{
            return arrayIntervalo.count
        }else if pickerView.tag == 2{
            return arrayPeriodo.count
        }else if pickerView.tag == 3{
            return arrayComprimido.count
//            return dicComprimido.count
        }
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return arrayDosage[row]
        }else if pickerView.tag == 1{
            return arrayIntervalo[row]
        }else if pickerView.tag == 2{
            return arrayPeriodo[row]
        }else if pickerView.tag == 3{
            return arrayComprimido[row]
//            return Array(dicComprimido.keys)[row]
        }
        return "Deu ruim"
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            campoDosagem.text = arrayDosage[row]
        }else if pickerView.tag == 1{
            campoIntervalo.text = arrayIntervalo[row]
        }else if pickerView.tag == 2{
            campoPeriodo.text = arrayPeriodo[row]
        }else if pickerView.tag == 3{
           campoDosagem.text = arrayComprimido[row]
           
        }
        
        //  campoSexo.text = arraySexo[row]
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        
       configuraPosicionamentoScroll(textField)
       selecionaDataInicio(textField)
      
    }
    func selecionaDataInicio(textField: UITextField){
        if textField == campoDataInicio{
            let dataPickerView = UIDatePicker()
            
//            dataPickerView.maximumDate = NSDate(
            dataPickerView.locale = NSLocale(localeIdentifier: "pt-BR")
            dataPickerView.datePickerMode = UIDatePickerMode.DateAndTime
            campoDataInicio.inputView = dataPickerView
            
            let dateFormatter = NSDateFormatter()
            
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.locale = NSLocale(localeIdentifier: "pt-BR")
            
            campoDataInicio.text = dateFormatter.stringFromDate(NSDate())
            
            
            dataPickerView.addTarget(self, action: #selector(DosagemViewController.getValueDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    /*Pegar o valor da data*/
    func getValueDatePicker(sender: UIDatePicker){
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "pt-BR")
        
        campoDataInicio.text = dateFormatter.stringFromDate(sender.date)
        
    }

    
    /**
        Método responsavel por ajustar o posicionamento dos elementos na tela
     
     */
    func configuraPosicionamentoScroll(textField: UITextField){
        /* Configuração de tamanho da tela, ajusta no tamanho exato de cada dispositivo*/
        if textField == campoDataInicio || textField == campoIntervalo || textField == campoPeriodo{
            if self.view.frame.height == 568{
                alteraPosicaoTelaTamanhoScroll(220)
            }else if self.view.frame.height == 480{
                alteraPosicaoTelaTamanhoScroll(300)
            }
        }else{
            if self.view.frame.height != 480{
                alteraPosicaoTelaTamanhoScroll(200)
            }else{
                alteraPosicaoTelaTamanhoScroll(0)
            }
        }

    }
    func alteraPosicaoTelaTamanhoScroll(valorX: CGFloat){
        scroll.contentSize = CGSizeMake(0, self.view.frame.height + valorX)
        scroll.setContentOffset(CGPointMake(0, valorX), animated: true)

    }
}
