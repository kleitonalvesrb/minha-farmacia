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
    
    func validaTamanhoCampo(str: String, tamanhoMin: Int) -> Bool{
        return str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).characters.count >= tamanhoMin
    }
    func trataDataExtenso(dataString: String) -> NSDate{
        var varString = dataString.stringByReplacingOccurrencesOfString("de", withString: "")
        varString = varString.stringByReplacingOccurrencesOfString("  ", withString: " ")
        let arr = varString.componentsSeparatedByString(" ")
        let dataString = "\(arr[0])-\(getNumberOfMonth(arr[1]))-\(arr[2])"
        return dateFormatter(dataString)
        
    }
    func dateFormatter(dataCadastro: String) -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        var date2:NSDate!
        date2 = dateFormatter.dateFromString(dataCadastro)
        return date2
    }
    func getNumberOfMonth(month: String) -> Int{
        switch month {
        case "jan":
            return 1
        case "fev","feb":
            return 2
        case "mar":
            return 3
        case "abr","apr":
            return 4
        case "mai","may":
            return 5
        case "jun":
            return 6
        case "jul":
            return 7
        case "ago","aug":
            return 8
        case "set","sep":
            return 9
        case "out","oct":
            return 10
        case "nov":
            return 11
        case "dez","dec":
            return 12
        default:
            return 0
        }
    }

    /**
     Método responsavel por receber uma string e retornar uma data
     */
    func trataStringData(dataString: String) -> NSDate{
        print("AKIIIIIIIII--->",dataString)
        //1995-03-01T00:00:00Z
        //2016-09-16T21:09:22.031-03:00
        let dateString = dataString
        //let dateString = "1995-03-01T00:00:00" // Data de entrada
        let dateFormatter = NSDateFormatter() //Instância do date Formatter
        //Aqui você DEVE indicar qual formato é sua data de entrada.
        //Se caso não for do formato que você colocou, ocorrerá uma exception!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        //Aqui você está Convertendo sua date String para uma data válida
        let date:NSDate
        date = dateFormatter.dateFromString(dateString)!
        //Aqui você está mudando o formato que você quer retornar
        dateFormatter.dateFormat = "dd/MM/yyyy"
        //Aqui você está convertendo a data que você transformou para date em String no formato "novo" que você modificou acima.
        //        print(dateFormatter.stringFromDate(date)) // Saída: 16/09/2016
        
        return date
        
    }
    /**
     método responsavel por formatar a data no padrao para apresentar ao usuario
     */
    func formataDataPadrao(data: NSDate) -> String{
        
        let dateString = "\(data)"
        let dateFormatter = NSDateFormatter() //Instância do date Formatter
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        let date = dateFormatter.dateFromString(dateString)
        dateFormatter.dateFormat = "dd/MM/yyyy"
       return dateFormatter.stringFromDate(date!)
 
    }
    /**
     método responsavel por formatar a data no padrao para apresentar ao usuario
     */
    func formataDataHoraPadrao(data: NSDate) -> String{
        
        let dateString = "\(data)"
        let dateFormatter = NSDateFormatter() //Instância do date Formatter
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        let date = dateFormatter.dateFromString(dateString)
        dateFormatter.dateFormat = "dd/MM HH:mm"
        return dateFormatter.stringFromDate(date!)
        
    }
    /**
        método responsavel por tratar a data de cadastro da receita, recebe como string e retorna dd/mm/yyyy hh:mm
     */
    func formataDataCadastroReceita(dataString: String) ->NSDate{
    
       var dataCadastro = dataString[dataString.startIndex.advancedBy(0)...dataString.startIndex.advancedBy(18)]
        
        dataCadastro = dataCadastro.stringByReplacingOccurrencesOfString("T", withString: " ")
        
        
        let dateFormatter = NSDateFormatter() //Instância do date Formatter
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.dateFromString(dataCadastro)!
        
    }
    func formataPadraoCompleto(str: String)->String{
        print("----> \(str)")
        let dateFormatter = NSDateFormatter() //Instância do date Formatter
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        let date: NSDate!
        date = dateFormatter.dateFromString(str)
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter.stringFromDate(date)

    }
    
    func qtdDiasEntreDuasDatas(dataInicio: NSDate, ate dataFim:NSDate) -> Int{
//        let start = "1995-03-01"
//        let end = "2016-10-18"
        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        
//        let startDate:NSDate = dateFormatter.dateFromString("\(dataInicio)")!
//        let endDate:NSDate = dateFormatter.dateFromString(""dataFim)!
        
        let cal = NSCalendar.currentCalendar()
        
        
        let unit:NSCalendarUnit = .Day
        
        let components = cal.components(unit, fromDate: dataInicio, toDate: dataFim, options: .MatchFirst)
                
        return components.day
    }
    func trocaEspacoBranco(str: String, trocarPor caracter:String)->String{
        return str.stringByReplacingOccurrencesOfString(" ", withString: caracter)
    }
    func isVazio(txt : String) -> Bool{
         return txt.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
    }
    /**
        Configura label de informação que será apresentada no momento que o usuario interagir com o app
     */
    func configuraLabelInformacao(label: UILabel, comInvisibilidade visibilidadeLabel:Bool, comIndicador indicador:UIActivityIndicatorView, comInvisibilidade visibilidadeIndicator:Bool, comAnimacao animacao:Bool){
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20
        label.hidden = visibilidadeLabel
        indicador.hidden = visibilidadeIndicator
        if animacao {
            indicador.startAnimating()
        }else{
            indicador.stopAnimating()
        }
        
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
    /**
        Converte uma imagem e data para salvar no banco de dados
     */
    func convertImageToNSData(image: UIImage) -> NSData{
        return UIImageJPEGRepresentation(image, 0.5)!
    }
    /**
        Converte nsdata em imagem
     */
    func convertNSDataToImage(imageData: NSData)->UIImage{
        return UIImage(data: imageData)!
    }
    /**
        Retorna o valor real em ML
     */
    func valorQuantidadeDoseMlAndGotas(qtd: String) -> Double{
        return Double(qtd.componentsSeparatedByString(" ")[0])!
    }
    /**
        Retorna o valor de dias em inteiro, retornará 1000 dias caso seja necessario tomar todos os dias
     */
    func valorTempoDias(qtd: String) -> Int{
        if qtd == "Todos os Dias"{
                print("todos os dias <----")
            return 1000
        }
        return Int(qtd.componentsSeparatedByString(" ")[0])!
    }
    /**
        Retornar o intervalo de horas
     */
    func valorIntervalo(qtd: String) -> Int{
        return Int(qtd.componentsSeparatedByString(" ")[0])!
    }
    func valorStringQuantidadeComprimido(qtd: Double)->String{
        let valor = "\(qtd)"
        print(valor)
        switch valor {
        case "0.25":
            return "1/4"
        case "0.3333333333":
            return "1/3"
        case "0.5":
            return "1/2"
        case "1.0":
            return "1"
        case "1.25":
            return "1 + 1/4"
        case "1.3333333333":
            return "1 + 1/3"
        case "1.5":
            return "1 + 1/3"
        case "2.0":
            return "2"
        case "2.25":
            return "2 + 1/4"
        case "2.3333333333":
            return "2 + 1/3"
        case "2.5":
            return "2 + 1/2"
        case "3.0":
            return "3"
        case "3.25":
            return "3 + 1/4"
        case "3.3333333333":
            return "3 + 1/3"
        case "3.5":
            return "3 + 1/2"
        case "4.0":
            return "4"
        default:
            if qtd >  0.3 && qtd < 0.4{
                return "1/3"
            }else if qtd > 1.3 && qtd < 1.4{
                return "1 + 1/3"
            }else if qtd > 2.3 && qtd < 2.4{
                return "2 + 1/3"
            }else if qtd > 3.3 && qtd < 3.4{
                return "3 + 1/3"
            }else{
                return "1"
            }
        }
    }
    /**
        Retornar o valor real dos comprimido
     */
    func valorQuantidadeDoseComprimido(qtd: String) -> Double{
        var valorReal:Double;
        switch qtd {
        case "1/4":
            valorReal = 1/4
            break
        case "1/3":
            valorReal = 1/3
            break
        case "1/2":
            valorReal = 1/2
            break
        case "1":
            valorReal = 1
            break
        case "1 1/4":
            valorReal = 1 + 1/4
            break
        case "1 1/3":
            valorReal = 1 + 1/3
            break
        case "1 1/2":
            valorReal = 1 + 1/2
            break
        case "2":
            valorReal = 2
            break
        case "2 1/4":
            valorReal = 2 + 1/4
            break
        case  "2 1/3":
            valorReal = 2 + 1/3
            break
        case "2 1/2":
            valorReal = 2 + 1/2
            break
        case "3":
            valorReal = 3
            break
        case "3 1/4":
            valorReal = 3 + 1/4
            break
        case "3 /1/3":
            valorReal = 3 + 1/3
            break
        case "3 1/2":
            valorReal = 3 + 1/2
            break
        case "4":
            valorReal = 4
            
        default:
            valorReal = 0
        }
        return valorReal
    }
  
    

    
}
