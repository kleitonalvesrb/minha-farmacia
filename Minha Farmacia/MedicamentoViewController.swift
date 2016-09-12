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
class MedicamentoViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    @IBOutlet weak var collectionView: UICollectionView!
    var imgArray = [UIImage]()
    var nomes = [String]() //["Kleiton","Anna","Meg","Dina","Arnaldo","Thiago","Franciele","Kelly", "Thaynara"]
    let util = Util()
    var user = Usuario.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        collectionView.dataSource = self
        buscaMedicamentos()
        
        let imgPlus:UIImageView = UIImageView()
        imgPlus.image = UIImage(named: "plus2.png")
        imgArray.append(imgPlus.image!)
    }
    
    override func viewWillAppear(animated: Bool) {
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.translucent = false
        
        
        navigationBarAppearace.barTintColor = UIColor(red: 53.0/255.0, green: 168.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

        self.navigationItem.title = "Medicamentos"
    }
    func goBack(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
        O método irá buscar os dados do medicamento que estão na base de dados
     */
    func buscaMedicamentos(){
        print("aki na busca")
       // user.medicamento.removeAll()
        let url = UrlWS()
        Alamofire.request(.GET, url.urlBuscaMedicamentoUsuario(user.email)).responseJSON { (response) in
            if let JSON = response.result.value{
                print("entrou")
                if JSON.count != nil{
                    print("tem alguma coisa no json")
                    print(JSON.count,"<---.--")
                    if let medicamentos:NSArray = (JSON["medicamento"] as? NSArray){
                       print("tem medicamento")
                        for i in medicamentos{
                          print("dentro do for")
                            let medicamentoAux = Medicamento()
                            
                            if let apresentacao = i["apresentacao"] as? String{
                                medicamentoAux.apresentacao = apresentacao
                            }
                            if let codBarras = i["codigoBarras"] as? String{
                                medicamentoAux.codBarras = codBarras
                            }
                            if let nome = i["nomeProduto"] as? String{
                                medicamentoAux.nome = nome
                            }
                            if let principioAtivo = i["principioAtivo"] as? String{
                                medicamentoAux.principioAtivo = principioAtivo
                            }
                            if let laboratorio = i["laboratorio"] as? String{
                                medicamentoAux.laboratorio = laboratorio
                            }
                            if let classeTerapeutica = i["classeTerapeutica"] as? String{
                                medicamentoAux.classeTerapeutica = classeTerapeutica
                            }
                            if let fotoString = i["fotoMedicamentoString"] as? String{
                                var img = UIImage();
                                img = self.util.convertStringToImage(fotoString)
                                medicamentoAux.fotoMedicamento = img
                                
                            }
                            self.user.medicamento.append(medicamentoAux)
                            
                            
                        }//fecha o for
                    }
                    for remedio in self.user.medicamento{
                        print(remedio.nome)
                        self.imgArray.append(remedio.fotoMedicamento)
                        self.nomes.append(remedio.nome)
                    }
                    self.collectionView.reloadData()
                    
                }else{
                    print("nao tem medicamentos")
                }
                
            }
           
        }
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
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let resultViewController = storyBoard.instantiateViewControllerWithIdentifier("cadastrarMedicamento") as! CadastrarMedicamentoViewController
            
            resultViewController.str = "deve cadastrar"
            
            let navController = UINavigationController(rootViewController: resultViewController) // Creating a navigation controller with resultController at the root of the navigation stack.
            
            self.presentViewController(navController, animated:true, completion: nil)


        }else{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let result = storyBoard.instantiateViewControllerWithIdentifier("cadastrarMedicamento") as! CadastrarMedicamentoViewController
                result.str = "apenas vizualizar"
            self.presentViewController(result, animated:true, completion:nil)
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
