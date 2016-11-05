//
//  ReceitaViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 17/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import Photos
import Alamofire
class ReceitaViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var imgArray = [UIImage]()
    var nomes = [String]()
    var user = Usuario.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuracaoTableView()
//        grabPhotos()
    }
    
    func configuracaoTableView(){
        let util = Util()
        util.configuraLabelInformacao(lblInfo, comInvisibilidade: false, comIndicador: activity, comInvisibilidade: false, comAnimacao: true)

        self.collectionView.delegate = self
        collectionView.dataSource = self
        buscaReceitaServidor()
        
//        let imgPlus:UIImageView = UIImageView()
//        imgPlus.image = UIImage(named: "plus2.png")
//        imgArray.append(imgPlus.image!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        self.navigationItem.title = "Receitas"
        
    }


    func buscaReceitaServidor(){
        user.receitas.removeAll()
        let url = UrlWS();
        Alamofire.request(.GET, url.urlBuscaReceitaUsuario(user.email)).responseJSON { (response) in
            if let JSON = response.result.value{
                if response.response?.statusCode == 200{
                    if JSON.count != nil{
                        
                        if let receitas:NSArray = (JSON["receita"] as? NSArray){
                            print("QTD -> \(receitas.count)")
                            for r in receitas{
                                self.user.receitas.append(self.populaReceita(r))
                            }
                        }else{
                            let dic = JSON["receita"]!
                            self.user.receitas.append(self.populaReceita(dic!))
                        }
                        let util = Util()
                        print("AKI -> \(self.user.receitas.count)")
                        print("qtd array alo -> \(self.imgArray.count)")
                        for receita in self.user.receitas{
                            self.imgArray.append(receita.fotoReceita)
                            self.nomes.append(util.formataDataPadrao(receita.dataCadastro))
                        }
                        print("tamanho do arrray ---->\(self.imgArray.count)")

                        self.collectionView.reloadData()
                    }
                    print("tamanho do arrray ---->\(self.imgArray.count)")

                    self.collectionView.reloadData()

                }
            }else{
                self.showAlert("Ops!", msg: "Tivemos problema com a conexão, tente novamente mais tarde", titleBtn: "ok")
            }
            let util = Util()
            util.configuraLabelInformacao(self.lblInfo, comInvisibilidade: true, comIndicador: self.activity, comInvisibilidade: true, comAnimacao: false)
        }
    }
    /**
     popula Receita com os dados do Servidor
     */
    func populaReceita(receita: AnyObject)  -> Receita{
        let receitaAux = Receita()
        let util = Util()
        if let descricao = receita["descricao"] as? String{
            receitaAux.descricao = descricao
        }
        if let fotoString = receita["fotoReceitaString"] as? String{
            var img = UIImage();
            img = util.convertStringToImage(fotoString)
            receitaAux.fotoReceita = img
            
        }
        if let dataCadastro = receita["dataCadastroReceita"] as? String{
            receitaAux.dataCadastro = util.formataDataCadastroReceita(dataCadastro)
        }
        return receitaAux
        
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ReceitaCollectionViewCell
            print("tamanho do arrray ---->\(imgArray.count)")
//        if indexPath.row == 0{
//            cell.img.image = imgArray[indexPath.row]
//            cell.lblData.hidden = true
//            cell.lblFundo.hidden = true
//            cell.img.contentMode = .Center
//        }else{
            cell.img.image = imgArray[indexPath.row]
            cell.lblData.text = nomes[indexPath.row]
//        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        if indexPath.row == 0{
//            performSegueWithIdentifier("cadastraReceita", sender: self)

//        }else{
            let userDefautls = NSUserDefaults.standardUserDefaults()
            userDefautls.setInteger((indexPath.row), forKey: "posicaoReceita")
//            medicamento = user.medicamento[(indexPath.row) - 1]
            performSegueWithIdentifier("detalhaReceita", sender: self)
//        }
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
    @IBAction func addReceita(sender: AnyObject) {
        performSegueWithIdentifier("cadastraReceita", sender: self)

    }
    @IBOutlet weak var addReceita: UIBarButtonItem!
    /**
     Definir o espacamento entre as celular
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }

    
}
