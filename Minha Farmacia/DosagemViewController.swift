//
//  DosagemViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 09/09/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
class DosagemViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var lblInfor: UILabel!
    @IBOutlet weak var activityInfo: UIActivityIndicatorView!

    var medicamento = Medicamento.medicamentoSharedInstance

    @IBOutlet weak var btnSalvar: UIButton!
    @IBOutlet weak var scroll: UIScrollView!
   // @IBOutlet weak var campoTipoMedicamento: UITextField!
    @IBOutlet weak var campoSwitchMedicamento: UITextField!
    //@IBOutlet weak var campoTipoMedicamento: UITextField!
    
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
    var pickerTipoMedicamento: UIPickerView = UIPickerView()//4
    var pickerQtdGotas : UIPickerView = UIPickerView()//5
    
    var arrayTipoMedicamento = ["","Xarope","Comprimido","Gotas"]
    var arrayGotas = [String]()
    var arrayDosage = [String]()
    var arrayIntervalo = [String]()
    var arrayPeriodo = [String]()
    var arrayComprimido = ["","1/4", "1/3", "1/2", "1",
                           "1 1/4", "1 1/3", "1 1/2", "2",
                           "2 1/4", "2 1/3", "2 1/2", "3",
                           "3 1/4", "3 1/3", "3 1/2", "4"]
   
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configuraLabelInfo()
        setDeleganteFields()
        configuraPicker()
        populaArray()
        self.title = "Dosagem"
        campoSwitchMedicamento.addTarget(self, action: #selector(DosagemViewController.definiTipo), forControlEvents: UIControlEvents.EditingChanged)
      //  textField.addTarget(self, action: #selector(YourViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)

        btnSalvar.layer.masksToBounds = true
        btnSalvar.layer.cornerRadius = 5
        imgMedicamento.image = medicamento.fotoMedicamento
        atribuiIdMedicamento()
        
//        self.navigationController?.navigationBar.hidden = true
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DosagemViewController.dismissKeyboard)))
        
        

        // Do any additional setup after loading the view.
    }
  
    /**
        Configura label de apresentacao
     */
    func configuraLabelInfo(){
        lblInfor.hidden = true
        activityInfo.hidden = true
        lblInfor.layer.masksToBounds = true
        lblInfor.layer.cornerRadius = 20
        
    }
    func definiTipo(){
        print(campoSwitchMedicamento.text)
    }
    func configuraPicker(){
        pickerDosagem.delegate = self
        pickerDosagem.dataSource = self
        pickerIntervalo.delegate = self
        pickerIntervalo.dataSource = self
        pickerPeriodo.delegate = self
        pickerPeriodo.dataSource = self
        pickerDosagemComprimido.delegate = self
        pickerTipoMedicamento.dataSource = self
        pickerTipoMedicamento.delegate = self
        pickerDosagemComprimido.dataSource = self
        
        pickerQtdGotas.delegate = self
        pickerQtdGotas.dataSource = self
        
        campoDosagem.inputView = pickerDosagemComprimido
        campoIntervalo.inputView = pickerIntervalo
        campoPeriodo.inputView = pickerPeriodo
        campoSwitchMedicamento.inputView = pickerTipoMedicamento
        
        pickerDosagem.tag = 0
        pickerIntervalo.tag = 1
        pickerPeriodo.tag = 2
        pickerDosagemComprimido.tag = 3
        pickerTipoMedicamento.tag = 4
        pickerQtdGotas.tag = 5
        
    }
    func setDeleganteFields(){
        campoPeriodo.delegate = self
        campoIntervalo.delegate = self
        campoDataInicio.delegate = self
        campoDosagem.delegate = self
        campoSwitchMedicamento.delegate = self
        
    }
    
    @IBAction func salvar(sender: AnyObject) {
        let util = Util()
        let verficaConexao = VerificarConexao()
        if util.isVazio(campoIntervalo.text!) || util.isVazio(campoPeriodo.text!) || util.isVazio(campoDataInicio.text!) || util.isVazio(campoDosagem.text!){
            geraAlerta("Ops", mensagem: "Todos os campos devem ser informado!")
        }else{
            util.configuraLabelInformacao(lblInfor, comInvisibilidade: false, comIndicador: activityInfo, comInvisibilidade: false, comAnimacao: true)
            
            populaMedicamentoWithDosagem()
            if verficaConexao.isConnectedToNetwork(){
                print("nao deve passar por aqui")
                salvaMedicamentoLocal(medicamento,sicronizado: true)
                salvarMedicamentoDosagemServidor()
            }else{
                print("salvar em outra tabela")
                salvaMedicamentoLocal(medicamento,sicronizado: false)
               util.configuraLabelInformacao(lblInfor, comInvisibilidade: true, comIndicador: activityInfo, comInvisibilidade: true, comAnimacao: false)
                self.redirecionTelaMedicamentos()
            }
        }
        
    }
    func salvaMedicamentoLocal(medic : Medicamento, sicronizado: Bool){
//        self.geraAlerta("Data", mensagem: "\(medic.dosagemMedicamento.dataInicio)")
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexto: NSManagedObjectContext = appDel.managedObjectContext
        let mDao = MedicamentoDAO()
//        var rand:Int
//        repeat{
//            rand  = Int(arc4random_uniform(1000000))
//        }while(mDao.verificaMedicamentoId(contexto, id: rand))
//        medic.id = rand
        mDao.gravarMedicamento(contexto, medicamento: medic,sicronizado: sicronizado)
    }
    
    /**
        Atribui os dados da dosagem do medicamento ao medicamento cadastrado na tela anterior
     */
    func populaMedicamentoWithDosagem(){
        let util = Util()
        let dosagem:DosagemMedicamento = DosagemMedicamento()
        dosagem.dosagem = campoSwitchMedicamento.text!
        dosagem.intervaloDose = util.valorIntervalo(campoIntervalo.text!)
        dosagem.periodoTratamento = util.valorTempoDias(campoPeriodo.text!)
        dosagem.tipoMedicamento = campoSwitchMedicamento.text!
        dosagem.id = criaIdDosagem()
        
        // Initialize Date string
        let dateString2 = campoDataInicio.text!
        //let dateString2 = "26 de set de 2016 01:09"
        
        var dateStr4 = dateString2.stringByReplacingOccurrencesOfString(" de ", withString: " ")
        dateStr4 = dateStr4.stringByReplacingOccurrencesOfString("  ", withString: " ")
//        dateStr4 = dateStr4.stringByReplacingOccurrencesOfString("set", withString: "sep")
        print("data tratada --> ",dateStr4)
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let date2:NSDate!
            date2 = dateFormatter.dateFromString(dateStr4)
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if let unwrappedDate = date2 {
            
            print(dateFormatter.stringFromDate(unwrappedDate))
            print("--->",unwrappedDate)
            dosagem.dataInicio = unwrappedDate
           dosagem.notificacoes =  criaNotificacoes(dateStr4,comFormato: dateFormatter, comIntervalo: util.valorIntervalo(campoIntervalo.text!), totalDias: util.valorTempoDias(campoPeriodo.text!),idDosagem: dosagem.id)
        }else{
            print("tratar erro ")
        }
        dosagem.quantidade = trataQtdDosagemMedicamento(campoDosagem.text!, util: util)
        medicamento.dosagemMedicamento = dosagem
        
    }/**
        Cria as notificaçoes com base na data de inicio, intervalo entre as doses e o periodo total de tratamento
     */
    func criaNotificacoes(dataInicio: String,comFormato dateFormatter: NSDateFormatter, comIntervalo intervalo:Int, totalDias qtdDias:Int, idDosagem: Int) -> Array<Notificacao>{
       /**
         Array q ira armazenar os horarios dos medicamentos
         */
        var arrayDataNotificacao = [NSDate]()
        var arrayNotificacaoes = [Notificacao]()
        /**
            data criada é a data criada referente a data inicial do tratamento do 
            medicamento
         */
        let dateCriada = dateFormatter.dateFromString(dataInicio)
        let qtdDoses = calculaQtdVezes(qtdDias, comIntervalo: intervalo)
        
        
        let calendar = NSCalendar.currentCalendar()

        let min:Int = 60 // quantidade de segundos por min
        let hr:Int = 60 // quantidade de min por hora
        //i respresenta a proxima dose
        
        print("----->\(medicamento.id) <---------")
        for i in 1 ... qtdDoses{
            let proximaDose = min * hr * intervalo * i
            let date = calendar.dateByAddingUnit(.Second, value: proximaDose, toDate: dateCriada!, options: [])
            if LocalNotificationHelper().checkNotificationEnabled() == true {
                if diferencaMinEntreDuasDatas(date!, data2: NSDate()) <= 3 {
                    let notif = Notificacao()
                    notif.confirmado = 0
                    notif.dataNotificacao = date
                    notif.id = Int("\(idDosagem)\(i)")
                    arrayNotificacaoes.append(notif)
                    
                    LocalNotificationHelper().scheduleLocal("", alertDate: date!, corpoNotificacao: "Hora do remédio", medicamentoId: medicamento.id, numeroDose: i)
                }else{
                    print("nao foi gerado nenhuma notificacao para a data \(date)")
                }
//                LocalNotificationHelper().scheduleLocal("Oi tcc minha farmácia", alertDate: date!)
            }else {
                // Se as notificações locais estão desativados, exibir o pop-up de alerta e repor o interruptor para OFF                sender.setOn(false, animated: true)
                displayNotificationsDisabled()
            }
        }
        return arrayNotificacaoes
    }
    /**
        Atribui um id para o medicamento
     */
   private func atribuiIdMedicamento(){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexto: NSManagedObjectContext = appDel.managedObjectContext
        let mDao = MedicamentoDAO()
        var rand:Int
        repeat{
            rand  = Int(arc4random_uniform(1000000))
        }while(mDao.verificaMedicamentoId(contexto, id: rand))
        medicamento.id = rand
    }
    private func criaIdDosagem()-> Int{
        let appDel: AppDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexto : NSManagedObjectContext = appDel.managedObjectContext
        let dosagemDao = DosagemDAO()
        var rand:Int
        repeat{
            rand  = Int(arc4random_uniform(1000000))
        }while(dosagemDao.verificaDosagemId(contexto, id: rand))
        return rand
        
    }
    /**
        retorna a diferança em minutos entre duas datas
     */
    private func diferencaMinEntreDuasDatas(data1:NSDate, data2:NSDate) -> Int{
        let cal = NSCalendar.currentCalendar()
        
        
        let unit:NSCalendarUnit = .Minute
        let components = cal.components(unit, fromDate: data1, toDate: data2, options: .MatchFirst)
        
        return components.minute
    }
    /**
        Realiza calculo para saber a quantidade de vezes a pessoa deverá tomar o medicamento, com isso
     possibilitará a criação das notificações nos horarios corretos
     */
    func calculaQtdVezes(qtdDias:Int, comIntervalo intervalo:Int) -> Int{
        var qtdInt:Int = (qtdDias * 24)/intervalo
        let qtdDouble:Double = (Double(qtdDias) * 24)/Double(intervalo)
        if Double(qtdInt) == qtdDouble{
            return qtdInt
        }else{
            qtdInt += 1
            return qtdInt
        }
    }

    
    /**
        Salva medicamento e dosagem no servidor Web
     */
    func salvarMedicamentoDosagemServidor(){
        let url = UrlWS()
        var user = Usuario()
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexto: NSManagedObjectContext = appDel.managedObjectContext
        if UsuarioDAO().verificaUserLogado(contexto){
            user = UsuarioDAO().recuperaDadosUsuario(contexto)

        }


        Alamofire.request(.PUT, url.urlInsereMedicamentoUsuario(user.email), parameters:criaDicMedicamento() as? [String : AnyObject] , encoding: .JSON, headers: nil).responseJSON { (response) in
            
            if response.response?.statusCode == 200{
               let util = Util()
                util.configuraLabelInformacao(self.lblInfor, comInvisibilidade: true, comIndicador: self.activityInfo, comInvisibilidade: true, comAnimacao: false)
                self.redirecionTelaMedicamentos()
            }else{
                self.geraAlerta("Ops", mensagem: "Não foi possível cadastrar o medicamento, tente novamente mais tarde")
            }

        }
    
    }
    /**
        Redireciona para a tela de listagem de medicamentos após cadastrar os respectivos dados no servidor
     */
    func redirecionTelaMedicamentos() -> Void {
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("nextView") as! TrocaViewController
        self.presentViewController(nextViewController, animated:false, completion:nil)
        
//        //        self.tabBarController?.tabBar.hidden = true
//        //performSegueWithIdentifier("segueTabRemedio", sender: self)
////        self.geraAlerta("Acerta", mensagem: "Acertar aforma que ira voltar para a tela de medicamentos mantendo a tabbar")
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
////
//        let resultViewController = storyBoard.instantiateViewControllerWithIdentifier("trocaview") as! TrocaViewController
////        resultViewController.flagNovoMedicamento = true
////        
////        //resultViewController.medicamento = medicamento
////        
////        let navController = UINavigationController(rootViewController: resultViewController) // Creating a navigation controller with resultController at the root of the navigation stack.
//       self.presentViewController(resultViewController, animated:true, completion: nil)
    }
    /**
        Cria dicionario de medicamentos
     */
    func criaDicMedicamento() -> NSDictionary{
        let util = Util()
        let dicMedicamento = ["codigoBarras":medicamento.codBarras,
                              "nomeProduto": medicamento.nome,
                              "principioAtivo":medicamento.principioAtivo,
                              "apresentacao":medicamento.apresentacao,
                              "laboratorio":medicamento.laboratorio,
                              "classeTerapeutica":medicamento.classeTerapeutica,
                              "fotoMedicamentoString":util.convertImageToString(medicamento.fotoMedicamento),
                              "dosagem": criaDicDosagem()]
        
        return dicMedicamento
    }
    /**
        Cria dicionario de dosagem
     */
    func criaDicDosagem() -> NSDictionary{
        let util = Util()
        
//        print(campoDataInicio.text!,"<------")
//        print("Dosagem ---> ",trataQtdDosagemMedicamento(campoDosagem.text!, util: util))
        let dicDosagem = ["quantidade":trataQtdDosagemMedicamento(campoDosagem.text!, util: util),
                          "tipo": campoSwitchMedicamento.text!,
                          "dataInicioString":campoDataInicio.text!,
                          "periodo":util.valorTempoDias(campoPeriodo.text!),
                          "intervalo":util.valorIntervalo(campoIntervalo.text!)]
        
        return dicDosagem;
    }
    /**
        Método responsavel por indentificar qual o tipo de dose (comprimido, gotas ou xarope) e retornar o valor correspondente
     */
    func trataQtdDosagemMedicamento(valor: String, util: Util) -> Double{
        if campoSwitchMedicamento.text! == "Xarope"{
            return util.valorQuantidadeDoseMlAndGotas(campoDosagem.text!)
        }else if campoSwitchMedicamento.text! == "Comprimido"{
            return util.valorQuantidadeDoseComprimido(campoDosagem.text!)
        }else{
            return util.valorQuantidadeDoseMlAndGotas(campoDosagem.text!)
        }
    }
    /**
        gera alerta
     */
    func geraAlerta(title: String, mensagem: String){
        let alerta = UIAlertController(title: title, message: mensagem, preferredStyle: .Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alerta, animated: true, completion: nil)
        
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
        // popula array gotas
        arrayGotas.append("")
        for i in 1...99{
            arrayGotas.append("\(i) Gotas")
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
        }else if pickerView.tag == 4{
            return arrayTipoMedicamento.count
        }else if pickerView.tag == 5{
            return arrayGotas.count
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
        }else if pickerView.tag == 4{
            return arrayTipoMedicamento[row]
        }else if pickerView.tag == 5{
            return arrayGotas[row]
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
        }else if pickerView.tag == 4{
            campoSwitchMedicamento.text = arrayTipoMedicamento[row]
        }else if pickerView.tag == 5{
            campoDosagem.text = arrayGotas[row]
        }
        
        //  campoSexo.text = arraySexo[row]
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        
       configuraPosicionamentoScroll(textField)
       selecionaDataInicio(textField)
        defineTipoDosagemMedicamento(textField)
      
    }
    /**
        Define qual o carrosseu sera apresentado com as dosagens devidas, isso contará com qual 
     o tipo de medicamento o usuário selecionou
     */
    func defineTipoDosagemMedicamento(textfield: UITextField){
        
        if textfield == campoDosagem{
            
            if campoSwitchMedicamento.text! == "Xarope"{
                campoDosagem.inputView = pickerDosagem
            }else if campoSwitchMedicamento.text! == "Comprimido"{
                campoDosagem.inputView = pickerDosagemComprimido
            }else if campoSwitchMedicamento.text! == "Gotas"{
                campoDosagem.inputView = pickerQtdGotas
            }else{
                geraAlerta("", mensagem: "O tipo de medicamento deve ser informado!")
            }
        }
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
    
    
    private func displayNotificationsDisabled() {
        let alertController = UIAlertController(
            title: "Notificações desabilitada para o App Minha Farmácia",
            message: "Ative as notificações em Configurações -> Notificações -> Minha Farmácia",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
