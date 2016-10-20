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

    @IBOutlet weak var collectionView: UICollectionView!
    var imgArray = [UIImage]()
    var nomes = ["Kleiton","Anna","Meg","Diná","Arnaldo"]
    var user = Usuario.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Configurando a primeira imagem
        let imgPlus = UIImageView()
        imgPlus.image = UIImage(named: "plus2.png")
        imgArray.append(imgPlus.image!)
        buscaReceitaServidor()
//        grabPhotos()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        self.navigationItem.title = "Receitas"
        
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
    /**
     
     */
    func buscaReceitaServidor(){
        let url = UrlWS();
        Alamofire.request(.GET, url.urlBuscaReceitaUsuario(user.email)).responseJSON { (response) in
            if let JSON = response.result.value{
                if response.response?.statusCode == 200{
                    if let receitas:NSArray = (JSON["receita"] as? NSArray){
                        for r in receitas{
                            self.user.receitas.append(self.populaReceita(r))
                        }
                    }else{
                        let dic = JSON["receita"]!
                        self.user.receitas.append(self.populaReceita(dic!))
                    }
                    for r in self.user.receitas{
                        self.imgArray.append(r.fotoReceita)
                        self.nomes.append("Leia Mais")
                    }
                    self.collectionView.reloadData()
                    // aqui
//
//                        
//                        for i in medicamentos{
//                            self.user.medicamento.append(self.populaMedicamento(i))
//                        }//fecha o for
//                    }else{
//                        let dic = JSON["medicamento"]!
//                        self.user.medicamento.append(self.populaMedicamento(dic!))
//                    }
//                    for remedio in self.user.medicamento{
//                        self.imgArray.append(remedio.fotoMedicamento)
//                        self.nomes.append(remedio.nome)
//                    }
//                    self.collectionView.reloadData()
                }
            }else{
                self.showAlert("Ops!", msg: "Tivemos problema com a conexão, tente novamente mais tarde", titleBtn: "ok")
            }
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
            print("TRATAR A DATA AQUI \(dataCadastro)")
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
        
        if indexPath.row == 0{
            cell.img.image = imgArray[indexPath.row]
            cell.lblData.hidden = true
            cell.lblFundo.hidden = true
            cell.img.contentMode = .Center
        }else{
            cell.img.image = imgArray[indexPath.row]
            cell.lblData.text = nomes[indexPath.row - 1]
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{
            performSegueWithIdentifier("cadastraReceita", sender: self)

        }else{
            print("Receitas")
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

    
}
