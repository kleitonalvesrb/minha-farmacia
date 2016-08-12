//
//  TelaCadastroViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 09/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import Alamofire
class TelaCadastroViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var scroll: UIScrollView!

    
    let arraySexo = ["","Masculino", "Feminino", "Outro", "Prefiro não Informar"]
    @IBOutlet weak var fotoPerfil: UIImageView!
    @IBOutlet weak var campoDataNascimento: UITextField!
    @IBOutlet weak var campoSexo: UITextField!
    @IBOutlet weak var campoSenha: UITextField!
    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var campoNome: UITextField!
    var pickerSexo:UIPickerView = UIPickerView()
    
    var user = Usuario.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent


        pickerSexo.dataSource = self
        pickerSexo.delegate = self
        campoSexo.inputView = pickerSexo

        campoSexo.delegate = self
        campoNome.delegate = self
        campoEmail.delegate = self
        campoSenha.delegate = self
        campoDataNascimento.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    


        

    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*Retirar o teclado*/
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == campoDataNascimento{
            let dataPickerView: UIDatePicker = UIDatePicker()
            dataPickerView.maximumDate = NSDate()
            
            dataPickerView.datePickerMode = UIDatePickerMode.Date
            campoDataNascimento.inputView = dataPickerView
            
            dataPickerView.addTarget(self, action: #selector(TelaCadastroViewController.getValueDatePicker), forControlEvents: UIControlEvents.ValueChanged)
        }else if textField == campoSexo{
            print(campoSexo.text)
        }
    }
    /*Pegar o valor da data*/
    func getValueDatePicker(sender: UIDatePicker){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
    
        campoDataNascimento.text = dateFormatter.stringFromDate(sender.date)
        
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
        Realiza o cadastro do usuario no servidor
     */
    @IBAction func realizarCadastro(sender: AnyObject) {
        let valida = Util()
        
        if valida.isVazio(campoNome.text!) || valida.isVazio(campoEmail.text!) || valida.isVazio(campoSenha.text!) ||
                        valida.isVazio(campoSexo.text!) || valida.isVazio(campoDataNascimento.text!){
            
            
            geraAlerta("Ops", mensagem: "Todos os campos devem ser informados")
            
        }else{
            let url = "http://10.60.214.100:8080/WebService/cliente/inserir"
            let usuario = ["nome": campoNome.text!,
                           "email": campoEmail.text!,
                           "senha": campoSenha.text!,
                           "sexo":campoSexo.text!,
                           "dataNascimento":campoDataNascimento.text!,
                           "foto":user.convertImageToString(fotoPerfil.image!)]
            Alamofire.request(.POST, url, parameters: usuario, encoding: .JSON, headers: nil).responseJSON(completionHandler: { (response) in
                print(response.result)
                print(response.debugDescription)
            })
            
            
            
        }
    }
    /*+2*/
    @IBAction func escolherFoto(sender: AnyObject) {
        formaDeCapturaFotoPerfil()
    }

    func formaDeCapturaFotoPerfil(){
        print("sexo \(campoSexo.text) e nome \(campoNome.text)")
        let alerta = UIAlertController(title: "Escolher foto de Perfil", message: "", preferredStyle: .ActionSheet)
        let takeApicture = UIAlertAction(title: "Câmera", style: .Default) { (alert: UIAlertAction!) in
            self.definirFoto(true)
        }
        let chooseAPicutre = UIAlertAction(title: "Galeria", style: .Default) { (alert: UIAlertAction!) in
            self.definirFoto(false)
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .Cancel) { (alert: UIAlertAction!) in
            self.geraAlerta("Foto de Perfil", mensagem: "Tudo bem, você poderá escolher uma foto mais tarde!")
        }
        alerta.addAction(takeApicture)
        alerta.addAction(chooseAPicutre)
        alerta.addAction(cancel)
        
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }
    func geraAlerta(title: String, mensagem: String){
        let alerta = UIAlertController(title: title, message: mensagem, preferredStyle: .Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }
    
    func definirFoto(camera : Bool){
        let img = UIImagePickerController()
        img.delegate = self
        /*Define a forma que a foto será selecionada, camera ou galeria*/
        if camera {
            img.sourceType = UIImagePickerControllerSourceType.Camera
        }else{
            img.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        img.allowsEditing = false
        self.presentViewController(img, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        fotoPerfil.image = image
    }
}
