//
//  MedicamentoViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 17/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import Photos
import Alamofire
import CoreData
class MedicamentoViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    @IBOutlet weak var collectionView: UICollectionView!
    var imgArray = [UIImage]()
    var nomes = [String]() //nomes dos medicamentos
    let util = Util()
    
    var user = Usuario.sharedInstance
    
    var flagNovoMedicamento = false
    
    var labeli:UILabel = UILabel()
    
    @IBOutlet weak var activityInfo: UIActivityIndicatorView!
    @IBOutlet weak var lblInfo: UILabel!
    
    var medicamento = Medicamento.medicamentoSharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Medicamentos"
        self.navigationController?.navigationBar.topItem?.title = "Medicamentos"
        configuraLabelInfo()
        
        apresentacaoAlertaNovoMedicamento()
    }
    func apresentacaoAlertaNovoMedicamento(){
        if flagNovoMedicamento == true{
            flagNovoMedicamento = false
            geraAlerta("Sucesso", mensagem: "Novo Medicamento cadastrado com sucesso!")
        }
    }
    
    func configuraLabelInfo(){
        util.configuraLabelInformacao(lblInfo, comInvisibilidade: false , comIndicador: activityInfo, comInvisibilidade: false, comAnimacao: true)
    }
    func configuracaoTableView(){
        imgArray.removeAll()
        nomes.removeAll()
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexto: NSManagedObjectContext = appDel.managedObjectContext
        let mDao = MedicamentoDAO()
        
        self.collectionView.delegate = self
        collectionView.dataSource = self

        
        
        let imgPlus:UIImageView = UIImageView()
        imgPlus.image = UIImage(named: "plus2.png")
        imgArray.append(imgPlus.image!)
        /// recupear os medicamentos da base local ou do servidor
        if !mDao.verificaExistenciaMedicamento(contexto){
            configuraLabelInfo()
            buscaMedicamentosServidor()
        }else{
            let medicamentosAux = mDao.recuperarMedicamentos(contexto)
            let util = Util()
            user.medicamento.removeAll()
            user.medicamento = medicamentosAux
            
           
            for remedio in medicamentosAux{
//                print(remedio.nome)
//                print(remedio.codBarras)
                self.imgArray.append(remedio.fotoMedicamento)
                self.nomes.append(remedio.nome)
            }
            //collectionView.reloadData()
            let verificaConexao = VerificarConexao()
            if mDao.buscaMedicamentoNaoSicronizados(contexto).count != 0 && verificaConexao.isConnectedToNetwork(){
                acaoSicronizarMedicamentoServidor("Sicronizar", msg: "Você tem medicamentos que não estão sicronizados, deseja sicronizar agora?", contexto: contexto)
            }//
            util.configuraLabelInformacao(lblInfo, comInvisibilidade: true, comIndicador: activityInfo, comInvisibilidade: true, comAnimacao: false)
        }
       // self.collectionView.reloadData()
        
        
    }
    
    /**
        método responsavel por pegar o desejo do usuario e sicronizar os dados
     */
    func acaoSicronizarMedicamentoServidor(title:String, msg: String, contexto:NSManagedObjectContext){
        // Create the alert controller
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Sim", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            let util = Util()
            util.configuraLabelInformacao(self.lblInfo, comInvisibilidade: false, comIndicador: self.activityInfo, comInvisibilidade: false, comAnimacao: true)
            
            let mDao = MedicamentoDAO()
            let medicamentos = mDao.buscaMedicamentoNaoSicronizados(contexto)
            let qtdUp = medicamentos.count
            var flagUp = 0
            let url = UrlWS()
            for m in medicamentos{
                Alamofire.request(.PUT,url.urlInsereMedicamentoUsuario(self.user.email),parameters: self.criaDicMedicamento(m) as? [String : AnyObject],encoding: .JSON).responseJSON { (response) in
                    
                    if response.response?.statusCode == 200{
                        flagUp += 1
                        if flagUp == qtdUp{
                            util.configuraLabelInformacao(self.lblInfo, comInvisibilidade: true, comIndicador: self.activityInfo, comInvisibilidade: true, comAnimacao: false)
                            self.geraAlerta("Sucesso", mensagem: "Seus medicamentos foram sicronizados com sucesso")
                            mDao.atualizaMedicamentoSicronizado(contexto)
                        }
//                        self.redirecionTelaMedicamentos()
                    }else{
                        self.geraAlerta("Ops", mensagem: "Não foi possível cadastrar o medicamento, tente novamente mais tarde")
                    }
                    
                }
            }
            
        }
        let cancelAction = UIAlertAction(title: "Mais tarde", style: UIAlertActionStyle.Destructive) {
            UIAlertAction in
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    /**
     Salva medicamento e dosagem no servidor Web
     */
    
    
    /**
     Cria dicionario de medicamentos
     */
    func criaDicMedicamento(medicamentoAux: Medicamento) -> NSDictionary{
        let util = Util()
        let dicMedicamento = ["codigoBarras": medicamentoAux.codBarras,
                              "nomeProduto": medicamentoAux.nome,
                              "principioAtivo" : medicamentoAux.principioAtivo,
                              "apresentacao": medicamentoAux.apresentacao,
                              "laboratorio": medicamentoAux.laboratorio,
                              "classeTerapeutica" : medicamentoAux.classeTerapeutica,
                              "fotoMedicamentoString" : util.convertImageToString(medicamentoAux.fotoMedicamento),
                              "dosagem":criaDicDosagem(medicamentoAux.dosagemMedicamento)]
        //
//        let dicMedicamento = ["codigoBarras": medicamentoAux.codBarras,
//                              "nomeProduto": medicamentoAux.nome,
//                              "principioAtivo":medicamentoAux.principioAtivo,
//                              "apresentacao":medicamentoAux.apresentacao,
//                              "laboratorio":medicamentoAux.laboratorio,
//                              "classeTerapeutica":medicamentoAux.classeTerapeutica,
//                              "fotoMedicamentoString":util.convertImageToString(medicamentoAux.fotoMedicamento),
//                              "dosagem": criaDicDosagem(medicamentoAux.dosagemMedicamento)]
//        
       return dicMedicamento
    }
    /**
     Cria dicionario de dosagem
     */
    func criaDicDosagem(dosagem: DosagemMedicamento)->NSDictionary {
        let util = Util()
        print(dosagem.dataInicio)
        print(dosagem.intervaloDose)
        print(dosagem.dosagem)
        print(dosagem.tipoMedicamento)
        let dicDosagem = ["quantidade":dosagem.quantidade,
                          "tipo":dosagem.tipoMedicamento,
                          "dataInicioString" : "+\(dosagem.dataInicio)",
                          "periodo": dosagem.periodoTratamento,
                          "intervalo":dosagem.intervaloDose]
        return dicDosagem
//
//        let dicDosagem = ["quantidade":trataQtdDosagemMedicamento(dosagem.text!, util: util),
//                          "tipo": campoSwitchMedicamento.text!,
//                          "dataInicioString":campoDataInicio.text!,
//                          "periodo":util.valorTempoDias(campoPeriodo.text!),
//                          "intervalo":util.valorIntervalo(campoIntervalo.text!)]
//        
//        return dicDosagem;
    }

    
    
    override func viewWillAppear(animated: Bool) {
        configuracaoTableView() //configura a collecion
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.translucent = false
        
        
        navigationBarAppearace.barTintColor = UIColor(red: 53.0/255.0, green: 168.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.title = "Medicamentos"
        //collectionView.reloadData()
    }
    func goBack(){
        dismissViewControllerAnimated(true, completion: nil)
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
    
    /**
     O método irá buscar os dados do medicamento que estão na base de dados no servidor
     */
    func buscaMedicamentosServidor(){
        print("verificar a linha de baixo caso ocorra erro de sumir os medicamentos")
        user.medicamento.removeAll()
        let url = UrlWS()
        
        
        Alamofire.request(.GET, url.urlBuscaMedicamentoUsuario(user.email)).responseJSON { (response) in
            if let JSON = response.result.value{
                if JSON.count != nil{
                    if let medicamentos:NSArray = (JSON["medicamento"] as? NSArray){
                        
                        
                        for i in medicamentos{
                            self.user.medicamento.append(self.populaMedicamento(i))
                        }//fecha o for
                    }else{
                        let dic = JSON["medicamento"]!
                        self.user.medicamento.append(self.populaMedicamento(dic!))
                    }
                    for remedio in self.user.medicamento{
                        self.salvaMedicamentoBaseLocal(remedio)
                        self.imgArray.append(remedio.fotoMedicamento)
                        self.nomes.append(remedio.nome)
                    }
                }else{
                    print("deu ruim em algo")
                }
             self.collectionView.reloadData()
            }
            self.util.configuraLabelInformacao(self.lblInfo, comInvisibilidade: true, comIndicador: self.activityInfo, comInvisibilidade: true, comAnimacao: false)
        }
    }
    /**
     Método responsável por inserir medicamento na base de dados local
     
     */
    func salvaMedicamentoBaseLocal(medicamento: Medicamento){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexto: NSManagedObjectContext = appDel.managedObjectContext
        let mDao = MedicamentoDAO()
        mDao.gravarMedicamento(contexto, medicamento: medicamento, sicronizado: true)
    }
    /**
     popula Medicamento com os dados do Servidor
     */
    func populaMedicamento(medicamento: AnyObject)  -> Medicamento{
        
        let medicamentoAux = Medicamento()
        //        print(medicamento)
        if let idMedicamento = medicamento["id"] as? String{
            medicamentoAux.id = Int(idMedicamento)
        }
        if let apresentacao = medicamento["apresentacao"] as? String{
            medicamentoAux.apresentacao = apresentacao
        }
        if let codBarras = medicamento["codigoBarras"] as? String{
            medicamentoAux.codBarras = codBarras
        }
        if let nome = medicamento["nomeProduto"] as? String{
            medicamentoAux.nome = nome
        }
        if let principioAtivo = medicamento["principioAtivo"] as? String{
            medicamentoAux.principioAtivo = principioAtivo
        }
        if let laboratorio = medicamento["laboratorio"] as? String{
            medicamentoAux.laboratorio = laboratorio
        }
        if let classeTerapeutica = medicamento["classeTerapeutica"] as? String{
            medicamentoAux.classeTerapeutica = classeTerapeutica
        }
        if let fotoString = medicamento["fotoMedicamentoString"] as? String{
            var img = UIImage();
            img = self.util.convertStringToImage(fotoString)
            medicamentoAux.fotoMedicamento = img
            
        }
        
        let dicDosagem = medicamento["dosagem"]!
        medicamentoAux.dosagemMedicamento = populaDosagemMedicamento(dicDosagem!)
        return medicamentoAux
        
    }
    /**
     Popula uma entidade Dosagem com os dados que vem do Servidor
     */
    func populaDosagemMedicamento(dosagem: AnyObject) -> DosagemMedicamento{
        let dosagemAux = DosagemMedicamento()
        if let id = Int((dosagem["id"] as? String)!){
            dosagemAux.id = id
        }
        if let intervalo = Int((dosagem["intervalo"] as? String)!){
            dosagemAux.intervaloDose = intervalo
        }
        if let periodo = Int((dosagem["periodo"] as? String)!){
            dosagemAux.periodoTratamento = periodo
        }
        if let quantidade = Double((dosagem["quantidade"] as? String)!){
            dosagemAux.quantidade = quantidade
        }
        if let tipo = dosagem["tipo"] as? String{
            dosagemAux.tipoMedicamento = tipo
        }
        if let dataString = dosagem["dataInicio"] as? String{
            var dataCadastro = dataString[dataString.startIndex.advancedBy(0)...dataString.startIndex.advancedBy(15)]
            dataCadastro = dataCadastro.stringByReplacingOccurrencesOfString("T", withString: " ")
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateFormatter.locale = NSLocale.currentLocale()
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            let date2:NSDate!
            date2 = dateFormatter.dateFromString(dataCadastro)
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            
            if let unwrappedDate = date2 {
                dosagemAux.dataInicio = unwrappedDate
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                dosagemAux.notificacoes = criaNotificacoes(dataCadastro, comFormato: dateFormatter, comIntervalo: dosagemAux.intervaloDose, totalDias: dosagemAux.periodoTratamento, idDosagem: dosagemAux.id)
                print("---->",dateFormatter.stringFromDate(unwrappedDate))
            }
            
        }
        return dosagemAux
    }
    
    /**
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
                    
                    LocalNotificationHelper().scheduleLocal("", alertDate: date!, corpoNotificacao: "Hora do remédio", medicamentoId: idDosagem, numeroDose: i)
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

    
    func grabPhotos(){
        let imgManager = PHImageManager.defaultManager()
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        requestOptions.deliveryMode = .HighQualityFormat
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
        if let fetchResult:PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOption){
            if fetchResult.count > 0{
                for i in 0..<fetchResult.count{
                    imgManager.requestImageForAsset(fetchResult.objectAtIndex(i) as! PHAsset, targetSize: CGSize(width: 200, height: 200), contentMode: .AspectFit, options: requestOptions, resultHandler: { (image, error) in
                        self.imgArray.append(image!)
                    })
                }
                
            }else{
                print("voce nao tem fotos")
                collectionView?.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     Números de sessoes no collection view
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    /**
     Numero de celulas
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    /**
     Configurar cada celula
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MedicamentoCollectionViewCell
        if indexPath.row == 0{
            cell.img.image = imgArray[indexPath.row]
            cell.labelFundo.hidden = true
            cell.labelData.hidden = true
            cell.img.contentMode = .Center
            
        }else{
            let dataAtual = NSDate()
            let arr = user.medicamento[indexPath.row - 1].dosagemMedicamento.notificacoes
            
            let next =   verificaProximaDoseMedicamento(arr,dataAtual: dataAtual)
            
            let pendente = verificaPendenciasAteDataAtual(user.medicamento[indexPath.row - 1].dosagemMedicamento.id, dataAtual: dataAtual)
            
            
            
            
            cell.img.image = imgArray[indexPath.row] // coloca a foto na celula
            print("=============")
            if diferencaMinEntreDuasDatas(NSDate(), data2: next) == 0{
                if pendente {
                    cell.imgIndicativaAtraso.image = UIImage(named: "red_marker.png")
                }else{
                    cell.imgIndicativaPontual.image = UIImage(named: "green_marker.png")
                }
                cell.labelData.text = "Concluido" // coloca concluido no medicamento q ja passou por todo o tratamento
            }else{
                if pendente{
                    cell.imgIndicativaAtraso.image = UIImage(named: "red_marker.png")
                }else{
                    cell.imgIndicativaPontual.image = UIImage(named: "green_marker.png  ")
                }
                cell.labelData.text = Util().formataDataHoraPadrao(next) //coloca a proxima data da dose
            }
        }
        return cell
    }
    /**
        Esse método irá procurar e encontrar qual a proxima notificacao do medicamento
     */
    func verificaProximaDoseMedicamento(notificacoes:[Notificacao], dataAtual:NSDate) -> NSDate{
        var nextNotification : NSDate = NSDate()
        for n in notificacoes{
            let diferenca = diferencaMinEntreDuasDatas(dataAtual, data2: n.dataNotificacao)
            if diferenca > 0 {
                nextNotification = n.dataNotificacao
                break
            }
        }
        return nextNotification
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
     Esse método irá procurar e encontrar qual a notificacao anteriro
     */
    func verificaDoseAnterior(notificacoes:[Notificacao], dataAtual:NSDate) -> NSDate{
        var nextNotification : NSDate = NSDate()
        var i:Int = 0
        for n in notificacoes{
            let diferenca = diferencaMinEntreDuasDatas(dataAtual, data2: n.dataNotificacao)
            if diferenca > 0 {
                if ((i - 1) >= 0){
                    nextNotification = notificacoes[i - 1].dataNotificacao
                }
                break
            }
         i += 1
        }
        return nextNotification
    }

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{
            performSegueWithIdentifier("cadastrarMedicamento", sender: self)
            
            
        }else{
            
            let userDefautls = NSUserDefaults.standardUserDefaults()
            userDefautls.setInteger((indexPath.row) - 1, forKey: "posicaoMedicamento")
            medicamento = user.medicamento[(indexPath.row) - 1]
            performSegueWithIdentifier("detalhamentoRemedio", sender: self)
            
        }
    }
    
    /**
     tirar a barra de status do iphone
     */
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    /**
     Definir o tamanho das celulas e a quantidade
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 3 - 1
        
        return CGSize(width: width, height: width)
        
    }
    /**
     Definir o espacamento entre as celular
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    /*if let destination = segue.destinationViewController as? RequestViewController{
     destination.requestLocation = locations[(tableView.indexPathForSelectedRow?.row)!]
     destination.requestUserName = userNames[(tableView.indexPathForSelectedRow?.row)!]
     }*/
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
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

    @IBAction func addItem(sender: AnyObject) {
        print("clicou")
        self.collectionView.reloadData()
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("nextView") as! TrocaViewController
//        nextViewController.tipoDeMsg = 3
//        self.presentViewController(nextViewController, animated:false, completion:nil)
    }
    

}
