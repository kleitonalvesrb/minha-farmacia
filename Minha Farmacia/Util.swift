//
//  Util.swift
//  Farmácia
//
//  Created by Kleiton Batista on 30/07/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

class Util: NSObject {
    
    func isVazio(txt : String) -> Bool{
            return txt == ""
    }
  
    /**
        Converte uma string base64 em uma imagem
     */
    func convertStringToImage(str: String) -> UIImage{
        let imageData = NSData(base64EncodedString: str, options: .IgnoreUnknownCharacters)
        let imageConvertida = UIImage(data:imageData!)
        
        return imageConvertida!
    }
    /**
        Converte uma imagem em String de base 64
     */
    func convertImageToString(image: UIImage) -> String{
        print("convertendo para base64")
        let image : NSData = UIImageJPEGRepresentation(image, 0.1)!
        
        let base64String = image.base64EncodedStringWithOptions([])
        return base64String
    }
    
  
    

    
}
