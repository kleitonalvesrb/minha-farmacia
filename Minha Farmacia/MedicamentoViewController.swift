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
        
        
        self.title = "Remédios"
        self.navigationController?.navigationBar.topItem?.title = "Remédios"
        configuraLabelInfo()
        
        configuracaoTableView()
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
            user.medicamento = medicamentosAux
            for remedio in self.user.medicamento{
                self.imgArray.append(remedio.fotoMedicamento)
                self.nomes.append(remedio.nome)
            }
            util.configuraLabelInformacao(lblInfo, comInvisibilidade: true, comIndicador: activityInfo, comInvisibilidade: true, comAnimacao: false)
        }
        
        
    }
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.translucent = false
        
        
        
        navigationBarAppearace.barTintColor = UIColor(red: 53.0/255.0, green: 168.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.title = "Medicamentos"
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
                    self.collectionView.reloadData()
                }else{
                    print("deu ruim em algo")
                }
                
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
        mDao.gravarMedicamento(contexto, medicamento: medicamento)
    }
    /**
     popula Medicamento com os dados do Servidor
     */
    func populaMedicamento(medicamento: AnyObject)  -> Medicamento{
        
        let medicamentoAux = Medicamento()
        //        print(medicamento)
        if let idMedicamento = medicamento["id"] as? String{
            medicamentoAux.id = Int(idMedicamento)
            print(medicamentoAux.id,"<-------- id")
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
        print("FALTA ACERTAR A DATA NO SERVIDOR E BANCO DE DADOS")
        print("----------")
        
        return dosagemAux
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
            cell.img.image = imgArray[indexPath.row]
            cell.labelData.text = nomes[indexPath.row - 1]
        }
        return cell
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
    

}
