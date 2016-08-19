//
//  MedicamentoViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 17/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import Photos
class MedicamentoViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    @IBOutlet weak var collectionView: UICollectionView!
    var imgArray = [UIImage]()
    var nomes = ["Kleiton","Anna","Meg","Dina","Arnaldo","Thiago","Franciele","Kelly", "Thaynara"]
    var destination = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        collectionView.dataSource = self
    
        let imgPlus:UIImageView = UIImageView()
        imgPlus.image = UIImage(named: "plus2.png")
        imgArray.append(imgPlus.image!)
        
        
        grabPhotos()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

        self.navigationItem.title = "Medicamentos"
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.title = "voltar"
    }
    func goBack(){
        dismissViewControllerAnimated(true, completion: nil)
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
