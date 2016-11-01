//
//  TableDetalhaMedicamentoViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 28/10/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import CoreData
class TableDetalhaMedicamentoViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var imgMedicamento: UIImageView!
    var medicamento = Medicamento()
    
    @IBOutlet weak var tableView: UITableView!
    struct DadosMedicamento{
        var nomeSecao: String!
        var valores :[String]!
    }
    var arrayDadosMedicamento = [DadosMedicamento]()
    var arrayTitulos = [String]()
    var arrayNotificacoesAtrasadas = [Notificacao]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detalhamento"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        populaDadosMedicamento()
    }
    /**
        Popula o array responsavel por apresentar os dados do medicamento do usuario na tabela dinamica
    */
    func populaDadosMedicamento(){
        arrayNotificacoesAtrasadas.removeAll()
        arrayTitulos.removeAll()
        arrayDadosMedicamento.removeAll()
        medicamento = buscaMedicamento()
        let notificacoes = verificaNotificacaoNaoConfirmada(buscaNotificacoesDosagemMedicamento(medicamento.dosagemMedicamento.id))
        arrayDadosMedicamento = [DadosMedicamento(nomeSecao: "Dados do Medicamento", valores: populaArrayDadosMedicamento()),
                                 DadosMedicamento(nomeSecao: "Atrasos", valores: devolveNotificacaoAtrasoString(notificacoes))]
        arrayTitulos = criaArrayTitulos()
        imgMedicamento.image = medicamento.fotoMedicamento
    }
    /**
        Preenche uma array com todos os dados do medicamento
     */
    func populaArrayDadosMedicamento()-> Array<String>{
        var arrayDados = [String]()
        arrayDados.append("\(Util().formataPadraoCompleto("\(medicamento.dosagemMedicamento.dataInicio)"))")
        arrayDados.append("\(medicamento.dosagemMedicamento.intervaloDose) Hora(s)")
        arrayDados.append("\(medicamento.dosagemMedicamento.periodoTratamento) Dia(s) ")
        arrayDados.append("\(medicamento.dosagemMedicamento.quantidade) \(tipoMedicamentoApresentacaoDosagem(medicamento.dosagemMedicamento.tipoMedicamento))")
        if medicamento.codBarras.characters.count > 2{
            arrayDados.append("Detalhar")
        }
        return arrayDados
    }
    /*
     items = [["Inicio em :    \(medicamento.dosagemMedicamento.dataInicio)",
     "Intervalo:      \(medicamento.dosagemMedicamento.intervaloDose):00 Horas",
     "Período:        \(medicamento.dosagemMedicamento.periodoTratamento) Dias",
     "Dosagem:       \(medicamento.dosagemMedicamento.quantidade) \(tipoMedicamentoApresentacaoDosagem(medicamento.dosagemMedicamento.tipoMedicamento))"]]
     
     */
    func criaArrayTitulos() ->Array<String>{
        var arrayTitulos = [String]()
        arrayTitulos.append("Data de início")
        arrayTitulos.append("Intervalo entre consumo")
        arrayTitulos.append("Periodo de Tratamento")
        arrayTitulos.append("Dosagem")
        if medicamento.codBarras.characters.count > 2{
            arrayTitulos.append("Descrição Técnica")
        }
        return arrayTitulos
    }
    func tipoMedicamentoApresentacaoDosagem(tipo: String) -> String{
        if medicamento.dosagemMedicamento.tipoMedicamento == "Xarope"{
            return " ML"
        }else if medicamento.dosagemMedicamento.tipoMedicamento == "Gotas"{
            return " Gotas"
        }else{
            return " Comprimido"
        }
    }
    
    /**
        Devolve uma lista de notificacoes, apenas as notificacoes que estiver em atraso
     */
    func devolveNotificacaoAtrasoString(notificacoes: Array<Notificacao>) ->Array<String>{
        var horarioNotificacaoAtrasoString = [String]()
        let dataAtual = NSDate()
        for n in notificacoes{
            if diferencaMinEntreDuasDatas(dataAtual, data2: n.dataNotificacao) <= 0{
                arrayNotificacoesAtrasadas.append(n)
                horarioNotificacaoAtrasoString.append(Util().formataPadraoCompleto("\(n.dataNotificacao)"))
            }
        }
        return horarioNotificacaoAtrasoString
    }
    
    
    
    /**
        Busca o medicamento com base no medicamento selecionado na tela anterior
     */
    func buscaMedicamento()->Medicamento{
        let userDefautls = NSUserDefaults.standardUserDefaults()
        var posicaoArray = -1
        if let posicaoArrayMedicamento = userDefautls.stringForKey("posicaoMedicamento"){
            posicaoArray = Int(posicaoArrayMedicamento)!
        }else{
            print("DEU RUIM")
        }
        let user = Usuario.sharedInstance
        return user.medicamento[posicaoArray]
    }
    /**
        Busca as notificacoes de uma dosagem especifica
     */
    func buscaNotificacoesDosagemMedicamento(idDosagem:Int) -> Array<Notificacao>{
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexto: NSManagedObjectContext = appDel.managedObjectContext
        return NotificacaoDAO().buscaNotificacaoIdDosagem(contexto, idDosagem: idDosagem)
    }
    /**
        verifica se essas notificacoes foram confirmadas
     */
    func verificaNotificacaoNaoConfirmada(notificacoes: Array<Notificacao>) -> Array<Notificacao>{
        var notificacoesPendentes = [Notificacao]()
        for n in notificacoes{
            if n.confirmado != 1{
                notificacoesPendentes.append(n)
            }
        }
        return notificacoesPendentes
    }
    /**
     Retorna true quando a dosagem nao esta confirmada
     */
    func verificaPendenciasAteDataAtual(idDosagem: Int, dataAtual:NSDate) -> Bool{
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexto: NSManagedObjectContext = appDel.managedObjectContext
        let notificacoes = NotificacaoDAO().buscaNotificacaoIdDosagem(contexto, idDosagem: idDosagem)
        for i in notificacoes{
            if diferencaMinEntreDuasDatas(dataAtual, data2: i.dataNotificacao) <= 0 {
                if i.confirmado != 1{
                    return true
                }
            }
        }
        return false
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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as! CellDetalhamentoTableViewCell
        
        if arrayDadosMedicamento[indexPath.section].nomeSecao.lowercaseString == "Dados do Medicamento".lowercaseString{
            //adc seta
            if medicamento.codBarras.characters.count > 2 && arrayTitulos[indexPath.row].lowercaseString == "Descrição Técnica".lowercaseString{
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            cell.lblTitulo.text = arrayTitulos[indexPath.row]
        }else{
            cell.lblTitulo.text = "Atraso em ..."
        }
        cell.lblConteudo.text = arrayDadosMedicamento[indexPath.section].valores[indexPath.row]
        
        return cell

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objectArray[section].objects.count
        return arrayDadosMedicamento[section].valores.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return objectArray.count
        return arrayDadosMedicamento.count
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return objectArray[section].sectionName
        return arrayDadosMedicamento[section].nomeSecao
    }
 
    /*
        Método responsavel por trocar a a fonte do cabeçalho da sessao
     
     */
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let title = UILabel()
        title.font = UIFont(name: "Futura", size: 20)!
        title.textColor = UIColor(red: 53.0/255.0, green: 168.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font=title.font
        header.textLabel?.textColor=title.textColor
        header.textLabel?.center.x = self.view.frame.width
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0{
            if arrayTitulos[indexPath.row].lowercaseString == "Descrição Técnica".lowercaseString {
                let userDefautls = NSUserDefaults.standardUserDefaults()
                let user = Usuario.sharedInstance
                let id = user.medicamento[indexPath.row].id
                userDefautls.setInteger(id, forKey: "posicaoMedicamentoDescTec")
                        
                
                performSegueWithIdentifier("segueDescTec", sender: self)
            }
        }
        if indexPath.section == 1{
            let data = arrayNotificacoesAtrasadas[indexPath.item].dataNotificacao
            showAlert("Atraso", msg: " Confirmar que tomou o medicamento na data \(Util().formataPadraoCompleto("\(data)"))", titleBtn: "ok")
        }
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 1{
            let confirmar = UITableViewRowAction(style: .Normal, title: "Já Tomei") { action, index in
                var arr = self.arrayDadosMedicamento[indexPath.section].valores
                self.arrayDadosMedicamento[indexPath.section].valores = nil
                arr.removeAtIndex(indexPath.row)
                self.arrayDadosMedicamento[indexPath.section].valores = arr
                var arrayPath = [NSIndexPath]()
                arrayPath.append(indexPath)
                self.confirmaTomouDoseMedicamento((self.arrayNotificacoesAtrasadas[indexPath.row].id))

                self.arrayNotificacoesAtrasadas.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths(arrayPath, withRowAnimation: UITableViewRowAnimation.Left)

//                print(self.arrayNotificacoesAtrasadas.count)
//                self.arrayNotificacoesAtrasadas.removeAtIndex(indexPath.row)
//                print(self.arrayNotificacoesAtrasadas.count)
//                var arrayPath = [NSIndexPath]()
//                arrayPath.append(indexPath)
//                print(arrayPath.count)
//                tableView.deleteRowsAtIndexPaths(arrayPath, withRowAnimation: UITableViewRowAnimation.Left)
                //self.tableView.deleteRows(at: [indexPath], with: .left)
            }
            
            confirmar.backgroundColor = UIColor.blueColor()
            return [confirmar]
        }

        return nil
    }
    func confirmaTomouDoseMedicamento(idNotificacao: Int){
        print("---->\(idNotificacao)<----")
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexto: NSManagedObjectContext = appDel.managedObjectContext
        NotificacaoDAO().confirmaDosagem(contexto, idNotificacao: idNotificacao)
    }

    
    /**
     Apresenta alerta na tela
     */
    func showAlert(title: String, msg: String, titleBtn: String){
        let alerta = UIAlertController(title: title, message:msg, preferredStyle: .Alert)
        alerta.addAction(UIAlertAction(title: titleBtn, style: .Default, handler: { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alerta, animated: true, completion: nil)
    }
    
    func confirmarTomou(idNotificacao: Int, data: String){
        let alerta = UIAlertController(title: "Confirmar", message: "Confirmar que tomou a dose \(data)", preferredStyle: .ActionSheet)
        let confirmar = UIAlertAction(title: "Confirmar", style: .Default) { (alert: UIAlertAction!) in
            self.confirmaTomouDoseMedicamento(idNotificacao)
            self.removeNotificacaoArray(idNotificacao)
            self.tableView.reloadData()
        }
  
        let cancel = UIAlertAction(title: "Cancelar", style: .Cancel) { (alert: UIAlertAction!) in
            //self.geraAlerta("Foto de Perfil", mensagem: "Tudo bem, você poderá escolher uma foto mais tarde!")
        }
        alerta.addAction(confirmar)
       
        alerta.addAction(cancel)
        
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }
    func removeNotificacaoArray(idNotificacao: Int){
        var arrAux = [Notificacao]()
        for i in arrayNotificacoesAtrasadas{
            if i.id != idNotificacao{
                arrAux.append(i)
            }
        }
        arrayNotificacoesAtrasadas.removeAll()
        arrayNotificacoesAtrasadas = arrAux
        
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
