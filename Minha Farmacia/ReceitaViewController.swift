//
//  ReceitaViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 17/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import Photos
class ReceitaViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var imgArray = [UIImage]()
    var nomes = ["Kleiton","Anna","Meg","Diná","Arnaldo"]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Configurando a primeira imagem
        let imgPlus = UIImageView()
        imgPlus.image = UIImage(named: "plus2.png")
        imgArray.append(imgPlus.image!)
        grabPhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    /**
     tirar a barra de status do iphone
     */
    override func prefersStatusBarHidden() -> Bool {
        return true
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
